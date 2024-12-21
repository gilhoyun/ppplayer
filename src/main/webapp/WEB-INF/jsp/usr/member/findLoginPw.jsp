<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<c:set var="pageTitle" value="비밀번호 찾기" />

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<script>
	const findLoginPw = async function() {
		let inputLoginId = $("input[name='loginId']");
		let inputEmail = $("input[name='email']");
		
		let inputLoginIdTrim = inputLoginId.val(inputLoginId.val().trim());
		let inputEmailTrim = inputEmail.val(inputEmail.val().trim());
		
		if (inputLoginIdTrim.val().length == 0) {
			alert('아이디를 입력해주세요');
			inputLoginId.focus();
			return;
		}
		
		if (inputEmailTrim.val().length == 0) {
			alert('이메일을 입력해주세요');
			inputEmail.focus();
			return;
		}

		$('#findBtn').prop('disabled', true);
		$('#loading').show();
		
		const rs = await doFindLoginPw(inputLoginIdTrim.val(), inputEmailTrim.val());

		if (rs) {
			alert(rs.resultMsg);
			$('#loading').hide();
			$('#findBtn').prop('disabled', false);
			if (rs.success) {
				location.replace("login");
			} else {
				inputLoginId.val('');
				inputEmail.val('');
				inputLoginId.focus();
			}
		}
	}
	
	const doFindLoginPw = function(loginId, email) {
		return $.ajax({
			url : '/usr/member/doFindLoginPw',
			type : 'GET',
			data : {
				loginId : loginId,
				email : email
			},
			dataType : 'json'
		})
	}
</script>

<section class="px-auto py-8 mt-5">
	<div class="max-w-2xl mx-auto p-6 bg-white rounded-lg shadow-md">
		<div class="table-box">
			<table class="w-full text-left border-collapse">
				<tr>
					<th class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">아이디</th>
					<td class="py-2 px-4"><input class="border p-2 rounded w-full" type="text" name="loginId" placeholder="아이디를 입력해주세요."/></td>
				</tr>
				<tr>
					<th class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">이메일</th>
					<td class="py-2 px-4"><input class="border p-2 rounded w-full" type="text" name="email" placeholder="이메일을 입력해주세요."/></td>
				</tr>
			</table>
			<div class="flex justify-end mt-4">
				<button id="findBtn" onclick="findLoginPw();" class="px-6 py-2 bg-stone-400 text-white rounded hover:bg-stone-500 transition">비밀번호 찾기</button>
			</div>
			<div id="loading" class="mt-2">
				<div class="spinner"></div>
				<p>작업을 처리 중입니다. 잠시만 기다려주세요...</p>
			</div>
		</div>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>