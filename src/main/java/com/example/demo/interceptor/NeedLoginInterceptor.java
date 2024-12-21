package com.example.demo.interceptor;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.example.demo.dto.Rq;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class NeedLoginInterceptor implements HandlerInterceptor {
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		Rq rq = (Rq) request.getAttribute("rq");
		
		if (rq.getLoginedMemberId() == -1) { //로그인 안한 상태
			rq.jsPrintReplace("로그인 후 이용해주세요", "/");
			return false;
		} 
		
		return HandlerInterceptor.super.preHandle(request, response, handler);
	}
}
