package com.negociosdanet.config;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.config.server.EnableConfigServer;

import lombok.extern.log4j.Log4j2;

@SpringBootApplication
@EnableConfigServer
@Log4j2
public class ConfigServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(ConfigServerApplication.class, args);
		Runtime.getRuntime().addShutdownHook(
				new Thread(() -> log.info("Shutdown {}", ConfigServerApplication.class.getSimpleName())));
	}
}
