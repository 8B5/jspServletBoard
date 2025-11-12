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
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>로그인 - 게시판 플랫폼</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="container container-centered">
            <h1>로그인</h1>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message message">
                    <span>&#x26A0;&#xFE0F;</span>
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="success-message message">
                    <span>✓</span>
                    <%= request.getAttribute("successMessage") %>
                </div>
            <% } %>
            
            <form action="user" method="post">
                <input type="hidden" name="action" value="login">
                
                <div class="form-group">
                    <label for="userId">아이디</label>
                    <input type="text" id="userId" name="userId" placeholder="아이디를 입력하세요" required autofocus>
                </div>
                
                <div class="form-group">
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-primary" style="width: 100%;">
                        <span class="btn-icon">&#x1F510;</span>
                        로그인
                    </button>
                </div>
            </form>
            
            <div class="text-center mt-2">
                <p style="color: var(--text-secondary); font-size: 14px;">
                    계정이 없으신가요? 
                    <a href="index.jsp?center=/sns/register.jsp" style="color: var(--primary-color); text-decoration: none; font-weight: 500;">회원가입</a>
                </p>
            </div>
        </div>
    </div>
</body>
</html>
