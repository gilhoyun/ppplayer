<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<section class="px-auto py-8">
	<div class="max-w-4xl mx-auto p-6 bg-white rounded-lg shadow-md">
		<div class="container mx-auto p-4">
			<div class="flex items-center justify-between mb-4">
				<h2 class="text-2xl font-bold">${room.roomName}</h2>
				<c:if test="${room.createdBy eq rq.getLoginedMemberId()}">
					<button id="deleteRoomButton"
						class="btn btn-danger bg-red-400 text-white rounded hover:bg-red-500 btn-sm">
						<i class="fa-solid fa-right-from-bracket"></i>
					</button>
				</c:if>
				<c:if test="${room.createdBy ne rq.getLoginedMemberId()}">
					<button id="exitRoomButton"
						class="btn btn-warning bg-yellow-400 text-white rounded hover:bg-yellow-500 btn-sm">
						<i class="fa-solid fa-right-from-bracket"></i>
					</button>
				</c:if>
			</div>
			<div class="mb-4">
				<h3 class="text-lg font-semibold">
					대화 상대 :
					<c:forEach var="member" items="${roomMembers}">
						<span class="ml-2">${member.loginId},</span>
					</c:forEach>
				</h3>
			</div>

			<div class="mb-4" style="display: none;">
				<div>
					현재 로그인된 회원의 ID : <span id="userId">${rq.getLoginedMemberId()}</span>
				</div>
				<div>
					현재 채팅방 ID : <span id="roomId">${room.roomId}</span>
				</div>
			</div>

			<div id="chatMessages"
				class="h-96 overflow-y-auto mb-4 border p-4 rounded">
				<c:forEach var="message" items="${chatHistory}">
					<div
						class="chat ${message.sender eq rq.getLoginedMemberId() ? 'chat-end' : 'chat-start'}">
						<div class="chat-image avatar">
							<div class="w-10 rounded-full">
								<!-- Display profile image -->
								<img
									src="<c:url value='/usr/member/profileImage?memberId=${message.sender}' />"
									alt="User Avatar" />
							</div>
						</div>
						<div class="chat-header">
							<time class="text-xs opacity-50">${message.formattedTimestamp}</time>
						</div>
						<div class="chat-bubble">${message.content}</div>
						<div class="chat-footer opacity-50">${message.senderName}</div>
					</div>
				</c:forEach>
			</div>

			<div class="flex items-center space-x-2">
				<input type="text" id="messageInput"
					class="input input-bordered w-full" placeholder="메시지를 입력하세요" />
				<button id="sendMessage"
					class="btn bg-stone-400 text-white rounded hover:bg-stone-500">
					<i class="fa-regular fa-paper-plane"></i>
				</button>
			</div>
		</div>
	</div>
</section>


<script>
$(function() {
    const socket = new SockJS('/ws-stomp');
    const stompClient = Stomp.over(socket);
    const userId = $('#userId').text();
    const roomId = $('#roomId').text();

    stompClient.connect({}, function() {
        // Subscribe to the room-specific chat channel
        stompClient.subscribe(`/sub/chat/${roomId}`, function(message) {
            const chatMessage = JSON.parse(message.body);
            if (chatMessage) {
                appendMessage(chatMessage);
            }
        }, function(error) {
            console.error('WebSocket subscription error:', error);
            alert('채팅 연결에 문제가 발생했습니다. 다시 시도해주세요.');
        });
    }, function(error) {
        console.error('WebSocket connection error:', error);
        alert('채팅 서버 연결에 실패했습니다. 다시 로그인해주세요.');
    });

    $('#sendMessage').click(sendMessage);
    $('#messageInput').keypress(function(e) {
        if (e.which == 13) {  // Enter key
            sendMessage();
        }
    });

    function sendMessage() {
        const messageInput = $('#messageInput');
        const content = messageInput.val().trim();

        if (content) {
            const chatMessage = {
                sender: userId,
                content: content,
                roomId: roomId
            };

            // Send message via WebSocket
            stompClient.send('/pub/chat/send', {}, JSON.stringify(chatMessage));

            // Clear input
            messageInput.val('');
        }
    }

    function appendMessage(message) {
        const chatMessages = $('#chatMessages');
        const isCurrentUser = message.sender === userId;
        const messageHtml = `
            <div class="chat \${isCurrentUser ? 'chat-end' : 'chat-start'}">
                <div class="chat-image avatar">
                    <div class="w-10 rounded-full">
                        <img src="/path/to/default/avatar.jpg" alt="User Avatar" />
                    </div>
                </div>
                <div class="chat-header">
                    \${message.sender}
                    <time class="text-xs opacity-50">\${new Date().toLocaleTimeString()}</time>
                </div>
                <div class="chat-bubble">\${message.content}</div>
                <div class="chat-footer opacity-50">Delivered</div>
            </div>
        `;
        chatMessages.append(messageHtml);
        chatMessages.scrollTop(chatMessages[0].scrollHeight);
    }
});

$('#deleteRoomButton').click(function() {
    if (confirm('채팅방을 삭제하시겠습니까?')) {
        $.ajax({
            url: `/usr/chat/room/${roomId}/delete`,
            type: 'POST',
            success: function(response) {
                if (response.status === 'success') {
                    alert('채팅방이 삭제되었습니다.');
                    window.location.href = '/usr/chat/rooms';  // Redirect to chat rooms list
                } else {
                    alert(response.message);
                }
            },
            error: function() {
                alert('채팅방 삭제에 실패했습니다.');
            }
        });
    }
});

$('#exitRoomButton').click(function() {
    if (confirm('채팅방을 나가시겠습니까?')) {
        $.ajax({
            url: `/usr/chat/room/${roomId}/exit`,
            type: 'POST',
            success: function(response) {
                if (response.status === 'success') {
                    alert('채팅방에서 나갔습니다.');
                    window.location.href = '/usr/chat/rooms';  // Redirect to chat rooms list
                } else {
                    alert(response.message);
                }
            },
            error: function() {
                alert('채팅방에서 나가는데 실패했습니다.');
            }
        });
    }
});
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>