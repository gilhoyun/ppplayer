package com.example.demo.service;


import java.util.List;

import org.springframework.stereotype.Service;

import com.example.demo.dao.ArticleDao;
import com.example.demo.dao.ReplyDao;
import com.example.demo.dao.TeamReplyDao;
import com.example.demo.dto.Article;
import com.example.demo.dto.Board;
import com.example.demo.dto.Reply;
import com.example.demo.dto.TeamReply;


@Service
public class TeamReplyService {
	
	private TeamReplyDao teamReplyDao;
	
	public TeamReplyService(TeamReplyDao teamReplyDao) {

		this.teamReplyDao = teamReplyDao;
	}

	public void replyWrite(int memberId, int relId, String body) {
        teamReplyDao.replyWrite(memberId, body, relId);
    }

    public List<TeamReply> getReplies(int relId) {
        return teamReplyDao.getReplies(relId);
    }

    public void modifyReply(int id, String body) {
        teamReplyDao.modifyReply(id, body);
    }

    public void deleteReply(int id) {
        teamReplyDao.deleteReply(id);
    }
}
