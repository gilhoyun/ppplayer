package com.example.demo.service;


import java.util.List;

import org.springframework.stereotype.Service;

import com.example.demo.dao.ArticleDao;
import com.example.demo.dao.TeamDao;
import com.example.demo.dao.TeamMemberDao;
import com.example.demo.dto.Article;
import com.example.demo.dto.Board;
import com.example.demo.dto.TeamMember;


@Service
public class TeamMemberService {
	
	private TeamMemberDao teamMemberDao;
	
	public TeamMemberService(TeamMemberDao teamMemberDao) {

		this.teamMemberDao = teamMemberDao;
	}

	public void requestJoin(int teamId, Integer memberId) {
		teamMemberDao.requestJoin( teamId,  memberId);
		
	}

	public List<TeamMember> getPendingRequestsByTeamId(int id) {
		
		return teamMemberDao.getPendingRequestsByTeamId(id);
	}

	public void approveMember(int teamMemberId) {
		teamMemberDao.approveMember(teamMemberId);
		
	}

	public void rejectMember(int teamMemberId) {
		teamMemberDao.rejectMember( teamMemberId);
	}

	public List<TeamMember> getApprovedMembersByTeamId(int id) {
		return teamMemberDao.getApprovedMembersByTeamId(id);
	}

	public boolean isUserMemberOfAnyTeam(int loginedMemberId) {

		return teamMemberDao.isUserMemberOfAnyTeam(loginedMemberId);
	}

	public List<TeamMember> getApprovedTeamsByMemberId(Integer loginedMemberId) {
		return teamMemberDao.getApprovedTeamsByMemberId(loginedMemberId);
	}

	public void doDelete(int memberId) {
		teamMemberDao.doDelete(memberId);
		
	}

	
}
