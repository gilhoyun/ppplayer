<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<c:set var="pageTitle" value="상세보기" />

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
	
	const replyModifyForm = function(i, body) {
	    if (originalForm != null) {
	        replyModifyCancle(originalId);
	    }

	    let replyForm = $('#' + i);

	    originalForm = replyForm.html();
	    originalId = i;

	    let addHtml = `
	        <form action="/usr/reply/doModify" method="post" onsubmit="replyForm_onSubmit(this); return false;" style="width: 100%;">
	            <input type="hidden" name="id" value="\${i}" />
	            <input type="hidden" name="relId" value="${article.getId()}" />
	            <div class="border-2 border-slate-200 rounded-xl px-4 py-4 mt-2">
	            <div id="loginedMemberLoginId" class="mt-3 mb-2 font-semibold"></div>
	                <textarea 
	                    name="body" 
	                    class="textarea textarea-bordered w-full resize-none p-2" 
	                    style="height: 120px; font-size: 14px;">\${body}</textarea>
	                <div class="flex justify-end mt-2">
	                    <button type="button" onclick="replyModifyCancle(\${i});" class="btn btn-sm bg-stone-500 hover:bg-stone-600 text-white mr-2">취소</button>
	                    <button type="submit" class="btn btn-sm bg-stone-500 hover:bg-stone-600 text-white">수정</button>
	                </div>
	            </div>
	        </form>`;

	    replyForm.html(addHtml);
	    getLoginId();
	};
	
	
	const replyModifyCancle = function(i) {
		let replyForm = $('#' + i);
		
		replyForm.html(originalForm);
		
		originalForm = null;
		originalId = null;
	}
	
	const clickLikePoint = async function() {
	    let likePointBtn = $('#likePointBtn > i').hasClass('fa-solid'); // 현재 상태 확인

	    await $.ajax({
	        url: '/usr/likePoint/clickLikePoint',
	        type: 'GET',
	        data: {
	            relTypeCode: 'article',
	            relId: ${article.getId()},
	            likePointBtn: likePointBtn
	        }
	    });

	    await getLikePoint();
	};

	const getLikePoint = function() {
	    $.ajax({
	        url: '/usr/likePoint/getLikePoint',
	        type: 'GET',
	        data: {
	            relTypeCode: 'article',
	            relId: ${article.getId()}
	        },
	        dataType: 'json',
	        success: function(data) {
	            $('#likeCnt').html(data.data); // 좋아요 개수 업데이트

	            const heartIcon = $('#heartIcon'); // 아이콘 선택

	            if (data.success) {
	                // 좋아요 상태
	                heartIcon.removeClass('fa-regular fa-heart text-gray-500')
	                         .addClass('fa-solid fa-heart text-red-500');
	            } else {
	                // 좋아요 해제 상태
	                heartIcon.removeClass('fa-solid fa-heart text-red-500')
	                         .addClass('fa-regular fa-heart text-gray-500');
	            }
	        },
	        error: function(xhr, status, error) {
	            console.log(error);
	        }
	    });
	};
	
</script>


<section class="py-8 ">
	<div class="max-w-3xl mx-auto p-6 bg-white rounded-lg shadow-md">
		<h2 class="text-2xl font-semibold text-gray-800 mb-6">게시물 상세보기</h2>
		<table class="w-full text-left border-collapse">
			<thead>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">번호</th>
					<td class="p-4">${article.id}</td>
				</tr>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">작성일</th>
					<td class="p-4">${article.regDate.substring(2,16)}</td>
				</tr>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">수정일</th>
					<td class="p-4">${article.updateDate.substring(2,16)}</td>
				</tr>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">조회수</th>
					<td class="p-4">${article.views}</td>
				</tr>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">작성자</th>
					<td class="p-4">${article.loginId}</td>
				</tr>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">제목</th>
					<td class="p-4">${article.title}</td>
				</tr>
				<tr class="border-b">
					<th class="text-center p-4 font-medium text-gray-700 bg-gray-100">내용</th>
					<td class="p-4 whitespace-pre-wrap">${article.getForPrintBody()}</td>
				</tr>
			</thead>
		</table>

		<!-- 좋아요 버튼을 내용 아래 가운데 정렬 -->
		<div class="mt-6 flex justify-center items-center">
			<c:if test="${rq.getLoginedMemberId() == -1 }">
				<span id="likeCnt"></span>
			</c:if>
			<c:if test="${rq.getLoginedMemberId() != -1 }">
				<button id="likePointBtn"
					class="btn btn-sm text-base bg-transparent hover:bg-transparent active:bg-transparent focus:outline-none focus:ring-0"
					onclick="clickLikePoint();">
					<i id="heartIcon" class="fa-regular fa-heart text-gray-500"></i> <span
						id="likeCnt" class="ml-2"></span>
				</button>
			</c:if>
		</div>

		<div class="mt-6 text-right flex justify-between items-center">
			<div class="flex space-x-4">
				<c:if test="${rq.getLoginedMemberId() == article.getMemberId() }">
					<a onclick="if(confirm('정말 삭제하시겠습니까?') == false) return false;"
						href="doDelete?id=${article.getId()}&boardId=${article.boardId}"
						class="px-4 py-2 bg-red-400 text-white rounded hover:bg-red-500 transition">삭제</a>
				</c:if>
				<c:if test="${rq.getLoginedMemberId() == article.getMemberId() }">
					<a href="modify?id=${article.getId()}"
						class="px-4 py-2 bg-blue-400 text-white rounded hover:bg-blue-500 transition">수정
					</a>
				</c:if>
			</div>
		</div>
	</div>
</section>


<section>
	<div class="max-w-3xl mx-auto p-6 bg-white rounded-lg shadow-md">
		<h2 class="text-2xl font-semibold text-gray-800 mb-6">댓글</h2>

		<c:forEach var="reply" items="${replies}" varStatus="status">
			<div id="${reply.getId()}"
				class="py-4 border-b-2 border-slate-200 flex items-start space-x-4">
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
							<div class="dropdown">
								<div tabindex="0" role="button"
									class="btn btn-sm btn-circle btn-ghost">
									<svg xmlns="http://www.w3.org/2000/svg" fill="none"
										viewBox="0 0 24 24" class="h-5 w-5 stroke-current">
                                        <path stroke-linecap="round"
											stroke-linejoin="round" stroke-width="2"
											d="M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z"></path>
                                    </svg>
								</div>
								<ul tabindex="0"
									class="dropdown-content menu bg-base-100 rounded-box z-[1] w-24 p-2 shadow">
									<li><button
											onclick="replyModifyForm('${reply.getId()}', '${reply.getBody()}');">수정</button></li>
									<li><a
										onclick="if(confirm('정말 삭제하시겠습니까?') == false) return false;"
										href="/usr/reply/doDelete?id=${reply.getId()}&relId=${article.getId()}">삭제</a></li>
								</ul>
							</div>
						</c:if>
					</div>
					<div class="text-lg my-1">${reply.getForPrintBody()}</div>
					<div class="text-xs text-gray-400">${reply.getRegDate().substring(2,16)}</div>
				</div>
			</div>
		</c:forEach>

		<!-- Reply input form -->
		<c:if test="${rq.getLoginedMemberId() != -1}">
			<form action="/usr/reply/doWrite" method="post"
				onsubmit="replyForm_onSubmit(this); return false;">
				<input name="relTypeCode" type="hidden" value="article" /> <input
					name="relId" type="hidden" value="${article.id}" />
				<div>
					<textarea style="resize: none;" name="body"
						class="border p-2 rounded w-full" placeholder="내용을 입력해주세요."></textarea>
					<div class="flex justify-end mt-4">
						<button type="submit"
							class="px-6 py-2 bg-stone-500 text-white rounded hover:bg-stone-600 transition">작성</button>
					</div>
				</div>
			</form>
		</c:if>
	</div>
</section>



<!-- //댓글의 input relId,relTypeCode를 가지고 controller에서 쓴다 -->





<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
