package com.example.demo.service;

import org.springframework.stereotype.Service;
import com.example.demo.dao.ChatDao;
import com.example.demo.dto.Chat;
import com.example.demo.dto.ChatRoom;
import com.example.demo.dto.Member;

import java.util.List;

@Service
public class ChatService {

	private final ChatDao chatDao;

	public ChatService(ChatDao chatDao) {
		this.chatDao = chatDao;
	}

	public ChatRoom createChatRoom(ChatRoom chatRoom) {
		chatDao.insertChatRoom(chatRoom);
		return chatRoom;
	}

	public List<ChatRoom> findAllChatRooms() {
		return chatDao.selectAllChatRooms();
	}

	public ChatRoom findChatRoomById(String roomId) {
		return chatDao.selectChatRoomById(roomId);
	}

	public void saveMessage(Chat chat) {
		chatDao.insertMessage(chat);
	}

	public List<Chat> getChatHistory(String roomId) {
		return chatDao.selectChatHistory(roomId);
	}

	public void addMemberToRoom(String roomId, String memberId) {
		chatDao.insertMemberToRoom(roomId, memberId);
	}

	public boolean isMemberOfRoom(String roomId, String memberId) {
		List<Member> members = chatDao.selectRoomMembers(roomId);
		if (members == null) {
			return false; // 채팅방에 멤버가 없으면 false 반환
		}
		return members.stream().anyMatch(member -> member.getId() == Integer.parseInt(memberId));
	}

	public List<Member> getRoomMembers(String roomId) {
		return chatDao.selectRoomMembers(roomId);
	}

	public List<Member> getAllMembers() {
		return chatDao.selectAllMembers(); // 모든 회원을 조회하는 메소드 호출
	}

	public void updateParticipantCount(String roomId) {
		int memberCount = chatDao.countRoomMembers(roomId);
		chatDao.updateParticipantCount(roomId, memberCount);
	}

	public List<ChatRoom> findChatRoomsForMember(int memberId) {
		return chatDao.selectChatRoomsForMember(memberId);
	}

	public Member getMemberById(String memberId) {
		return chatDao.selectMemberById(memberId);
	}

	public void deleteChatRoom(String roomId) {
		chatDao.deleteMessagesByRoomId(roomId);
		chatDao.deleteChatRoom(roomId);

	}

	public void removeMemberFromRoom(String roomId, String memberId) {
		chatDao.deleteMemberFromRoom(roomId, memberId);
	}
	
}