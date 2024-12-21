package com.example.demo.controller;

import java.io.IOException;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.example.demo.service.MemberService;
import com.example.demo.util.Util;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsrKakaoController {

	 private MemberService memberService;

	 @Value("${kakao.client_id}")
	    private String client_id;

	  @Value("${kakao.redirect_uri}")
	  private String redirect_uri;
	
	public UsrKakaoController(MemberService memberService) {
	    this.memberService = memberService;
	}

	 @GetMapping("/usr/kakao/login")
	    public String kakaoLogin(@RequestParam("code") String code, HttpServletRequest req) {
	        // 카카오 OAuth2 인증 코드로 액세스 토큰 요청
	        String tokenUrl = "https://kauth.kakao.com/oauth/token";
	        
	        HttpHeaders headers = new HttpHeaders();
	        headers.add("Content-Type", "application/x-www-form-urlencoded");

	        String body = "grant_type=authorization_code&"
	                    + "client_id=" + client_id + "&"
	                    + "redirect_uri=" + redirect_uri + "&"
	                    + "code=" + code;

	        HttpEntity<String> entity = new HttpEntity<>(body, headers);
	        RestTemplate restTemplate = new RestTemplate();

	        ResponseEntity<String> response = restTemplate.exchange(tokenUrl, HttpMethod.POST, entity, String.class);

	        // 토큰 처리 후 카카오 사용자 정보 조회
	        String accessToken = parseAccessToken(response.getBody());
	        return getKakaoUserInfo(accessToken);
	    }

	    private String parseAccessToken(String responseBody) {
	        // responseBody에서 액세스 토큰 파싱 (예: JSON 파싱)
	        String token = responseBody.split(":")[1].split(",")[0].replace("\"", "");
	        return token;
	    }

	    private String getKakaoUserInfo(String accessToken) {
	        String userInfoUrl = "https://kapi.kakao.com/v2/user/me";

	        HttpHeaders headers = new HttpHeaders();
	        headers.add("Authorization", "Bearer " + accessToken);

	        HttpEntity<String> entity = new HttpEntity<>(headers);
	        RestTemplate restTemplate = new RestTemplate();

	        ResponseEntity<String> response = restTemplate.exchange(userInfoUrl, HttpMethod.GET, entity, String.class);

	        // 카카오 사용자 정보 받아오기
	        try {
	            ObjectMapper objectMapper = new ObjectMapper();
	            JsonNode jsonNode = objectMapper.readTree(response.getBody());
	            String email = jsonNode.path("kakao_account").path("email").asText();
	            String name = jsonNode.path("properties").path("nickname").asText();
	            String profileImage = jsonNode.path("properties").path("profile_image").asText();

	            // 카카오로 로그인 시 회원가입 처리
	            String loginId = email;
	            String loginPw = Util.encryptSHA256(UUID.randomUUID().toString());

	            // 프로필 이미지를 다운로드하여 바이트 배열로 변환
	            byte[] profileImageData = downloadImage(profileImage);

	            memberService.joinMember(loginId, loginPw, name, email, profileImageData);

	            // 회원가입 후 로그인 처리 (optional)
	            return "redirect:/usr/member/login";
	        } catch (Exception e) {
	            e.printStackTrace();
	            return "redirect:/usr/member/login?error=true";
	        }
	    }

	    // 이미지 다운로드 메서드 추가
	    private byte[] downloadImage(String imageUrl) throws IOException {
	        RestTemplate restTemplate = new RestTemplate();
	        byte[] imageBytes = restTemplate.getForObject(imageUrl, byte[].class);
	        return imageBytes;
	    }
	}
