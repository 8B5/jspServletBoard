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
 
</head>
<body>

    <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="container-centered neo-glow">
            <h1>접근 콘솔</h1>
            
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
            
            <form action="<%= request.getContextPath() %>/user" method="post">
                <input type="hidden" name="action" value="login">
                
                <div class="form-group">
                    <label for="userId">사용자 ID</label>
                    <input type="text" id="userId" name="userId" placeholder="식별자를 입력하세요" required autofocus>
                </div>
                
                <div class="form-group">
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-primary" style="width: 100%;">
                        <span class="btn-icon">&#x1F510;</span>
                        인증
                    </button>
                </div>
            </form>
            
            <div class="text-center mt-2">
                <p style="color: var(--text-secondary); font-size: 13px; letter-spacing:0.18em; text-transform:uppercase;">
                    아직 계정이 없나요?
                    <a href="<%= request.getContextPath() %>/index.jsp?center=/sns/register.jsp" style="color: var(--accent-cyan); text-decoration: none; font-weight: 500;">지금 등록</a>
                </p>
            </div>
        </div>
    </div>
</body>
</html>
