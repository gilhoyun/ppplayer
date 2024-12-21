package com.example.demo.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.dto.Member;
import com.example.demo.dto.ResultData;
import com.example.demo.dto.Rq;
import com.example.demo.service.MemberService;
import com.example.demo.util.Util;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsrMemberController {

    private MemberService memberService;

    public UsrMemberController(MemberService memberService) {
        this.memberService = memberService;
    }

    @GetMapping("/usr/member/join")
    public String join() {
        return "usr/member/join";
    }

    @PostMapping("/usr/member/doJoin")
    @ResponseBody
    public String doJoin(String loginId, String loginPw, String name, String email,@RequestParam("profileImage") MultipartFile profileImage) {
        byte[] profileImageData = null;

        try {
            if (!profileImage.isEmpty()) {
                profileImageData = profileImage.getBytes(); // 파일 데이터를 바이트 배열로 변환
            }
        } catch (IOException e) {
            e.printStackTrace();
            return Util.jsReturn("파일 업로드 실패", null);
        }

        memberService.joinMember(loginId, Util.encryptSHA256(loginPw), name, email,profileImageData);

        return Util.jsReturn(String.format("%s님의 가입을 환영합니다~", loginId), "/");
    }

    @GetMapping("/usr/member/getMemberById")
    @ResponseBody
    public ResultData<Member> getMemberById(HttpServletRequest req) {
        Rq rq = (Rq) req.getAttribute("rq");

        Member member = memberService.getMemberById(rq.getLoginedMemberId());

        return ResultData.from("S-1", "회원정보 조회", member);
    }

    @GetMapping("/usr/member/profileImage")
    @ResponseBody
    public ResponseEntity<byte[]> getProfileImage(@RequestParam("memberId") int memberId) {
        Member member = memberService.getMemberById(memberId);

        if (member == null || member.getProfileImage() == null) {
            // 기본 프로필 이미지를 반환
            try {
                File defaultImage = new File("path/to/default/avatar.jpg"); // 기본 이미지 경로
                byte[] defaultImageBytes = Files.readAllBytes(defaultImage.toPath());
                return ResponseEntity.ok()
                        .contentType(MediaType.IMAGE_JPEG)
                        .body(defaultImageBytes);
            } catch (IOException e) {
                e.printStackTrace();
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
            }
        }

        return ResponseEntity.ok()
                .contentType(MediaType.IMAGE_JPEG)
                .body(member.getProfileImage());
    }
	
	@GetMapping("/usr/member/login")
	public String login() {
		return "usr/member/login";
	}
	
	@PostMapping("/usr/member/doLogin")
	@ResponseBody
	public String doLogin(HttpServletRequest req, String loginId, String loginPw) {
		
		Rq rq = (Rq) req.getAttribute("rq");
		
		Member member = memberService.getMemberByLoginId(loginId);
		
		if (member == null) {
			return Util.jsReturn(String.format("[ %s ] 은(는) 존재하지 않는 아이디입니다", loginId), null);
		}
		
		if (member.getLoginPw().equals(Util.encryptSHA256(loginPw)) == false) {
			return Util.jsReturn("비밀번호를 확인해주세요", null);
		}
		
		rq.login(member.getId());
		
		return Util.jsReturn(String.format("%s님 환영합니다~", member.getName()), "/");
	}
	
	@GetMapping("/usr/member/doLogout")
	@ResponseBody
	public String doLogout(HttpServletRequest req) {
		Rq rq = (Rq) req.getAttribute("rq");
		
		rq.logout();
		
		return Util.jsReturn("정상적으로 로그아웃 되었습니다", "/");
	}
	
	@GetMapping("/usr/member/loginIdDupChk")
	@ResponseBody
	public ResultData loginIdDupChk(String loginId) {
		
		Member member = memberService.getMemberByLoginId(loginId);
		
		if (member != null) {
			return ResultData.from("F-1", String.format("[ %s ]은(는) 이미 사용중인 아이디입니다", loginId));
		}
		
		return ResultData.from("S-1", String.format("[ %s ]은(는) 사용가능한 아이디입니다", loginId));
	}
	
	@GetMapping("/usr/member/myPage")
	public String myPage(HttpServletRequest req, Model model) {
		Rq rq = (Rq) req.getAttribute("rq");
		Member member = memberService.getMemberById(rq.getLoginedMemberId());
		
		model.addAttribute("member", member);
		
		return "usr/member/myPage";
	}
	
	@GetMapping("/usr/member/checkPw")
	public String checkPw() {
		return "usr/member/checkPw";
	}
	
	@PostMapping("/usr/member/doCheckPw")
	public String doCheckPw() {
		return "usr/member/modifyPw";
	}
	
	@PostMapping("/usr/member/doModifyPw")
	@ResponseBody
	public String doModifyPw(HttpServletRequest req, String loginPw) {
		Rq rq = (Rq) req.getAttribute("rq");
		
		memberService.modifyPassword(rq.getLoginedMemberId(), Util.encryptSHA256(loginPw));
		
		rq.logout();
		return Util.jsReturn("비밀번호 수정이 완료되었습니다. 다시 로그인 해주세요", "login");
	}
	
	@GetMapping("/usr/member/getLoginId")
	@ResponseBody
	public String getLoginId(HttpServletRequest req) {
		Rq rq = (Rq) req.getAttribute("rq");

		Member member = memberService.getMemberById(rq.getLoginedMemberId());

		return member.getLoginId();
	}
	
	@GetMapping("/usr/member/findLoginId")
	public String findLoginId() {
		return "usr/member/findLoginId";
	}
	
	@GetMapping("/usr/member/doFindLoginId")
	@ResponseBody
	public ResultData doFindLoginId(String name, String email) {
		
		Member member = memberService.getMemberByNameAndEmail(name, email);
		
		if (member == null) {
			return ResultData.from("F-1", "입력하신 정보와 일치하는 회원이 없습니다");
		}
		
		return ResultData.from("S-1", String.format("회원님의 아이디는 [ %s ] 입니다", member.getLoginId()));
	}
	
	@GetMapping("/usr/member/findLoginPw")
	public String findLoginPw() {
		return "usr/member/findLoginPw";
	}
	
	@GetMapping("/usr/member/doFindLoginPw")
	@ResponseBody
	public ResultData doFindLoginPw(String loginId, String email) {
		
		Member member = memberService.getMemberByLoginId(loginId);
		
		if (member == null) {
			return ResultData.from("F-1", "입력하신 아이디와 일치하는 회원이 없습니다");
		}
		
		if (member.getEmail().equals(email) == false) {
			return ResultData.from("F-2", "이메일이 일치하지 않습니다");
		}
		
		String tempPassword = Util.createTempPassword();
		
		try {
			memberService.sendPasswordRecoveryEmail(member, tempPassword);
		} catch (Exception e) {
			return ResultData.from("F-3", "임시 패스워드 발송에 실패했습니다");
		}
		
		memberService.modifyPassword(member.getId(), Util.encryptSHA256(tempPassword));
		
		return ResultData.from("S-1", "회원님의 이메일주소로 임시 패스워드가 발송되었습니다");
	}
	
}
