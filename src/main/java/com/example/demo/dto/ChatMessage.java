package com.example.demo.dto;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ChatMessage {
	 private Long id;            // 메시지 고유 ID
	    private String roomId;      // 채팅방 ID
	    private String sender;      // 보낸 사람 (회원 ID)
	    private String content;     // 메시지 내용
	    private LocalDateTime  timestamp; // 메시지 전송 시간
	    private boolean isRead;     
}
