#include <WiFi.h>
#include <HTTPClient.h>

// Replace with your Wi-Fi credentials
const char* ssid = "your_SSID";
const char* password = "your_PASSWORD";

const String FIRESTORE_URL = "https://firestore.googleapis.com/v1/projects/soothesync-3fc95/databases/(default)/documents/anxiety_logs";
const String FIREBASE_ID_TOKEN = "AIzaSyBycYKnN_69C_WkHicMXe0IdREtHUZcsn8";

// Sample data to send
int anxietyScore = 3;
int oxygenLevel = 80;  // in mg
int HRV = 100;  // Example time

void setup() {
  // Start Serial Monitor
  Serial.begin(115200);

  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");

  // Send data to Firestore
  sendDataToFirestore(anxietyScore, oxygenLevel, HRV);
}

void loop() {
  // Keep the loop empty or perform other actions if necessary
}

void sendDataToFirestore(int anxietyScore, int oxygenLevel, int HRV) {
  // Prepare the data in JSON format
  String jsonPayload = "{\"fields\": {\"anxietyScore\": {\"integerValue\": \"" + anxietyScore + "\"}, \"oxygenLevel\": {\"integerValue\": " + oxygenLevel + "}, \"HRV\": {\"integerValue\": \"" + HRV + "\"}}}";

  // Make HTTP request
  HTTPClient http;
  http.begin(FIRESTORE_URL);  // Initialize the Firestore URL
  http.addHeader("Content-Type", "application/json");  // Set content-type header
  http.addHeader("Authorization", "Bearer " + FIREBASE_ID_TOKEN);  // Set the Authorization header with Firebase ID token

  // Send HTTP POST request to Firestore
  int httpResponseCode = http.POST(jsonPayload);
  
  // Check for response
  if (httpResponseCode > 0) {
    Serial.println("Data sent successfully");
    Serial.println("Response code: " + String(httpResponseCode));
  } else {
    Serial.println("Error in sending data to Firestore");
    Serial.println("Response code: " + String(httpResponseCode));
  }

  // End the HTTP connection
  http.end();
}