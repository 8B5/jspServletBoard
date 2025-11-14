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
 
</head>
<body>

    <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="container-centered neo-glow">
            <h1>네트워크 가입</h1>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message message">
                    <span>&#x26A0;&#xFE0F;</span>
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            
            <form action="<%= request.getContextPath() %>/user" method="post">
                <input type="hidden" name="action" value="register">
                
                <div class="form-group">
                    <label for="userId">사용자 ID</label>
                    <input type="text" id="userId" name="userId" placeholder="최소 4자 이상 입력하세요" required minlength="4" autofocus>
                </div>
                
                <div class="form-group">
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password" placeholder="안전한 비밀번호 (6자 이상)" required minlength="6">
                </div>
                
                <div class="form-group">
                    <label for="userName">표시 이름</label>
                    <input type="text" id="userName" name="userName" placeholder="어떻게 불러드릴까요?" required>
                </div>
                
                <div class="form-group">
                    <label for="email">이메일</label>
                    <input type="email" id="email" name="email" placeholder="example@email.com" required>
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-success" style="width: 100%;">
                        <span class="btn-icon">&#x270F;&#xFE0F;</span>
                        등록
                    </button>
                </div>
            </form>
            
            <div class="text-center mt-2">
                <p style="color: var(--text-secondary); font-size: 13px; letter-spacing:0.18em; text-transform:uppercase;">
                    이미 회원인가요?
                    <a href="<%= request.getContextPath() %>/index.jsp?center=/sns/login.jsp" style="color: var(--accent-cyan); text-decoration: none; font-weight: 500;">로그인</a>
                </p>
            </div>
        </div>
    </div>
</body>
</html>
