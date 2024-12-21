package com.example.demo.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSocket
@RequiredArgsConstructor
public class WebSocketConfig implements WebSocketConfigurer {
	
	private final ChatWebSocketHandler chatWebSocketHandler;
	
	// 참고한 사이트 : https://adjh54.tistory.com/573#4.%20WebSocketConfig%20%ED%81%B4%EB%9E%98%EC%8A%A4%20%EA%B5%AC%EC%84%B1-1
	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
		registry.addHandler(chatWebSocketHandler, "ws-stomp").setAllowedOrigins("*");
	}
}
