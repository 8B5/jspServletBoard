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
 
</head>
<body>
    <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="container-centered neo-glow">
            <h1>내 정보 수정</h1>
            
            <% if (errorMessage != null) { %>
                <div class="error-message message">
                    <span>&#x26A0;&#xFE0F;</span>
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <% if (successMessage != null) { %>
                <div class="success-message message">
                    <span>&#x2713;</span>
                    <%= successMessage %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/user" method="post">
                <input type="hidden" name="action" value="edit">
                
                <div class="form-group">
                    <label>
                        사용자 ID
                        <span style="display:block; margin-top:6px; color:var(--accent-cyan); letter-spacing:0.2em; text-transform:uppercase;"><%= loggedInUser.getUserId() %></span>
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
                    <label for="userName">표시 이름</label>
                    <input type="text" id="userName" name="userName" 
                           value="<%= loggedInUser.getUserName() != null ? loggedInUser.getUserName() : "" %>" 
                           placeholder="호출 부호를 업데이트하세요" required>
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
                        프로필 업데이트
                    </button>
                </div>
                
                <div class="text-center mt-2">
                    <a href="<%= request.getContextPath() %>/index.jsp?center=/sns/board.jsp" class="btn btn-secondary" style="width: 100%;">
                        <span class="btn-icon">←</span>
                        취소
                    </a>
                </div>
            </form>
            
            <div style="margin-top: 40px; padding-top: 32px; border-top: 2px solid rgba(255,255,255,0.08);">
                <h3 style="color: var(--accent-magenta); font-size: 16px; margin-bottom: 12px;">계정 제어</h3>
                <p style="color: var(--text-secondary); font-size: 13px; margin-bottom: 20px; line-height:1.8;">
                    서비스 이용을 종료하고자 한다면 아래에서 계정을 영구적으로 삭제할 수 있습니다.
                    <br><span style="color: var(--accent-danger); font-size: 12px; letter-spacing:0.18em; text-transform:uppercase;">&#x26A0;&#xFE0F; 복구 불가능한 작업</span>
                </p>
                <a href="<%= request.getContextPath() %>/user?action=delete"
                   onclick="return confirm('정말로 계정을 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없으며, 모든 게시글과 정보가 영구적으로 삭제됩니다.');"
                   class="btn btn-danger" style="width: 100%;">
                    <span class="btn-icon">&#x1F5D1;&#xFE0F;</span>
                    계정 삭제
                </a>
            </div>
        </div>
    </div>
</body>
</html>
