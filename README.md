# CONTROLLING LED / DISPLAY DEVICES ON WI-FI.

## This is an example IOT project to learn communication of different servers via endpoints, and hardware-software integration.



## API Usage

#### LED OPEN

```http
  GET /api/led/control/on
```
As sending this endpoint, Spring Boot send a request to ESP32 server, to conclude with that ESP32 open (HIGH) the GPIO pin which LED is connected to.

#### LED OFF

```http
  GET /api/led/control/off
```

This endpoint allows the Flutter application to send a request to the Spring Boot server. Upon receiving this, Spring Boot forwards a request to the ESP32 server, to conclude with that ESP32 close (LOW) the GPIO pin which LED is connected to.

#### Display Number

```http
  GET /api/led/setDisplay?value={num}
```
ESP32 communicates with 3 digit 7-segment display and shows the number comes from endpoint Spring Boot sent.

The number must be positive and smaller than 1000.

## Missing Configuration Lines 
### WARNING: DO NOT SHARE THESE CONFIGURATIONS PUBLICLY!

communication_led\src\main\java\com\esp32spring\communication_led\LedController.java : You need to fill out ESP32ADDRESS line to send the endpoint to correct address.

FlutterESP32\esp32_led_mobile\lib\main.dart : Similar to above, you need to add your Spring Boot IP address and its port number.

esp32ledcomm.ino : You need to fill out your WI-FI name and password. 


📱 When you press the button on your mobile phone, Flutter application sends an endpoint to Spring Boot servers.

🍃 Spring Boot takes this endpoint and send it to address of ESP32. With this implementation, a request can be sent via another softwares such as Postman except Flutter.

💻 ESP32 GPIO pins connected to a led and a 3 digit 7 segment display, according to the how you connect the display to the pins, you should arrange the arrays in .ino file which must be correspond to true pins.

🔚 Finally, led can be turned on / off or display number via ESP32.

🗒️ Spring Boot must be started and devices should connect to the same Internet devices specified in .ino file.

