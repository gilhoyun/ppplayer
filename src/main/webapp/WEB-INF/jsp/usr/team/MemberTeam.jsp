<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<c:set var="pageTitle" value="내 팀 목록" />

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<section class="py-8">
	<div class="max-w-4xl mx-auto p-6 bg-white rounded-lg shadow-md">
		<h2 class="text-2xl font-semibold text-gray-800 mb-6">내 팀 정보</h2>

		<c:choose>
			<c:when test="${not empty teams}">
				<c:forEach var="team" items="${teams}">
					<div class="border-b pb-6 mb-6">
						<table class="w-full text-left border-collapse">
							<tr class="border-b">
								<th
									class="text-center p-4 font-medium text-gray-700 bg-gray-100">창단일</th>
								<td class="p-4">${team.regDate.substring(0, 16)}</td>
							</tr>
							<tr class="border-b">
								<th
									class="text-center p-4 font-medium text-gray-700 bg-gray-100">정보
									수정일</th>
								<td class="p-4">${team.updateDate.substring(0, 16)}</td>
							</tr>
							<tr class="border-b">
								<th
									class="text-center p-4 font-medium text-gray-700 bg-gray-100">팀
									명</th>
								<td class="p-4">${team.teamName}</td>
							</tr>
							<tr class="border-b">
								<th
									class="text-center p-4 font-medium text-gray-700 bg-gray-100">지역</th>
								<td class="p-4">${team.region}</td>
							</tr>
							<tr class="border-b">
								<th
									class="text-center p-4 font-medium text-gray-700 bg-gray-100">슬로건</th>
								<td class="p-4">${team.slogan}</td>
							</tr>
						</table>
					</div>
				</c:forEach>
			</c:when>
		</c:choose>
		<div class="flex justify-end mt-4">
			<form action="/usr/teamMember/doDelete" method="post" onsubmit="return confirm('정말 탈퇴하시겠습니까?');">
				<input type="hidden" name="memberId" value="${rq.getLoginedMemberId()}" />
				<button type="submit" class="px-4 py-2 bg-red-400 text-white rounded hover:bg-red-500 transition">탈퇴</button>
			</form>
		</div>


		<c:if test="${not empty approvedMembers}">
			<div class="mt-6">
				<h3 class="text-lg font-semibold text-gray-700 mb-4 text-center">소속
					선수</h3>
				<div class="bg-white shadow rounded-lg overflow-hidden">
					<table class="w-full">
						<thead class="bg-gray-100">
							<tr>
								<th class="p-4 text-center text-sm font-medium text-gray-600">이름</th>
								<th class="p-4 text-center text-sm font-medium text-gray-600">가입
									날짜</th>
								<th class="p-4 text-center text-sm font-medium text-gray-600">역할</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="member" items="${approvedMembers}">
								<tr class="border-b">
									<td class="p-4 text-center">${member.memberName}</td>
									<td class="p-4 text-center">${member.regDate.substring(0, 16)}</td>
									<td class="p-4 text-center"><c:choose>
											<c:when test="${member.role == 'LEADER'}">팀장</c:when>
											<c:otherwise>선수</c:otherwise>
										</c:choose></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</c:if>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
