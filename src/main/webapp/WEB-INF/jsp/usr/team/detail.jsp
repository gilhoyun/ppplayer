<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<c:set var="pageTitle" value="팀 상세보기" />

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<script>

	
const replyForm_onSubmit = function(form) {
	form.body.value = form.body.value.trim();

	if (form.body.value == 0) {
		alert('내용을 입력해주세요.');
		form.body.focus();
		return;
	}
	form.submit();

}

$(document).ready(function() {
	if (${rq.getLoginedMemberId() != -1 }) {
		getLoginId();
	}
	
	getLikePoint();
})

const getLoginId = function() {
	$.ajax({
		url : '/usr/member/getLoginId',
		type : 'GET',
		dataType : 'text',
		success : function(data) {
			$('#loginedMemberLoginId').html(data);
		},
		error : function(xhr, status, error) {
			console.log(error);
		}
	})
}

let originalForm = null;
let originalId = null;

const teamReplyModifyForm = function(i, body) {
    if (originalForm != null) {
        teamReplyModifyCancle(originalId);
    }

    let replyForm = $('#' + i);

    originalForm = replyForm.html();
    originalId = i;

    let addHtml = `
        <form action="/usr/teamReply/doModify" method="post" onsubmit="teamReplyForm_onSubmit(this); return false;" style="width: 100%;">
            <input type="hidden" name="id" value="\${i}" />
            <input type="hidden" name="relId" value="${team.getId()}" />
            <div class="border-2 border-slate-200 rounded-xl px-4 py-4 mt-2">
                <div id="loginedMemberLoginId" class="mt-3 mb-2 font-semibold"></div>
                <textarea 
                    name="body" 
                    class="textarea textarea-bordered w-full resize-none p-2" 
                    style="height: 120px; font-size: 14px;">\${body}</textarea>
                <div class="flex justify-end mt-2">
                    <button type="button" onclick="teamReplyModifyCancle(\${i});" class="btn btn-sm bg-stone-500 hover:bg-stone-600 text-white mr-2">취소</button>
                    <button type="submit" class="btn btn-sm bg-stone-500 hover:bg-stone-600 text-white">수정</button>
                </div>
            </div>
        </form>`;

    replyForm.html(addHtml);
    getLoginId();
};

const teamReplyModifyCancle = function(i) {
    let replyForm = $('#' + i);
    
    replyForm.html(originalForm);
    
    originalForm = null;
    originalId = null;
}
	

</script>


<section class="py-8 ">
	<div class="max-w-4xl mx-auto p-6 bg-white rounded-lg shadow-md">
		<h2 class="text-2xl font-semibold text-gray-800 mb-6">팀 살펴보기</h2>
		<table class="w-full text-left border-collapse">
			<thead>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">창단일</th>
					<td class="p-4">${team.regDate.substring(2,16)}</td>
				</tr>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">수정일</th>
					<td class="p-4">${team.updateDate.substring(2,16)}</td>
				</tr>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">팀장</th>
					<td class="p-4">${team.getTeamLeaderLoginId()}</td>
				</tr>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">팀
						명</th>
					<td class="p-4">${team.teamName}</td>
				</tr>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">지역</th>
					<td class="p-4">${team.region}</td>
				</tr>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">슬로건</th>
					<td class="p-4">${team.slogan}</td>
				</tr>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">조회수</th>
					<td class="p-4">${team.views}</td>
				</tr>
				<c:if test="${rq.getLoginedMemberId() != -1 and not rq.hasTeam() and not rq.isMemberOfAnyTeam()}">
					<tr class="border-b">
						<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">팀
							가입</th>
						<td class="p-4"><a
							href="/usr/team/requestJoin?teamId=${team.id}"
							onclick="return confirm('이 팀에 가입 요청하시겠습니까?');"
							class="px-4 py-2 bg-stone-400 text-white rounded hover:bg-stone-500 transition">
								가입 요청 </a></td>
					</tr>
				</c:if>
			</thead>
		</table>
	</div>
</section>

<section>
	<div class="max-w-4xl mx-auto p-6 bg-white rounded-lg shadow-md">
		<h2 class="text-2xl font-semibold text-gray-800 mb-6">팀 댓글</h2>

		<!-- Display existing team replies -->
		<c:forEach var="reply" items="${replies}">
			<div id="${reply.getId()}"
				class="py-2 border-b-2 border-slate-200 flex items-start space-x-4">
				<!-- User profile image -->
				<div class="avatar">
					<div
						class="w-12 h-12 rounded-full border border-gray-300 overflow-hidden">
						<img
							src="${pageContext.request.contextPath}/usr/member/profileImage?memberId=${reply.memberId}"
							alt="User Profile"
							onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/resources/images/default-profile.png'; console.log('Failed to load profile image for memberId: ${reply.memberId}');"
							class="object-cover w-full h-full" />
					</div>
				</div>

				<!-- Reply content -->
				<div class="flex-grow">
					<div class="flex justify-between items-center">
						<div class="font-semibold">${reply.getLoginId()}</div>
						<c:if test="${rq.getLoginedMemberId() == reply.memberId}">
							<div class="dropdown mr-2">
								<div tabindex="0" role="button"
									class="btn btn-sm btn-circle btn-ghost m-1">
									<svg xmlns="http://www.w3.org/2000/svg" fill="none"
										viewBox="0 0 24 24"
										class="inline-block h-5 w-5 stroke-current">
                     <path stroke-linecap="round"
											stroke-linejoin="round" stroke-width="2"
											d="M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z"></path>
                   </svg>
								</div>
								<ul tabindex="0"
									class="dropdown-content menu bg-base-100 rounded-box z-[1] w-24 p-2 shadow">
									<li><button
											onclick="teamReplyModifyForm(${reply.getId()}, '${reply.getBody()}');">수정</button></li>
									<li><a
										onclick="if(confirm('정말 삭제하시겠습니까?') == false) return false;"
										href="/usr/teamReply/doDelete?id=${reply.getId()}&relId=${team.getId()}">삭제</a></li>
								</ul>
							</div>
						</c:if>
					</div>
					<div class="text-lg my-1 ml-2">${reply.getForPrintBody()}</div>
					<div class="text-xs text-gray-400">${reply.getRegDate().substring(2,16)}</div>
				</div>
			</div>
		</c:forEach>

		<!-- Reply input form for logged-in users -->
		<c:if test="${rq.getLoginedMemberId() != -1}">
			<form action="/usr/teamReply/doWrite" method="post"
				onsubmit="teamReplyForm_onSubmit(this); return false;">
				<input name="relTypeCode" type="hidden" value="team" /> <input
					name="relId" type="hidden" value="${team.id}" />
				<div class="table-box">
					<table class="w-full text-left border-collapse">
						<thead>
							<tr>
								<textarea style="resize: none;" name="body"
									class="border p-2 rounded w-full" placeholder="내용을 입력해주세요."></textarea>
								<div class="flex justify-end mt-4">
									<button type="submit"
										class="px-6 py-2 bg-stone-400 text-white rounded hover:bg-stone-500 transition">작성</button>
								</div>
							</tr>
						</thead>
					</table>
				</div>
			</form>
		</c:if>
	</div>
</section>






<!-- //댓글의 input relId,relTypeCode를 가지고 controller에서 쓴다 -->





<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
