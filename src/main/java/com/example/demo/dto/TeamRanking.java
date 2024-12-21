package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TeamRanking {
    private int id;
	private String teamName;
	private int wins;
	private int draws;
    private int losses;
    private int points;
}
