<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.myboard.dto.User" %>
<%@ page import="java.util.List" %>
<%
    User loggedInUser = (User)session.getAttribute("loggedInUser");
    if (loggedInUser == null || !loggedInUser.isAdmin()) { 
        response.sendRedirect("index.jsp"); 
        return; 
    }
    
    List<User> userList = (List<User>)request.getAttribute("userList");
    String successMessage = (String)request.getAttribute("successMessage");
    String errorMessage = (String)request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사용자 관리 - 게시판 플랫폼</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="container">
            <div class="flex-between mb-3">
                <h1 style="margin: 0;">사용자 관리</h1>
                <a href="index.jsp?center=board.jsp" class="btn btn-secondary">
                    <span class="btn-icon">←</span>
                    게시판으로
                </a>
            </div>
            
            <% if (successMessage != null) { %>
                <div class="success-message message mb-2">
                    <span>✓</span>
                    <%= successMessage %>
                </div>
            <% } %>
            
            <% if (errorMessage != null) { %>
                <div class="error-message message mb-2">
                    <span>⚠️</span>
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <% if (userList == null || userList.isEmpty()) { %>
                <div class="text-center" style="padding: 60px 20px;">
                    <div style="font-size: 48px; margin-bottom: 16px;">👥</div>
                    <h3 style="color: var(--text-secondary); margin-bottom: 8px;">사용자가 없습니다</h3>
                </div>
            <% } else { %>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>아이디</th>
                                <th>이름</th>
                                <th>이메일</th>
                                <th>관리자</th>
                                <th>작업</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (User user : userList) { %>
                                <tr>
                                    <td><strong><%= user.getUserId() %></strong></td>
                                    <td><%= user.getUserName() %></td>
                                    <td><%= user.getEmail() != null ? user.getEmail() : "-" %></td>
                                    <td>
                                        <% if (user.isAdmin()) { %>
                                            <span style="color: var(--accent-color); font-weight: 500;">👑 관리자</span>
                                        <% } else { %>
                                            <span style="color: var(--text-light);">일반</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <a href="user?action=adminEdit&userId=<%= user.getUserId() %>" class="btn btn-primary btn-sm">
                                            <span class="btn-icon">✏️</span>
                                            수정
                                        </a>
                                        <% if (!user.getUserId().equals(loggedInUser.getUserId())) { %>
                                        <a href="user?action=adminDelete&userId=<%= user.getUserId() %>" 
                                           class="btn btn-danger btn-sm"
                                           onclick="return confirm('정말로 이 사용자 계정을 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없으며, 사용자의 모든 게시글과 댓글이 영구적으로 삭제됩니다.');">
                                            <span class="btn-icon">🗑️</span>
                                            삭제
                                        </a>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>

