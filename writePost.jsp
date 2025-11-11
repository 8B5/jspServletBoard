<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.myboard.common.PageURL" %>
<%@ page import="com.myboard.dto.User" %>

<% 
    User loggedInUser = (User)session.getAttribute("loggedInUser");
    
    if (loggedInUser == null) {
    	response.sendRedirect(PageURL.LOGIN_PAGE);
        return;
    };
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>새 글 작성 - 게시판 플랫폼</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="container" style="max-width: 800px; margin: 0 auto;">
            <h1>새 게시글 작성</h1>
            
            <form action="board" method="post" id="writeForm">
                <input type="hidden" name="action" value="write">
                
                <div class="form-group">
                    <label style="color: var(--text-secondary); font-size: 14px;">
                        작성자: <strong style="color: var(--text-primary);"><%= loggedInUser.getUserName() %></strong> 
                        (<span style="color: var(--text-light);"><%= loggedInUser.getUserId() %></span>)
                    </label>
                </div>
                
                <div class="form-group">
                    <label for="title">제목</label>
                    <input type="text" id="title" name="title" placeholder="게시글 제목을 입력하세요" required autofocus>
                </div>
                
                <div class="form-group">
                    <label for="content">내용</label>
                    <textarea id="content" name="content" placeholder="게시글 내용을 입력하세요" required></textarea>
                </div>
                
                <div class="flex gap-2">
                    <button type="submit" class="btn btn-success">
                        <span class="btn-icon">✓</span>
                        작성 완료
                    </button>
                    <a href="index.jsp?center=/sns/board.jsp" class="btn btn-secondary">
                        <span class="btn-icon">&#x2190;</span>
                        목록으로 돌아가기
                    </a>
                </div>
            </form>
        </div>
    </div>
    
    <script>
    </script>
</body>
</html>
