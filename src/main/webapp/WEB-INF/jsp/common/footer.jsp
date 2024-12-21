<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fixed Footer Example</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/daisyui"></script>
    <style>
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        main {
            flex: 1;
        }
    </style>
</head>
<body>
    <main>
        <div class="p-10">
            <p></p>
        </div>
    </main>
    <footer class="footer bg-neutral text-neutral-content p-5 px-32">
        <nav>
            <h6 class="footer-title">팀</h6>
            <a class="link link-hover" href="${pageContext.request.contextPath}/usr/team/teamList">팀 찾기</a>
            <a class="link link-hover">팀 리그</a>
            <a class="link link-hover">팀 매칭</a>
            <a class="link link-hover">구장 예약</a>
        </nav>
        <nav>
            <h6 class="footer-title">게시글</h6>
            <a class="link link-hover">공지사항</a>
            <a class="link link-hover">자유 게시판</a>
            <a class="link link-hover"></a>
            <a class="link link-hover"></a>
        </nav>
        <nav>
            <h6 class="footer-title">채팅</h6>
            <a class="link link-hover">채팅 목록</a>
            <a class="link link-hover">채팅방 생성</a>
            <a class="link link-hover"></a>
        </nav>
    </footer>
</body>
</html>
