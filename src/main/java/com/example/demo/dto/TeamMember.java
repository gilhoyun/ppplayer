package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TeamMember {
	private int id;
	private int teamId;
	private int memberId;
	private String slogan;
	private byte[] teamImage;
	private int createdBy;
	private String role; 
	private String status; 
	private String regDate;
	private String updateDate;
	private String memberName;
}
