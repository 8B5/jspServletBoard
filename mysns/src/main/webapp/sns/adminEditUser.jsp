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
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="container container-centered">
            <h1>사용자 정보 수정</h1>
            
            <% if (errorMessage != null) { %>
                <div class="error-message message">
                    <span>⚠️</span>
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <form action="user" method="post">
                <input type="hidden" name="action" value="adminEdit">
                <input type="hidden" name="userId" value="<%= targetUser.getUserId() %>">
                
                <div class="form-group">
                    <label style="color: var(--text-secondary); font-size: 14px;">
                        아이디: <strong style="color: var(--text-primary);"><%= targetUser.getUserId() %></strong>
                        <span style="color: var(--text-light); font-size: 12px;">(변경 불가)</span>
                    </label>
                </div>
                
                <div class="form-group">
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password" 
                           placeholder="새 비밀번호를 입력하세요 (변경하지 않으려면 비워두세요)">
                    <small style="color: var(--text-light); font-size: 12px; display: block; margin-top: 4px;">
                        비밀번호를 변경하지 않으려면 이 필드를 비워두세요.
                    </small>
                </div>
                
                <div class="form-group">
                    <label for="userName">이름</label>
                    <input type="text" id="userName" name="userName" 
                           value="<%= targetUser.getUserName() != null ? targetUser.getUserName() : "" %>" 
                           placeholder="이름을 입력하세요" required>
                </div>
                
                <div class="form-group">
                    <label for="email">이메일</label>
                    <input type="email" id="email" name="email" 
                           value="<%= targetUser.getEmail() != null ? targetUser.getEmail() : "" %>" 
                           placeholder="example@email.com" required>
                </div>
                
                <div class="form-group">
                    <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                        <input type="checkbox" id="isAdmin" name="isAdmin" 
                               <%= targetUser.isAdmin() ? "checked" : "" %> 
                               style="width: auto; cursor: pointer;">
                        <span>관리자 권한 부여</span>
                    </label>
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-primary" style="width: 100%;">
                        <span class="btn-icon">✓</span>
                        수정 완료
                    </button>
                </div>
                
                <div class="text-center mt-2">
                    <a href="user?action=adminList" class="btn btn-secondary" style="width: 100%;">
                        <span class="btn-icon">←</span>
                        목록으로 돌아가기
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>

