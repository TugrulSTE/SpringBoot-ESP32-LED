package com.esp32spring.communication_led;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
@RequestMapping("/api/led")
public class LedController {

    private final String ESP32ADDRESS = "YOUR ESP32 ADDRESS";

    private final RestTemplate rt = new RestTemplate();

    @GetMapping("/control/{param}")
    public String controlled(@PathVariable String param) {
        String esp32_url = "";

        if ("on".equalsIgnoreCase(param)) {
            esp32_url = "http://" + ESP32ADDRESS + "/led/on";
        } else if ("off".equalsIgnoreCase(param)) {
            esp32_url = "http://" + ESP32ADDRESS + "/led/off";
        } else {
            return ("Geçersiz Adres");
        }
        try {
            String esp32res = rt.getForObject(esp32_url, String.class);
            return "Yanıt " + esp32res;
        } catch (Exception e) {
            return "Cannot communicate";
        }

    }

    @GetMapping("/setDisplay")
    public String seven_segment_controller(@RequestParam(name = "value") int num) {
        String esp32_url = "";

        if (num < 1000 && num >= 0) {
            try {
                esp32_url = "http://" + ESP32ADDRESS + "/setDisplay?value=" + String.valueOf(num);
                String esp32res = rt.getForObject(esp32_url, String.class);
                return "Yanıt " + esp32res;
            } catch (Exception e) {
                e.printStackTrace();
                return "Not an integer value";
            }
        }

        else {
            return ("Invalid Address");
        }
        

    }

}
