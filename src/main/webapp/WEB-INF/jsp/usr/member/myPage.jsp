<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<c:set var="pageTitle" value="회원 정보" />

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<script>
	
</script>

<section class="py-8 ">
	<div class="max-w-4xl mx-auto p-6 bg-white rounded-lg shadow-md">
		<h2 class="text-2xl font-semibold text-gray-800 mb-6">마이페이지</h2>
		<table class="w-full text-left border-collapse">
			<thead>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">가입일</th>
					<td class="p-4">${member.getRegDate().substring(0, 16) }</td>
				</tr>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">정보 수정일</th>
					<td class="p-4">${member.getUpdateDate().substring(0, 16) }</td>
				</tr>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">아이디</th>
					<td class="p-4">${member.getLoginId() }</td>
				</tr>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">이름</th>
					<td class="p-4">${member.getName() }</td>
				</tr>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">이메일</th>
					<td class="p-4">${member.getEmail() }</td>
				</tr>
			</thead>
		</table>
		<div class="mt-6 text-right flex justify-between items-center">
			<button onclick="history.back();" class="px-4 py-2 bg-stone-400 text-white rounded hover:bg-stone-500 transition">뒤로가기</button>
            <div class="flex space-x-4">
				<a class="px-4 py-2 bg-stone-400 text-white rounded hover:bg-stone-500 transition" href="checkPw">정보수정</a>
			</div>
		</div>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
