package com.example.demo.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.Article;
import com.example.demo.dto.Board;
import com.example.demo.dto.Reply;
import com.example.demo.dto.Rq;
import com.example.demo.service.ArticleService;
import com.example.demo.service.ReplyService;
import com.example.demo.util.Util;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class UsrArticleController {

	private ArticleService articleService;
	private ReplyService replyService;
	
	public UsrArticleController(ArticleService articleService, ReplyService replyService) {
		this.articleService = articleService;
		this.replyService = replyService;
	}

	@GetMapping("/usr/article/write")
	public String write() {

		return "usr/article/write";
	}
	
	@PostMapping("/usr/article/doWrite")
	@ResponseBody
	public String doWrite(HttpServletRequest req, int boardId ,String title, String body) {

		Rq rq = (Rq) req.getAttribute("rq");

		articleService.writeArticle(rq.getLoginedMemberId(), boardId, title, body);

		int id = articleService.getLastInsertId();

		return Util.jsReturn(String.format("%d번 게시물을 작성했습니다.", id), String.format("detail?id=%d", id));
	}
	


	@GetMapping("/usr/article/list")
	public String showList(Model model, int boardId, @RequestParam(defaultValue = "1") int page, @RequestParam(defaultValue = "title")String searchType, @RequestParam(defaultValue = "")String searchKeyword) {
		
		Board board = articleService.getBoardId(boardId);
		
		int limitFrom =  (page - 1) * 10;
		
		List<Article> articles = articleService.getArticles(boardId, limitFrom, searchType, searchKeyword);		
		int articlesCnt = articleService.articlesCnt(boardId, searchType, searchKeyword);
		
		int totalPagesCnt = (int) Math.ceil((double)articlesCnt / 10); 
		
		int from = ((page - 1) / 5) * 5 + 1;
	    int end = from + 4; 
		
		if(end > totalPagesCnt) {
			end = totalPagesCnt;
		}
		
		model.addAttribute("board", board);
		model.addAttribute("articles", articles);
		model.addAttribute("articlesCnt", articlesCnt);
		model.addAttribute("totalPagesCnt", totalPagesCnt);
		model.addAttribute("from", from);
		model.addAttribute("end", end);
		model.addAttribute("page", page);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchKeyword", searchKeyword);
		
		return "usr/article/list";
	}

	@GetMapping("/usr/article/detail")
	public String showDetail(HttpServletRequest req, HttpServletResponse resp, Model model, int id) {
		
		Cookie[] cookies = req.getCookies();
		boolean isViewed = false;

		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if (cookie.getName().equals("viewedArticle_" + id)) {
					isViewed = true;
					break;
				}
			}
		}

		if (!isViewed) {
			articleService.increaseViews(id);
			Cookie cookie = new Cookie("viewedArticle_" + id, "true");
			cookie.setMaxAge(60*30);
			resp.addCookie(cookie);
		}
	
		Article article = articleService.getArticlebyId(id);
		
		List<Reply> replies = replyService.getReplies("article", id);
		
		model.addAttribute("article", article);
		model.addAttribute("replies", replies);

		return "usr/article/detail";
	}
	
	@GetMapping("/usr/article/modify")
	public String modify(Model model, int id) {
		
		Article article = articleService.getArticlebyId(id);
		
		model.addAttribute("article", article);
		
		return "usr/article/modify";
	}

	@PostMapping("/usr/article/doModify")
	@ResponseBody
	public String doModify(HttpServletRequest req, int id, String title, String body) {
		
		Rq rq = (Rq) req.getAttribute("rq");

		Article article = articleService.getArticlebyId(id);

		if (article == null) {
			return Util.jsReturn(String.format("%d번 게시물은 존재하지않습니다.", article.getId()), "/");
		}

		if (rq.getLoginedMemberId() != article.getMemberId()) {
			return Util.jsReturn("해당 게시글에 대한 권한이 없습니다", "/");
		}

		articleService.doModify(id, title, body);

		return Util.jsReturn(String.format("%d번 게시물을 수정했습니다.", article.getId()), String.format("detail?id=%d", id));

	}
//	114번째 줄 = 수정후 다시 디테일로 돌아가기
	
	@GetMapping("/usr/article/doDelete")
	@ResponseBody
	public String doDelete(HttpSession session, int id, int boardId) { // 데이터가 없어서 안써도 되지만 노란줄 신경쓰이면 아무거나 쓰면 됨

		articleService.doDelete(id);

		return Util.jsReturn(String.format("%d번 게시물을 삭제했습니다.", id), String.format("list?boardId=%d", boardId));

	}

}
