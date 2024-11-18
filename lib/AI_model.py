from pyngrok import ngrok 
from flask import Flask, request, jsonify
from flask_cors import CORS
import os
from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain_community.vectorstores import FAISS
from langchain_community.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.prompts import PromptTemplate
from langchain_community.llms import CTransformers
from langchain.chains import RetrievalQA

port_no = 5000

# Define the PDF file path and vectorstore directory
PDF_PATH = 'PDF_PATH'  # Update with your PDF file path
DB_FAISS_PATH = 'vectorstore/db_faiss'  # Directory where FAISS index will be saved

# Custom prompt template
custom_prompt_template = """Use the following pieces of information to answer the user's question.
If you don't know the answer, just say that you don't know, don't try to make up an answer.

Context: {context}
Question: {question}

Only return the helpful answer below and nothing else.
Helpful answer:
"""

def set_custom_prompt():
    prompt = PromptTemplate(template=custom_prompt_template, input_variables=['context', 'question'])
    return prompt

def create_vector_db(pdf_path):
    os.makedirs(os.path.dirname(DB_FAISS_PATH), exist_ok=True)
    loader = PyPDFLoader(pdf_path)
    documents = loader.load()
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
    texts = text_splitter.split_documents(documents)
    embeddings = HuggingFaceEmbeddings(model_name='sentence-transformers/all-MiniLM-L6-v2', model_kwargs={'device': 'cpu'})
    db = FAISS.from_documents(texts, embeddings)
    db.save_local(DB_FAISS_PATH)

def load_vector_db():
    embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2", model_kwargs={'device': 'cpu'})
    db = FAISS.load_local(DB_FAISS_PATH, embeddings, allow_dangerous_deserialization=True)
    return db

def load_llm():
    llm = CTransformers(
        model="TheBloke/Llama-2-7B-Chat-GGML",
        model_type="llama",
        max_new_tokens=512,
        temperature=0.5
    )
    return llm

def retrieval_qa_chain(llm, prompt, db):
    qa_chain = RetrievalQA.from_chain_type(
        llm=llm,
        chain_type='stuff',
        retriever=db.as_retriever(search_kwargs={'k': 2}),
        return_source_documents=True,
        chain_type_kwargs={'prompt': prompt}
    )
    return qa_chain

app = Flask(__name__)
CORS(app)

ngrok.set_auth_token("YOUR_AUTH_TOKEN")
public_url = ngrok.connect(port_no).public_url

# Load the vectorstore and model on startup
if not os.path.exists(DB_FAISS_PATH):
    print("Creating vector database...")
    create_vector_db(PDF_PATH)

print("Loading database and model...")
db = load_vector_db()
llm = load_llm()
qa_prompt = set_custom_prompt()
qa = retrieval_qa_chain(llm, qa_prompt, db)

@app.route('/ask', methods=['POST'])
def ask_bot():
    data = request.json
    question = data.get("question", "")
    if not question:
        return jsonify({"error": "No question provided"}), 400

    response = qa({'query': question})
    answer = response['result']
    sources = response.get('source_documents', [])
    sources_list = [doc.metadata.get('source', '') for doc in sources]

    return jsonify({"answer": answer, "sources": sources_list})

if __name__ == '__main__':
    print(f"Colab Public URL: {public_url}")
    app.run(host='0.0.0.0', port=port_no)
