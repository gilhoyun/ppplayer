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
import com.example.demo.service.TeamReplyService;
import com.example.demo.util.Util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.Builder.Default;

@Controller
public class UsrTeamReplyController {

	private TeamReplyService teamReplyService;
	private MemberService memberService;

	public UsrTeamReplyController(TeamReplyService teamReplyService, MemberService memberService) {
		this.teamReplyService = teamReplyService;
		this.memberService = memberService;
	}

	@PostMapping("/usr/teamReply/doWrite")
	@ResponseBody
	public String doWrite(HttpServletRequest req, int relId, String body) {

		Rq rq = (Rq) req.getAttribute("rq");
		
		teamReplyService.replyWrite(rq.getLoginedMemberId(), relId, body);
		
		return Util.jsReturn(String.format("댓글을 작성했습니다."), String.format("../team/detail?id=%d", relId));	 
	}
	
	
	@PostMapping("/usr/teamReply/doModify")
    @ResponseBody
    public String doModify(int id, int relId, String body) {
        teamReplyService.modifyReply(id, body);

        return Util.jsReturn(String.format("%d번 댓글을 수정했습니다", id), String.format("../team/detail?id=%d", relId));
    }

	@GetMapping("/usr/teamReply/doDelete")
	@ResponseBody
	public String doDelete(int id, int relId) {

		teamReplyService.deleteReply(id);

		return Util.jsReturn(String.format("%d번 댓글을 삭제했습니다", id), String.format("../team/detail?id=%d", relId));
	}

}
