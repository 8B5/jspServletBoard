<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.myboard.dto.User" %>
<%@ page import="com.myboard.common.PageURL" %>

<%
    User loggedInUser = (User)session.getAttribute("loggedInUser");
    if (loggedInUser == null) { response.sendRedirect(PageURL.LOGIN_PAGE); return; }
    
    String errorMessage = (String)request.getAttribute("errorMessage");
    String successMessage = (String)request.getAttribute("successMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 정보 수정 - 게시판 플랫폼</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="container container-centered">
            <h1>회원 정보 수정</h1>
            
            <% if (errorMessage != null) { %>
                <div class="error-message message">
                    <span>&#x26A0;&#xFE0F;</span>
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <% if (successMessage != null) { %>
                <div class="success-message message">
                    <span>✓</span>
                    <%= successMessage %>
                </div>
            <% } %>

            <form action="user" method="post">
                <input type="hidden" name="action" value="edit">
                
                <div class="form-group">
                    <label style="color: var(--text-secondary); font-size: 14px;">
                        아이디: <strong style="color: var(--text-primary);"><%= loggedInUser.getUserId() %></strong>
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
                           value="<%= loggedInUser.getUserName() != null ? loggedInUser.getUserName() : "" %>" 
                           placeholder="이름을 입력하세요" required>
                </div>
                
                <div class="form-group">
                    <label for="email">이메일</label>
                    <input type="email" id="email" name="email" 
                           value="<%= loggedInUser.getEmail() != null ? loggedInUser.getEmail() : "" %>" 
                           placeholder="example@email.com" required>
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-primary" style="width: 100%;">
                        <span class="btn-icon">✓</span>
                        정보 수정 완료
                    </button>
                </div>
                
                <div class="text-center mt-2">
                    <a href="index.jsp?center=/sns/board.jsp" class="btn btn-secondary" style="width: 100%;">
                        <span class="btn-icon">←</span>
                        취소
                    </a>
                </div>
            </form>
            
            <div style="margin-top: 40px; padding-top: 32px; border-top: 2px solid var(--border-color);">
                <h3 style="color: var(--text-secondary); font-size: 16px; margin-bottom: 12px;">계정 관리</h3>
                <p style="color: var(--text-light); font-size: 14px; margin-bottom: 20px;">
                    더 이상 서비스를 이용하지 않으시려면 계정을 삭제할 수 있습니다.
                    <br><span style="color: var(--accent-color); font-size: 12px;">&#x26A0;&#xFE0F; 이 작업은 되돌릴 수 없습니다.</span>
                </p>
                <a href="user?action=delete" 
                   onclick="return confirm('정말로 계정을 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없으며, 모든 게시글과 정보가 영구적으로 삭제됩니다.');"
                   class="btn btn-danger" style="width: 100%;">
                    <span class="btn-icon">&#x1F5D1;&#xFE0F;</span>
                    계정 삭제 (탈퇴)
                </a>
            </div>
        </div>
    </div>
</body>
</html>
