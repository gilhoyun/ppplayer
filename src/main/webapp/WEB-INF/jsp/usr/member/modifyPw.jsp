<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<c:set var="pageTitle" value="비밀번호 확인" />

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<script>
const modifyPwForm_onSubmit = async function(form) {
form.loginPw.value = form.loginPw.value.trim();
form.loginPwChk.value = form.loginPwChk.value.trim();

if (form.loginPw.value.length == 0) {
alert('변경할 비밀번호를 입력해주세요');
form.loginPw.focus();
return;
}

if (form.loginPw.value != form.loginPwChk.value) {
alert('비밀번호가 일치하지 않습니다');
form.loginPw.value = '';
form.loginPw.focus();
return;
}

form.submit();
}
</script>

<section class="py-8 ">
	<div class="max-w-3xl mx-auto p-6 bg-white rounded-lg shadow-md">
		<form action="doModifyPw" method="post"
			onsubmit="modifyPwForm_onSubmit(this); return false;">
			<div class="table-box">
				<table class="w-full text-left border-collapse">
					<tr>
						<th
							class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">변경할
							비밀번호</th>
						<td class="py-2 px-4"><input
							class="input input-bordered w-full max-w-xs" type="text"
							name="loginPw" placeholder="변경할 비밀번호를 입력해주세요" /></td>
					</tr>
					<tr>
						<th
							class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">비밀번호
							확인</th>
						<td class="py-2 px-4"><input
							class="input input-bordered w-full max-w-xs" type="text"
							name="loginPwChk" placeholder="비밀번호 확인을 입력해주세요" /></td>
					</tr>
					<tr>
						<td colspan="2">
							<div class="flex justify-end mt-4">
								<button
									class="px-6 py-2 bg-stone-400 text-white rounded hover:bg-stone-500 transition">확인</button>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</form>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>