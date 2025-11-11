<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.myboard.dto.User" %>
<%
    User loggedInUser = (User)session.getAttribute("loggedInUser");
    if (loggedInUser != null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - 게시판 플랫폼</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="container container-centered">
            <h1>회원가입</h1>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message message">
                    <span>&#x26A0;&#xFE0F;</span>
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <form action="user" method="post">
                <input type="hidden" name="action" value="register">
                
                <div class="form-group">
                    <label for="userId">아이디</label>
                    <input type="text" id="userId" name="userId" placeholder="4자 이상 입력하세요" required minlength="4" autofocus>
                </div>
                
                <div class="form-group">
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password" placeholder="6자 이상 입력하세요" required minlength="6">
                </div>
                
                <div class="form-group">
                    <label for="userName">이름</label>
                    <input type="text" id="userName" name="userName" placeholder="이름을 입력하세요" required>
                </div>
                
                <div class="form-group">
                    <label for="email">이메일</label>
                    <input type="email" id="email" name="email" placeholder="example@email.com" required>
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-success" style="width: 100%;">
                        <span class="btn-icon">&#x270F;&#xFE0F;</span>
                        가입하기
                    </button>
                </div>
            </form>
            
            <div class="text-center mt-2">
                <p style="color: var(--text-secondary); font-size: 14px;">
                    이미 계정이 있으신가요? 
                    <a href="index.jsp?center=/sns/login.jsp" style="color: var(--primary-color); text-decoration: none; font-weight: 500;">로그인</a>
                </p>
            </div>
        </div>
    </div>
</body>
</html>
