#include <WiFi.h>
#include <WebServer.h>

const char* ssid = "YOUR WIFI NAME";
const char* password = "YOUR WIFI PASSWORD";
  int receivedNumber;

int digitPins[3] = { 15, 2, 4 };                     // D1, D2, D3 (for at most 3 digit numbers)
int segmentPins[7] = { 16, 17, 5, 18, 19, 21, 22 };  // A, B, C, D, E, F, G
// Those index values may change depends on how you connect 7 segment display to ESP32, for this project, segment A connected to GPIO Pin 16.
// A common-cathode 7 segment display is used for this project.
byte digits[10][7] = {
  { 1, 1, 1, 1, 1, 1, 0 },  // 0
  { 0, 1, 1, 0, 0, 0, 0 },  // 1
  { 1, 1, 0, 1, 1, 0, 1 },  // 2
  { 1, 1, 1, 1, 0, 0, 1 },  // 3
  { 0, 1, 1, 0, 0, 1, 1 },  // 4
  { 1, 0, 1, 1, 0, 1, 1 },  // 5
  { 1, 0, 1, 1, 1, 1, 1 },  // 6
  { 1, 1, 1, 0, 0, 0, 0 },  // 7
  { 1, 1, 1, 1, 1, 1, 1 },  // 8
  { 1, 1, 1, 1, 0, 1, 1 }   // 9
};
const int ledPin = 23;

WebServer server(80);
void displayDigit(int digit, int pos) {
    
    for (int i = 0; i < 3; i++) {
      digitalWrite(digitPins[i], HIGH);  // Pasif et
    }

    
    for (int i = 0; i < 7; i++) {
      digitalWrite(segmentPins[i], digits[digit][i]);
    }

    
    digitalWrite(digitPins[pos], LOW);  
    delay(5);
    digitalWrite(digitPins[pos], HIGH);  
  }
void handleNumber() {
  String numStr;
  bool parseSuccess = false;
  if (server.hasArg("value")) {
    numStr = server.arg("value");

    parseSuccess = true;
  } else {
    Serial.println("Error, cannot find the parameter "value".");
    server.send(400, "text/plain", "Bad Request: Missing value.");
    return;  // Fonksiyondan çık
  }

  if (parseSuccess) {
    receivedNumber = numStr.toInt();  
	
	
	// If there is a mistake during toInt() conservation, resulting value will be zero.
    
    if (receivedNumber == 0 && numStr != "0") {
      Serial.println("Hata: Geçersiz sayı formatı.");
      server.send(400, "text/plain", "Bad Request: Geçersiz sayı formatı. Lütfen geçerli bir tamsayı gönderin.");
      return;  // Fonksiyondan çık
    }
    if(receivedNumber<1000){
      server.send(200, "text/plain", "Number " + String(receivedNumber) + " is taken successfully.");
   
    }
  }
}
  void setup() {
    // put your setup code here, to run once:
    Serial.begin(115200);
    pinMode(ledPin, OUTPUT);
    digitalWrite(ledPin, LOW);

    Serial.print("WiFi connection..");
    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.print(".");
    }
    for (int i = 0; i < 3; i++) {
      pinMode(digitPins[i], OUTPUT);
      digitalWrite(digitPins[i], HIGH);  // Hepsini pasif yap
    }

    for (int i = 0; i < 7; i++) {
      pinMode(segmentPins[i], OUTPUT);
      digitalWrite(segmentPins[i], LOW);
    }
    Serial.println("");
    Serial.print("ESP32 IP Adresi: ");
    Serial.println(WiFi.localIP());

    server.on("/led/on", HTTP_GET, []() {
      digitalWrite(ledPin, HIGH);
      server.send(200, "text/plain", "LED ON");
    });

    server.on("/led/off", HTTP_GET, []() {
      digitalWrite(ledPin, LOW);
      server.send(200, "text/plain", "LED OFF");
    });

    server.on("/setDisplay", HTTP_GET, handleNumber);

    server.onNotFound([]() {
      server.send(404, "text/plain", "Couldn't find the page.");
    });
    server.begin();  // Web sunucusunu başlat
    Serial.println("HTTP server has started.");
  }

  

  void loop() {
    // put your main code here, to run repeatedly:
    server.handleClient();

    if(receivedNumber<1000){
    int hundreds = receivedNumber / 100;
    int tens = (receivedNumber / 10) % 10;
    int ones = receivedNumber % 10;
    displayDigit(hundreds, 0);  // D1
    displayDigit(tens, 1);      // D2
    displayDigit(ones, 2);
    }
  }
