<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<c:set var="pageTitle" value="비밀번호 확인" />

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<script>
const checkPwForm_onSubmit = async function(form) {
form.loginPw.value = form.loginPw.value.trim();

if (form.loginPw.value.length == 0) {
alert('비밀번호를 입력해주세요');
form.loginPw.focus();
return;
}

let member = await getMemberById();
let inputLoginPw = await encryptSHA256(form.loginPw.value);

if (member.data.loginPw != inputLoginPw) {
alert('비밀번호가 일치하지 않습니다');
form.loginPw.value = '';
form.loginPw.focus();
return;
}

form.submit();
}

const getMemberById = function() {
return $.ajax({
url : '/usr/member/getMemberById',
type : 'GET',
dataType : 'json'
})
}

async function encryptSHA256(input) {
const encoder = new TextEncoder(); // 입력 문자열을 UTF-8 바이트로 인코딩
const data = encoder.encode(input);

// SHA-256 해싱
const hash = await crypto.subtle.digest("SHA-256", data);

// 해싱 결과를 16진수 문자열로 변환
return Array.from(new Uint8Array(hash))
.map(byte => byte.toString(16).padStart(2, '0')) // 각 바이트를 16진수로 변환
.join('');
}
</script>

<section class="px-auto py-8">
	<div class="max-w-2xl mx-auto p-6 bg-white rounded-lg shadow-md">
		<form action="doCheckPw" method="post"
			onsubmit="checkPwForm_onSubmit(this); return false;">
			<div class="table-box">
				<table class="w-full text-left border-collapse">
					<tr>
						<th
							class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">비밀번호
							확인</th>
						<td class="py-2 px-4"><input class="input input-bordered w-full max-w-xs"
							type="text" name="loginPw" placeholder="비밀번호를 입력해주세요" /></td>
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
		<div class="w-9/12 mx-auto mt-3 text-sm flex justify-between"></div>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>