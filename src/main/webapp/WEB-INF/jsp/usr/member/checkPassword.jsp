<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<c:set var="pageTitle" value="비밀번호 확인" />

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<script>
	const loginForm_onSubmit = function(form) { 
		form.loginId.value = form.loginId.value.trim();
		form.loginPw.value = form.loginPw.value.trim();

		if (form.loginId.value == 0) {
			alert('아이디를 입력해주세요.');
			form.loginId.focus(); // 커서 다시 아이디로 이동
			return;
		}

		if (form.loginPw.value == 0) {
			alert('비밀번호를 입력해주세요.');
			form.loginPw.focus(); // 커서 다시 비밀번호로 이동
			return;
		}
		
		

		form.submit(); 

	}
</script>


<section class="px-auto py-8">
	<div class="max-w-2xl mx-auto p-6 bg-white rounded-lg shadow-md">
		<form action="doLogin" method="post"
			onsubmit="loginForm_onSubmit(this); return false;">
			<div class="table-box">
				<table class="w-full text-left border-collapse">
						<tr>
							<th class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">비밀번호</th>
							<td class="py-2 px-4"><input name="loginPw" type="text"
								class="input input-bordered w-full max-w-xs" placeholder="비밀번호를 입력해주세요." /></td>
						</tr>
				</table>
			</div>
		</form>
	</div>
</section>





<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
