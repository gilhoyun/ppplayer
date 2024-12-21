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

import com.example.demo.dto.Member;
import com.example.demo.dto.Rq;
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
    public String kakaoLoginRedirect() {
        String kakaoAuthUrl = "https://kauth.kakao.com/oauth/authorize"
                + "?client_id=" + client_id
                + "&redirect_uri=" + redirect_uri
                + "&response_type=code";
        
        return "redirect:" + kakaoAuthUrl;
    }

    @GetMapping("/usr/kakao/callback")
    public String kakaoCallback(@RequestParam("code") String code, HttpServletRequest req) {
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
        return processKakaoUser(accessToken, req);
    }

    private String parseAccessToken(String responseBody) {
        // responseBody에서 액세스 토큰 파싱
        String token = responseBody.split(":")[1].split(",")[0].replace("\"", "");
        return token;
    }

    private String processKakaoUser(String accessToken, HttpServletRequest req) {
        String userInfoUrl = "https://kapi.kakao.com/v2/user/me";

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);

        HttpEntity<String> entity = new HttpEntity<>(headers);
        RestTemplate restTemplate = new RestTemplate();

        ResponseEntity<String> response = restTemplate.exchange(userInfoUrl, HttpMethod.GET, entity, String.class);

        try {
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode jsonNode = objectMapper.readTree(response.getBody());
            String email = jsonNode.path("kakao_account").path("email").asText();
            String name = jsonNode.path("properties").path("nickname").asText();
            String profileImage = jsonNode.path("properties").path("profile_image").asText();

            // 회원 여부 확인
            Member existingMember = memberService.getMemberByLoginId(email);
            if (existingMember != null) {
                // 이미 회원인 경우 로그인 처리
                Rq rq = (Rq) req.getAttribute("rq");
                rq.login(existingMember.getId());
                return Util.jsReturn(String.format("%s님 환영합니다~", existingMember.getName()), "/");
            }

            // 새로 가입 처리
            String loginPw = Util.encryptSHA256(UUID.randomUUID().toString());
            byte[] profileImageData = downloadImage(profileImage);

            memberService.joinMember(email, loginPw, name, email, profileImageData);

            // 가입 후 로그인 처리
            Member newMember = memberService.getMemberByLoginId(email);
            Rq rq = (Rq) req.getAttribute("rq");
            rq.login(newMember.getId());

            return Util.jsReturn(String.format("%s님 환영합니다~", newMember.getName()), "/");

        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/usr/member/login?error=true";
        }
    }

    private byte[] downloadImage(String imageUrl) throws IOException {
        RestTemplate restTemplate = new RestTemplate();
        return restTemplate.getForObject(imageUrl, byte[].class);
    }
}