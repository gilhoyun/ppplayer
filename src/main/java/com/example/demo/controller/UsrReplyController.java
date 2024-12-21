package com.example.demo.controller;

import java.text.Format;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.Article;
import com.example.demo.dto.Board;
import com.example.demo.dto.Member;
import com.example.demo.dto.ResultData;
import com.example.demo.dto.Rq;
import com.example.demo.service.ArticleService;
import com.example.demo.service.MemberService;
import com.example.demo.service.ReplyService;
import com.example.demo.util.Util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.Builder.Default;

@Controller
public class UsrReplyController {

	private ReplyService replyService;
	private MemberService memberService;

	public UsrReplyController(ReplyService replyService, MemberService memberService) {
		this.replyService = replyService;
		this.memberService = memberService;
	}

	@PostMapping("/usr/reply/doWrite")
	@ResponseBody
	public String doWrite(HttpServletRequest req, String relTypeCode, int relId, String body) {

		Rq rq = (Rq) req.getAttribute("rq");
		
		replyService.replyWrite(rq.getLoginedMemberId(), relTypeCode, relId, body);
		
		return Util.jsReturn(String.format("댓글을 작성했습니다."), String.format("../article/detail?id=%d", relId));	 
	}
	
	@PostMapping("/usr/reply/doModify")
	@ResponseBody
	public String doModify(int id, int relId, String body) {

		replyService.modifyReply(id, body);

		return Util.jsReturn(String.format("%d번 댓글을 수정했습니다", id), String.format("../article/detail?id=%d", relId));
	}

	@GetMapping("/usr/reply/doDelete")
	@ResponseBody
	public String doDelete(int id, int relId) {

		replyService.deleteReply(id);

		return Util.jsReturn(String.format("%d번 댓글을 삭제했습니다", id), String.format("../article/detail?id=%d", relId));
	}

}
