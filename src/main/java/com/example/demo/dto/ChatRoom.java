package com.example.demo.dto;

import java.time.LocalDateTime;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ChatRoom {
	private String roomId;
    private String roomName;
    private String createdBy;
    private LocalDateTime createdAt;
    private int participantCount;
    private List<String> inviteMembers;
}
