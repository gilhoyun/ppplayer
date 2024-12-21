<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${pageTitle}-PLAYER</title>
<!-- Tailwind CSS -->
<script src="https://cdn.tailwindcss.com"></script>
<!-- DaisyUI -->
<link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.14/dist/full.min.css" rel="stylesheet" type="text/css" />
<!-- jQuery -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" />
<!-- Custom CSS -->
<link rel="stylesheet" href="/resource/common.css" />
<!-- WebSocket사용을 위한 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
</head>
<body class="bg-white text-gray-900">
    <!-- Navigation Bar -->
    <header class="bg-stone-400 text-white border border-gray-300 rounded-3xl h-15 mx-64 mt-5 shadow-xl transition-shadow duration-300 hover:shadow-2xl">
        <nav class="container mx-auto px-24 py-4 flex justify-between items-center h-full">
            <div class="flex items-center">
                <a href="${pageContext.request.contextPath}/" class="text-xl font-bold hover:text-gray-200 transition">PLAYER</a>
            </div>
            <div class="flex items-center space-x-4">
<%--                 <a href="${pageContext.request.contextPath}/" class="hover:text-gray-200 transition"> --%>
<!--                     <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"> -->
<!--                         <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" /> -->
<!--                     </svg> -->
<!--                 </a> -->
            
            
                <!-- Board Links (Dropdown) -->
                <div class="dropdown dropdown-end">
                    <!-- 게시글 메뉴 -->
                    <a href="javascript:void(0);" class="hover:text-gray-200 text-center">게시글</a>
                    <ul tabindex="0" class="menu menu-sm dropdown-content mt-6 z-[1] p-2 shadow bg-base-100 rounded-box w-52 text-black border border-gray-500">
                        <li><a href="${pageContext.request.contextPath}/usr/article/list?boardId=1">공지사항</a></li>
                        <li><a href="${pageContext.request.contextPath}/usr/article/list?boardId=2">자유</a></li>
                    </ul>
                </div>

                <!-- 팀 메뉴 -->
                <div class="dropdown dropdown-end">
                    <a href="javascript:void(0);" class="hover:text-gray-200 text-center">팀</a>
                    <ul tabindex="0" class="menu menu-sm dropdown-content mt-6 z-[1] p-2 shadow bg-base-100 rounded-box w-52 text-black border border-gray-500">
                        <c:choose>

                            <c:when test="${rq.getLoginedMemberId() == -1}">
                                <li><a href="${pageContext.request.contextPath}/usr/team/teamList">팀 찾기</a></li>
                                <li><a href="${pageContext.request.contextPath}/usr/team/rankings">팀 리그</a></li>
                            </c:when>

                            <c:when test="${rq.getLoginedMemberId() != -1 and not rq.hasTeam()}">
                                <c:if test="${rq.getLoginedMemberId() != -1 and rq.isMemberOfAnyTeam()}">
                                    <li><a href="${pageContext.request.contextPath}/usr/teamMember/MemberTeam">내 팀보기</a></li>
                                </c:if>        
                                <c:if test="${rq.getLoginedMemberId() != -1 and not rq.isMemberOfAnyTeam()}">
                                    <li><a href="${pageContext.request.contextPath}/usr/team/createTeam">팀 창단</a></li>
                                </c:if>
                                <li><a href="${pageContext.request.contextPath}/usr/team/teamList">팀 찾기</a></li>
                                <li><a href="${pageContext.request.contextPath}/usr/team/rankings">팀 리그</a></li>
                            </c:when>

                            <c:when test="${rq.getLoginedMemberId() != -1 and rq.isMemberOfAnyTeam()}">
                                <li><a href="${pageContext.request.contextPath}/usr/teamMember/MemberTeam">내 팀보기</a></li>
                                <li><a href="${pageContext.request.contextPath}/usr/team/teamList">팀 찾기</a></li>
                                <li><a href="${pageContext.request.contextPath}/usr/team/rankings">팀 리그</a></li>
                            </c:when>

                            <c:otherwise>
                                <li><a href="${pageContext.request.contextPath}/usr/team/myTeam">내 팀보기</a></li>
                                <li><a href="${pageContext.request.contextPath}/usr/team/teamList">팀 찾기</a></li>
                                <li><a href="${pageContext.request.contextPath}/usr/team/rankings">팀 리그</a></li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>

                <!-- 메시지 아이콘 (팀 메뉴 오른쪽에 위치) -->
                <a href="${pageContext.request.contextPath}/usr/chat/rooms"
                   class="hover:text-gray-200 transition flex items-center ml-4">
                    <i class="fa-regular fa-message"></i>
                </a>

                <!-- User Profile Menu -->
                <div class="dropdown dropdown-end">
                    <div tabindex="0" role="button" class="btn btn-ghost btn-circle avatar">
                        <div class="w-8 rounded-full border border-gray-500">
                            <c:choose>
                                <c:when test="${rq.getLoginedMemberId() != -1}">
                                    <!-- 로그인한 사용자의 프로필 이미지 출력 -->
                                    <img src="${pageContext.request.contextPath}/usr/member/profileImage?memberId=${rq.getLoginedMemberId()}" alt="User Avatar" />
                                </c:when>
                                <c:otherwise>
                                    <!-- 기본 아이콘 이미지 표시 -->
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" class="text-gray-600">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                                    </svg>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <ul tabindex="0" class="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-52 text-black border border-gray-500">
                        <c:choose>
                            <c:when test="${rq.getLoginedMemberId() == -1}">
                                <li><a href="${pageContext.request.contextPath}/usr/member/login">로그인</a></li>
                                <li><a href="${pageContext.request.contextPath}/usr/member/join">회원가입</a></li>
                            </c:when>
                            <c:otherwise>
                                <li><a href="${pageContext.request.contextPath}/usr/member/myPage">마이페이지</a></li>
                                <li><a href="${pageContext.request.contextPath}/usr/member/doLogout">로그아웃</a></li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>

            </div>           
        </nav>
    </header>
</body>
</html>
