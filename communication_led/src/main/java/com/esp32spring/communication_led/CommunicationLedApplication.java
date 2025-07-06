package com.esp32spring.communication_led;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})
public class CommunicationLedApplication {

	public static void main(String[] args) {
		SpringApplication.run(CommunicationLedApplication.class, args);
	}

}
