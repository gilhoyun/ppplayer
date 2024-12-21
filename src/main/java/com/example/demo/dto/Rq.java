package com.example.demo.dto;

import java.io.IOException;

import com.example.demo.service.TeamMemberService;
import com.example.demo.service.TeamService;
import com.example.demo.util.Util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.Getter;

public class Rq {

    @Getter
    private int loginedMemberId;

    private HttpServletResponse resp;
    private HttpSession session;
    private TeamService teamService; 
    private TeamMemberService teamMemberService;

    public Rq(HttpServletRequest req, HttpServletResponse resp, TeamService teamService, TeamMemberService teamMemberService) {
        this.session = req.getSession();
        this.teamService = teamService; // TeamService 주입
        this.teamMemberService = teamMemberService;

        int loginedMemberId = -1;

        if (this.session.getAttribute("loginedMemberId") != null) {
            loginedMemberId = (int) this.session.getAttribute("loginedMemberId");
        }

        this.loginedMemberId = loginedMemberId;
        this.resp = resp;
    }

    public void jsPrintReplace(String msg, String uri) {
        resp.setContentType("text/html; charset=UTF-8;");

        try {
            resp.getWriter().append(Util.jsReturn(msg, uri));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void login(int loginedMemberId) {
        this.session.setAttribute("loginedMemberId", loginedMemberId);
    }

    public void logout() {
        this.session.removeAttribute("loginedMemberId");
    }


    public boolean hasTeam() {
        if (this.loginedMemberId == -1) {
            return false; 
        }
        return teamService.hasTeam(this.loginedMemberId);
    }
    
    public boolean isMemberOfAnyTeam() {
        if (this.loginedMemberId == -1) {
            return false; 
        }
        return teamMemberService.isUserMemberOfAnyTeam(this.loginedMemberId);
    }

}
