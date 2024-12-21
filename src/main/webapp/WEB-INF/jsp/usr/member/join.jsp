<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<c:set var="pageTitle" value="회원가입" />

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<script>
	let validLoginId = null;

	const joinForm_onSubmit = function(form) {
		form.loginId.value = form.loginId.value.trim();
		form.loginPw.value = form.loginPw.value.trim();
		form.loginPwChk.value = form.loginPwChk.value.trim();
		form.name.value = form.name.value.trim();

		if (!form.loginId.value) {
			alert('아이디를 입력해주세요.');
			form.loginId.focus();
			return false;
		}

		if (form.loginId.value != validLoginId) {
			alert('사용불가능한 아이디입니다.');
			form.loginId.value = '';
			form.loginId.focus();
			return false;
		}

		if (!form.loginPw.value) {
			alert('비밀번호를 입력해주세요.');
			form.loginPw.focus();
			return false;
		}

		if (!form.loginPwChk.value) {
			alert('비밀번호 확인을 입력해주세요.');
			form.loginPwChk.focus();
			return false;
		}

		if (form.loginPw.value !== form.loginPwChk.value) {
			alert('비밀번호가 일치하지 않습니다.');
			form.loginPw.value = '';
			form.loginPwChk.value = '';
			form.loginPw.focus();
			return false;
		}

		if (!form.name.value) {
			alert('이름을 입력해주세요.');
			form.name.focus();
			return false;
		}
		
		if (!form.email.value) {
			alert('이메일을 입력해주세요.');
			form.email.focus();
			return false;
		}

		if (!form.profileImage.value) {
			alert('프로필 사진을 업로드해주세요.');
			form.profileImage.focus();
			return false;
		}

		return true;
	};

	const loginIdDupChk = function(el) {
	    el.value = el.value.trim();

	    let loginIdDupChkMsg = $('#loginIdDupChkMsg');

	    if (!el.value) {
	        loginIdDupChkMsg.removeClass('text-green-500');
	        loginIdDupChkMsg.addClass('text-red-500');
	        loginIdDupChkMsg.html('아이디는 필수 입력 정보입니다');
	        return;
	    }

	    $.ajax({
	        url: '/usr/member/loginIdDupChk',
	        type: 'GET',
	        data: { loginId: el.value },
	        dataType: 'json',
	        success: function(data) {
	            if (data.success) {
	                loginIdDupChkMsg.removeClass('text-red-500');
	                loginIdDupChkMsg.addClass('text-green-500');
	                loginIdDupChkMsg.text(data.resultMsg);
	                validLoginId = el.value;
	            } else {
	                loginIdDupChkMsg.removeClass('text-green-500');
	                loginIdDupChkMsg.addClass('text-red-500');
	                loginIdDupChkMsg.text(data.resultMsg);
	                validLoginId = null;
	            }
	        },
	        error: function(xhr, status, error) {
	            console.log('Error: ' + error);
	        },
	    });
	};
</script>

<section class="px-auto py-8">
	<div class="max-w-2xl mx-auto p-6 bg-white rounded-lg shadow-md">
		<form action="doJoin" method="post" enctype="multipart/form-data" onsubmit="return joinForm_onSubmit(this);">
			<div class="table-box">
				<table class="w-full text-left border-collapse">
					<thead>
						<tr>
							<th class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">아이디</th>
							<td class="py-2 px-4">
								<input name="loginId" type="text" class="border p-2 rounded w-full" placeholder="아이디를 입력해주세요." onblur="loginIdDupChk(this)" />
								<div id="loginIdDupChkMsg" style="margin-top: 4px; font-size: 0.875rem;"></div>
							</td>
						</tr>
						<tr>
							<th class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">비밀번호</th>
							<td class="py-2 px-4">
								<input name="loginPw" type="password" class="border p-2 rounded w-full" placeholder="비밀번호를 입력해주세요." />
							</td>
						</tr>
						<tr>
							<th class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">비밀번호 확인</th>
							<td class="py-2 px-4">
								<input name="loginPwChk" type="password" class="border p-2 rounded w-full" placeholder="비밀번호를 다시 입력해주세요." />
							</td>
						</tr>
						<tr>
							<th class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">이름</th>
							<td class="py-2 px-4">
								<input name="name" type="text" class="border p-2 rounded w-full" placeholder="이름을 입력해주세요." />
							</td>
						</tr>
						<tr>
							<th class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">이메일</th>
							<td class="py-2 px-4">
								<input name="email" type="text" class="border p-2 rounded w-full" placeholder="이메일을 입력해주세요." />
							</td>
						</tr>
						<tr>
							<th class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">프로필 사진</th>
							<td class="py-2 px-4">
								<input name="profileImage" type="file" accept="image/*" class="border p-2 rounded w-full" />
							</td>
						</tr>
					</thead>
				</table>
			</div>
			<div class="text-right mt-4">
				<button type="submit" class="px-6 py-2 bg-stone-400 text-white rounded hover:bg-stone-500 transition">가입</button>
			</div>
		</form>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
