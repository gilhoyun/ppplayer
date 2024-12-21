package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Article {
	private int id;
	private String regDate;
	private String updateDate;
	private int boardId;
	private int memberId;
	private String title;
	private String body;
	private int views;
	
	private String loginId;
	private int like;
	
	public String getForPrintBody( ) {
		return this.body.replaceAll("\n", "<br />");
	}
}
