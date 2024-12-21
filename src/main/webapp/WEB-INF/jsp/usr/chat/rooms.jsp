<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<section class="px-auto py-8">
	<div class="max-w-4xl mx-auto p-6 bg-white rounded-lg shadow-md">
		<div class="flex justify-between items-center mb-4">
			<h2 class="text-2xl font-bold">채팅</h2>
			<c:if test="${rq.getLoginedMemberId() != -1}">
				<button id="createRoomBtn"
					class="btn bg-stone-400 text-white rounded hover:bg-stone-500 btn-sm">
					채팅방 생성</button>
			</c:if>
		</div>
		<div id="chatRoomList" class="space-y-4">
			<c:forEach var="room" items="${rooms}">
				<div class="card bg-base-100 shadow-xl">
					<div class="card-body">
						<h3 class="card-title">${room.roomName}</h3>
						<p>참여 인원: ${room.participantCount}명</p>
						<div class="card-actions justify-end">
							<a href="/usr/chat/room/${room.roomId}"
								class="btn bg-stone-400 text-white rounded hover:bg-stone-500">
								입장 </a>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>

		<!-- Create Room Modal -->
		<dialog id="createRoomModal" class="modal">
		<div class="modal-box">
			<h3 class="font-bold text-lg">새 채팅방 만들기</h3>
			<div class="form-control w-full">
				<label class="label"> <span class="label-text">채팅방 이름</span>
				</label> <input type="text" id="roomNameInput"
					class="input input-bordered w-full" placeholder="채팅방 이름을 입력하세요" />
			</div>

			<!-- 초대할 회원 선택 -->
			<div class="form-control w-full mt-4">
				<label class="label"><span class="label-text">초대할 회원</span></label>
				<select id="inviteMembers" class="input input-bordered w-full"
					multiple>
					<!-- Populate with members dynamically -->
					<c:forEach var="member" items="${allMembers}">
						<option value="${member.id}">${member.name}</option>
					</c:forEach>
				</select>
			</div>

			<div class="modal-action">
				<button id="submitRoomBtn"
					class="btn bg-stone-400 text-white rounded hover:bg-stone-500">만들기</button>
				<button onclick="document.getElementById('createRoomModal').close()"
					class="btn bg-red-400 text-white rounded hover:bg-red-500">취소</button>
			</div>
		</div>
		</dialog>
	</div>
</section>

<script>
	$(function() {
		const userId = '${rq.getLoginedMemberId()}';

		$('#createRoomBtn').click(function() {
			document.getElementById('createRoomModal').showModal();
		});

		$('#submitRoomBtn').click(
				function() {
					const roomName = $('#roomNameInput').val().trim();
					const inviteMembers = $('#inviteMembers').val(); // Get selected member IDs

					if (roomName && inviteMembers.length > 0) {
						$.ajax({
							url : '/usr/chat/rooms',
							type : 'POST',
							contentType : 'application/json',
							data : JSON.stringify({
								roomName : roomName,
								createdBy : userId,
								inviteMembers : inviteMembers
							}),
							success : function(response) {
								console.log('Room created:', response);
								console.log('Room ID:', response.roomId);

								// Explicit redirection with full URL
								window.location.href = window.location.origin
										+ '/usr/chat/room/' + response.roomId;
							},
							error : function(xhr, status, error) {
								console.error('Room creation error:',
										xhr.responseText);
								console.error('Status:', status);
								console.error('Error:', error);
								alert('채팅방 생성 중 오류가 발생했습니다.');
							}
						});
					} else {
						alert('채팅방 이름과 초대할 회원을 선택해주세요.');
					}
				});
	});
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
