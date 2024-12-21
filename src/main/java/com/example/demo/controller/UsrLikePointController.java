package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.LikePoint;
import com.example.demo.dto.ResultData;
import com.example.demo.dto.Rq;
import com.example.demo.service.LikePointService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsrLikePointController {
	
	private LikePointService likePointService;

	public UsrLikePointController(LikePointService likePointService) {
		this.likePointService = likePointService;
	}
	
	@GetMapping("/usr/likePoint/clickLikePoint")
	@ResponseBody
	public String clickLikePoint(HttpServletRequest req, String relTypeCode, int relId, boolean likePointBtn) {

		Rq rq = (Rq) req.getAttribute("rq");

		if (likePointBtn) {
			likePointService.deleteLikePoint(rq.getLoginedMemberId(), relTypeCode, relId);
			return "좋아요 취소";
		}
		
		likePointService.insertLikePoint(rq.getLoginedMemberId(), relTypeCode, relId);
		return "좋아요 추가";
	}
	
	@GetMapping("/usr/likePoint/getLikePoint")
	@ResponseBody
	public ResultData<Integer> getLikePoint(HttpServletRequest req, String relTypeCode, int relId) {
		
		Rq rq = (Rq) req.getAttribute("rq");
		
		LikePoint likePoint = likePointService.getLikePoint(rq.getLoginedMemberId(), relTypeCode, relId);
		int likeCnt = likePointService.getLikePointCnt(relTypeCode, relId);
		
		if (likePoint == null) {
			return ResultData.from("F-1", "좋아요 정보 조회 실패", likeCnt);
		}
		
		return ResultData.from("S-1", "좋아요 정보 조회 성공", likeCnt);
	}
	
}
