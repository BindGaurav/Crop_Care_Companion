from flask import Flask, request, jsonify
from flask_cors import CORS  # Add CORS support
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import RandomizedSearchCV
from sklearn.pipeline import Pipeline
import logging
from datetime import datetime
import os

# Initialize Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    handlers=[
        logging.FileHandler('app.log'),
        logging.StreamHandler()
    ]
)

# Global variables for model and accuracy
best_model = None
model_accuracy = None

def load_and_train_model():
    global best_model, model_accuracy
    
    try:
        # Load the dataset
        file_path = "C:/Users/Gaurav Bind/Downloads/Crop_recommendation.csv"  # Update path as needed
        if not os.path.exists(file_path):
            raise FileNotFoundError(f"Dataset not found at {file_path}")
            
        data = pd.read_csv(file_path)
        logging.info(f"Dataset loaded successfully with {len(data)} records")

        # Remove duplicates
        data.drop_duplicates(subset=['temperature', 'humidity', 'N', 'P', 'K', 'label'], inplace=True)
        logging.info(f"Dataset after removing duplicates: {len(data)} records")

        # Features and target
        X = data[['temperature', 'humidity', 'N', 'P', 'K']]
        y = data['label']

        # Split dataset
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

        # Create and train pipeline
        pipeline = Pipeline([
            ('scaler', StandardScaler()),
            ('lr', LogisticRegression(random_state=42, class_weight='balanced'))
        ])

        param_grid = {
            'lr__C': [0.1, 1.0, 10.0],
            'lr__max_iter': [100, 500, 1000]
        }

        random_search = RandomizedSearchCV(
            pipeline, param_grid, cv=5, 
            scoring='accuracy', n_iter=10, 
            n_jobs=-1, random_state=42
        )
        
        random_search.fit(X_train, y_train)
        best_model = random_search.best_estimator_
        
        # Calculate accuracy
        y_pred = best_model.predict(X_test)
        model_accuracy = accuracy_score(y_test, y_pred)
        
        logging.info(f"Model trained successfully. Accuracy: {model_accuracy:.2f}")
        return True
        
    except Exception as e:
        logging.error(f"Error in model training: {str(e)}")
        return False

# Health check endpoint
@app.route('/health', methods=['GET'])
def health_check():
    if best_model is None:
        return jsonify({"status": "error", "message": "Model not loaded"}), 503
    return jsonify({
        "status": "healthy",
        "model_accuracy": f"{model_accuracy:.2f}",
        "timestamp": datetime.now().isoformat()
    })

# Prediction endpoint
@app.route('/predict', methods=['POST'])
def predict_crop():
    try:
        if best_model is None:
            return jsonify({"status": "error", "message": "Model not initialized"}), 503

        # Get data from request
        data = request.get_json()
        if not data:
            return jsonify({"status": "error", "message": "No data provided"}), 400

        # Validate required fields
        required_fields = ['temperature', 'humidity', 'N', 'P', 'K']
        for field in required_fields:
            if field not in data:
                return jsonify({"status": "error", "message": f"Missing required field: {field}"}), 400

        # Prepare data for prediction
        new_data = np.array([[data['temperature'], data['humidity'], data['N'], data['P'], data['K']]])

        # Make prediction
        prediction = best_model.predict(new_data)[0]
        confidence = best_model.predict_proba(new_data).max()

        # Log prediction
        logging.info(f"Prediction made: {prediction} with confidence {confidence:.2f}")

        # Return result
        return jsonify({
            "status": "success",
            "predicted_crop": prediction,
                       "confidence": round(confidence * 100, 2),
            "timestamp": datetime.now().isoformat()
        })

    except Exception as e:
        logging.error(f"Error in prediction: {str(e)}")
        return jsonify({
            "status": "error",
            "message": "Internal server error"
        }), 500

# Error handlers
@app.errorhandler(404)
def not_found_error(error):
    return jsonify({
        "status": "error",
        "message": "Endpoint not found"
    }), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({
        "status": "error",
        "message": "Internal server error"
    }), 500

if __name__ == '__main__':
    # Load and train model before starting server
    if not load_and_train_model():
        logging.error("Failed to load and train model. Exiting.")
        exit(1)
        
    # Run the app
    app.run(host='0.0.0.0', port=8000, debug=False)