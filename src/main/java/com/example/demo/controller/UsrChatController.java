package com.example.demo.controller;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.Chat;
import com.example.demo.dto.ChatRoom;
import com.example.demo.dto.Member;
import com.example.demo.dto.Rq;
import com.example.demo.service.ChatService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsrChatController {

    private final ChatService chatService;
    private final SimpMessagingTemplate messagingTemplate;

    public UsrChatController(ChatService chatService, SimpMessagingTemplate messagingTemplate) {
        this.chatService = chatService;
        this.messagingTemplate = messagingTemplate;
    }
    


    // Display chat rooms page
    @GetMapping("/usr/chat/rooms")
    public String chatRooms(Model model, HttpServletRequest req) {
    	Rq rq = (Rq) req.getAttribute("rq");
        
      
        List<ChatRoom> rooms = chatService.findChatRoomsForMember(rq.getLoginedMemberId());
        List<Member> allMembers = chatService.getAllMembers();
        
        model.addAttribute("rooms", rooms);
        model.addAttribute("allMembers", allMembers);
        return "usr/chat/rooms";
    }

    // Create a new chat room
    @PostMapping("/usr/chat/rooms")
    @ResponseBody
    public Map<String, String> createChatRoom(@RequestBody ChatRoom chatRoom) {
        chatRoom.setRoomId(UUID.randomUUID().toString());
        chatRoom.setCreatedAt(LocalDateTime.now());
        
        System.out.println("Creating chat room: " + chatRoom);
        System.out.println("Room ID: " + chatRoom.getRoomId());
        
        ChatRoom createdRoom = chatService.createChatRoom(chatRoom);
        
        // Add creator to the room
        chatService.addMemberToRoom(createdRoom.getRoomId(), chatRoom.getCreatedBy());
        
        // Add invited members to the room
        if (chatRoom.getInviteMembers() != null && !chatRoom.getInviteMembers().isEmpty()) {
            for (String memberId : chatRoom.getInviteMembers()) {
                chatService.addMemberToRoom(createdRoom.getRoomId(), memberId);
            }
        }
        
        // Update participant count
        chatService.updateParticipantCount(createdRoom.getRoomId());
        
        // Return a map with room details
        Map<String, String> response = new HashMap<>();
        response.put("roomId", createdRoom.getRoomId());
        response.put("roomName", createdRoom.getRoomName());
        
        return response;
    }

    // Enter a specific chat room
    @GetMapping("/usr/chat/room/{roomId}")
    public String enterChatRoom(@PathVariable String roomId, Model model) {
        ChatRoom room = chatService.findChatRoomById(roomId);
        List<Chat> chatHistory = chatService.getChatHistory(roomId);
        List<Member> roomMembers = chatService.getRoomMembers(roomId);  // 채팅방에 참여한 회원 목록 조회


        for (Chat chat : chatHistory) {
            Member sender = chatService.getMemberById(chat.getSender());
            chat.setSenderName(sender.getLoginId()); 
            chat.setSenderProfileImage(sender.getProfileImage()); // Set the profile image
        }

        model.addAttribute("room", room);
        model.addAttribute("chatHistory", chatHistory);
        model.addAttribute("roomMembers", roomMembers);  // 회원 목록을 모델에 추가
        
        return "usr/chat/chatting";
    }

    @MessageMapping("/chat/send")
    @SendTo("/sub/chat/{roomId}")
    public Chat sendMessage(Chat chat) {
        // Check if the sender is a member of the room
        if (chatService.isMemberOfRoom(chat.getRoomId(), chat.getSender())) {
            chat.setTimestamp(LocalDateTime.now());
            chat.setRead(false);
            chatService.saveMessage(chat);
            return chat;
        } else {
            // Log unauthorized access attempt
            System.out.println("Unauthorized chat message attempt: " + chat);
            return null;
        }
    }
    
    @PostMapping("/usr/chat/room/{roomId}/delete")
    @ResponseBody
    public Map<String, String> deleteChatRoom(@PathVariable String roomId, HttpServletRequest req) {
        Rq rq = (Rq) req.getAttribute("rq");
        ChatRoom chatRoom = chatService.findChatRoomById(roomId);

        // 채팅방을 만든 회원인지 확인
        if (chatRoom.getCreatedBy().equals(String.valueOf(rq.getLoginedMemberId()))) {
            // 채팅방 삭제
            chatService.deleteChatRoom(roomId);

            Map<String, String> response = new HashMap<>();
            response.put("status", "success");
            response.put("message", "채팅방이 삭제되었습니다.");
            return response;
        } else {
            // 권한 없는 사용자
            Map<String, String> response = new HashMap<>();
            response.put("status", "error");
            response.put("message", "채팅방을 삭제할 권한이 없습니다.");
            return response;
        }
    }
    
    @PostMapping("/usr/chat/room/{roomId}/exit")
    @ResponseBody
    public Map<String, String> exitChatRoom(@PathVariable String roomId, HttpServletRequest req) {
        Rq rq = (Rq) req.getAttribute("rq");
        String memberId = String.valueOf(rq.getLoginedMemberId());  // 로그인된 사용자 ID

        // 채팅방에 참여 중인 회원인지 확인
        if (chatService.isMemberOfRoom(roomId, memberId)) {
            chatService.removeMemberFromRoom(roomId, memberId);  // 채팅방에서 회원을 제거

            // 채팅방에 남은 멤버 수 업데이트
            chatService.updateParticipantCount(roomId);

            Map<String, String> response = new HashMap<>();
            response.put("status", "success");
            response.put("message", "채팅방에서 나갔습니다.");
            return response;
        } else {
            Map<String, String> response = new HashMap<>();
            response.put("status", "error");
            response.put("message", "채팅방에 참여 중인 사용자가 아닙니다.");
            return response;
        }
    }
    
    
}