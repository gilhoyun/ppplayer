package com.example.demo.service;


import java.util.List;

import org.springframework.stereotype.Service;

import com.example.demo.dao.ArticleDao;
import com.example.demo.dao.ReplyDao;
import com.example.demo.dto.Article;
import com.example.demo.dto.Board;
import com.example.demo.dto.Reply;


@Service
public class ReplyService {
	
	private ReplyDao replyDao;
	
	public ReplyService(ReplyDao replyDao) {

		this.replyDao = replyDao;
	}

	public void replyWrite(int memberId, String relTypeCode, int relId, String body) {
		replyDao.replyWrite(memberId,  relTypeCode,  relId,  body);
		
	}
	
	public List<Reply> getReplies(String relTypeCode, int relId) {
		return replyDao.getReplies(relTypeCode, relId);
	}
	
	public void modifyReply(int id, String body) {
		replyDao.modifyReply(id, body);
	}

	public void deleteReply(int id) {
		replyDao.deleteReply(id);
	}
}
