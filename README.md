## Overview

This project involves an AI-powered crop prediction system. The app connects to an AI model hosted via Google Colab and provides endpoints for predictions and health checks.

### Configuration

## 1. Setting Up the Local Server
**API Configuration**

The application uses the `ApiConfig` class to define API endpoints. Update the `baseUrl` with your device's IP address or the public URL generated by `ngrok`.

**Code Snippet**
Add the following code to `crop_prediction.dart`:

```dart
class ApiConfig {
  static const String baseUrl = "http://PUT_DEVICE_IP:8000"; // Replace PUT_DEVICE_IP
  static String get predictionEndpoint => "$baseUrl/predict";
  static String get healthEndpoint => "$baseUrl/health";
}
 ``` 

Steps to Configure
Find Your Device IP:

On Windows:

1. Open Command Prompt
2. Run:
```bash
ipconfig
 ``` 
3. Copy the IPv4 Address under your active network.

On Linux:

1. Open Terminal.
2. Run:
```bash
ifconfig
 ```
3. Locate the inet address under your active network adapter.

**Replace PUT_DEVICE_IP:**

1. Open the crop_prediction.dart file in your project.
2. Replace PUT_DEVICE_IP in the baseUrl with the IP address obtained from the above step.

**Save the Changes:**
Save the file and ensure the app rebuilds when running the Flutter app.

## 2. Running the AI Model

The AI model is hosted on Google Colab using the ngrok library to expose a public URL.

Steps to Run the Model
1.Copy the model code into a Google Colab notebook.
2.Install ngrok:
```python
!pip install pyngrok
 ```
3.Run the notebook and note the public URL displayed in the output. Example:

## 3. Update the Public URL
1. Update the baseUrl in chatbot.dart with the ngrok public URL.
```dart
class ChatbotConfig {
  static const String baseUrl = "http://abc123.ngrok.io"; // Replace with your ngrok URL
}
 ```
2. Login or Sign up in https://ngrok.com/ 
3. Get Auth token from there
4. Paste in the python code means in the colab
```python
ngrok.set_auth_token("YOUR_AUTH_TOKEN")
public_url = ngrok.connect(port_no).public_url
 ```
## 4. Running the App
1. Ensure the AI model is running and accessible through the provided URL.
2. Run the Flutter app:
```bash
fLutter run
 ```
## Notes
1. Replace http://PUT_DEVICE_IP:8000 and http://abc123.ngrok.io as necessary.
2. Ensure your device and the app are on the same network for local IPs.
3. Use a stable internet connection for ngrok-based URLs.
