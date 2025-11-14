<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.myboard.dto.User" %>
<%
    User loggedInUser = (User)session.getAttribute("loggedInUser");
    if (loggedInUser == null || !loggedInUser.isAdmin()) { 
        response.sendRedirect("index.jsp"); 
        return; 
    }
    
    User targetUser = (User)request.getAttribute("targetUser");
    if (targetUser == null) { 
        response.sendRedirect("user?action=adminList"); 
        return; 
    }
    
    String errorMessage = (String)request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사용자 정보 수정 - 게시판 플랫폼</title>
 
</head>
<body>
    <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="container-centered neo-glow">
            <h1>사용자 재정의 콘솔</h1>
            
            <% if (errorMessage != null) { %>
                <div class="error-message message">
                    <span>&#x26A0;&#xFE0F;</span>
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <form action="<%= request.getContextPath() %>/user" method="post">
                <input type="hidden" name="action" value="adminEdit">
                <input type="hidden" name="userId" value="<%= targetUser.getUserId() %>">
                
                <div class="form-group">
                    <label>
                        사용자 ID
                        <span style="display:block; margin-top:6px; color:var(--accent-cyan); letter-spacing:0.2em; text-transform:uppercase;"><%= targetUser.getUserId() %></span>
                        <span style="color: var(--text-muted); font-size: 12px; letter-spacing:0.18em; text-transform:uppercase;">(변경 불가)</span>
                    </label>
                </div>
                
                <div class="form-group">
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password" 
                           placeholder="비워두면 기존 비밀번호를 유지합니다.">
                    <small style="color: var(--text-muted); font-size: 11px; display: block; margin-top: 4px; letter-spacing:0.18em;">
                        * 입력하지 않으면 현재 비밀번호가 유지됩니다.
                    </small>
                </div>
                
                <div class="form-group">
                    <label for="userName">이름</label>
                    <input type="text" id="userName" name="userName" 
                           value="<%= targetUser.getUserName() != null ? targetUser.getUserName() : "" %>" 
                           placeholder="이름을 수정하세요" required>
                </div>
                
                <div class="form-group">
                    <label for="email">이메일</label>
                    <input type="email" id="email" name="email" 
                           value="<%= targetUser.getEmail() != null ? targetUser.getEmail() : "" %>" 
                           placeholder="example@email.com" required>
                </div>
                
                <div class="form-group">
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
                        <input type="checkbox" id="isAdmin" name="isAdmin" 
                               <%= targetUser.isAdmin() ? "checked" : "" %> 
                               style="width: auto; cursor: pointer;">
                        <span style="letter-spacing:0.18em; text-transform:uppercase;">관리자 권한 부여</span>
                    </label>
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-primary" style="width: 100%;">
                        <span class="btn-icon">✓</span>
                        수정 완료
                    </button>
                </div>
                
                <div class="text-center mt-2">
                    <a href="<%= request.getContextPath() %>/user?action=adminList" class="btn btn-secondary" style="width: 100%;">
                        <span class="btn-icon">←</span>
                        목록으로
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>

