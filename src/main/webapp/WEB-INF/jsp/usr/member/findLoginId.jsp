<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<c:set var="pageTitle" value="아이디 찾기" />

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<script>
	const findLoginId = async function() {
		let inputName = $("input[name='name']");
		let inputEmail = $("input[name='email']");
		
		let inputNameTrim = inputName.val(inputName.val().trim());
		let inputEmailTrim = inputEmail.val(inputEmail.val().trim());
		
		if (inputNameTrim.val().length == 0) {
			alert('이름을 입력해주세요');
			inputName.focus();
			return;
		}
		
		if (inputEmailTrim.val().length == 0) {
			alert('이메일을 입력해주세요');
			inputEmail.focus();
			return;
		}

		const rs = await doFindLoginId(inputNameTrim.val(), inputEmailTrim.val());

		if (rs) {
			alert(rs.resultMsg);
			if (rs.success) {
				location.replace("login");
			} else {
				inputName.val('');
				inputEmail.val('');
				inputName.focus();
			}
		}
	}
	
	const doFindLoginId = function(name, email) {
		return $.ajax({
			url : '/usr/member/doFindLoginId',
			type : 'GET',
			data : {
				name : name,
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
					<th class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">이름</th>
					<td class="py-2 px-4"><input class="border p-2 rounded w-full"
						type="text" name="name" placeholder="이름을 입력해주세요." /></td>
				</tr>
				<tr>
					<th
						class="text-center py-2 px-4 font-medium text-gray-700 bg-gray-100">이메일</th>
					<td class="py-2 px-4"><input class="border p-2 rounded w-full"
						type="text" name="email" placeholder="이메일을 입력해주세요." /></td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="flex justify-end ">
							<button onclick="findLoginId();"
								class="px-6 py-2 bg-stone-400 text-white rounded hover:bg-stone-500 transition">아이디
								찾기</button>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>