package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.Rq;
import com.example.demo.dto.Team;
import com.example.demo.dto.TeamMember;
import com.example.demo.service.TeamMemberService;
import com.example.demo.service.TeamService;
import com.example.demo.util.Util;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsrTeamMemberController {

	private TeamMemberService teamMemberService;
	private TeamService teamService;
	
	public UsrTeamMemberController(TeamMemberService teamMemberService,  TeamService teamService) {
		this.teamMemberService = teamMemberService;
		this.teamService = teamService;
	}

	
	@GetMapping("/usr/teamMember/approve")
	@ResponseBody
    public String approveMember(int teamMemberId) {
        // 가입 요청 승인
        teamMemberService.approveMember(teamMemberId);
        
        return Util.jsReturn("팀 가입 요청을 승인했습니다.", "/usr/team/myTeam");
    }

    @GetMapping("/usr/teamMember/reject")
    @ResponseBody
    public String rejectMember(int teamMemberId) {
        // 가입 요청 거절
        teamMemberService.rejectMember(teamMemberId);
        
        return Util.jsReturn("팀 가입 요청을 거절했습니다.", "/usr/team/myTeam");
    }
    
    @GetMapping("/usr/teamMember/MemberTeam")
    public String MemberTeam(HttpServletRequest req, Model model) {
        Rq rq = (Rq) req.getAttribute("rq");
        Integer loginedMemberId = rq.getLoginedMemberId();

        // 사용자가 승인된 팀 목록 조회
        List<TeamMember> approvedTeams = teamMemberService.getApprovedTeamsByMemberId(loginedMemberId);

        // 팀 정보 가져오기
        List<Team> teams = new ArrayList<>();
        for (TeamMember teamMember : approvedTeams) {
            Team team = teamService.getTeamById(teamMember.getTeamId());
            teams.add(team);
        }
        
        List<TeamMember> approvedMembers = new ArrayList<>();
	    for (Team team : teams) {
	        List<TeamMember> teamApprovedMembers = teamMemberService.getApprovedMembersByTeamId(team.getId());
	        approvedMembers.addAll(teamApprovedMembers);
	    }

        // 모델에 팀 정보 추가
        model.addAttribute("teams", teams);
        model.addAttribute("approvedMembers", approvedMembers);
        return "usr/team/MemberTeam";
    }
    
    @PostMapping("/usr/teamMember/doDelete")
    @ResponseBody
    public String doDelete(int memberId) {

        teamMemberService.doDelete(memberId);
        
        return Util.jsReturn("팀을 탈퇴했습니다.", "/");
    }
    
    
    
   
	
}
