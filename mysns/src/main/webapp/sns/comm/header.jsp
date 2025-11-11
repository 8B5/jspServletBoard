<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.myboard.dto.User" %>
<%
    User loggedInUser = (User)session.getAttribute("loggedInUser");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JSP SNS - 메인</title>
    <link rel="stylesheet" href="./css/style.css">
    <%-- 필요한 다른 메타 태그, 스크립트 등 추가 --%>
</head>
<body>
    <!-- 네비게이션 바 -->
	    <nav class="navbar">
	        <div class="nav-container">
	            <a href="index.jsp" class="nav-logo">AWS 스터디 게시판</a>
	            <ul class="nav-menu">
	                <% if (loggedInUser == null) { %>
	                    <li><a href="index.jsp?center=/sns/login.jsp" class="btn btn-primary btn-sm">로그인</a></li>
	                    <li><a href="index.jsp?center=/sns/register.jsp" class="btn btn-secondary btn-sm">회원가입</a></li>
	                <% } else { %>
	                    <li class="nav-user">
	                        <strong><%= loggedInUser.getUserName() %></strong>님
	                        <% if (loggedInUser.isAdmin()) { %>
	                            <span style="color: var(--accent-color); font-size: 12px; margin-left: 4px;">&#x1F451; 관리자</span>
	                        <% } %>
	                    </li>
	                    <li><a href="index.jsp?center=/sns/board.jsp" class="btn btn-success btn-sm">게시판</a></li>
	                    <% if (loggedInUser.isAdmin()) { %>
	                        <li><a href="user?action=adminList" class="btn btn-warning btn-sm">관리자</a></li>
	                    <% } %>
	                    <li><a href="user?action=profile" class="btn btn-info btn-sm">내 정보</a></li>
	                    <li><a href="user?action=logout" class="btn btn-secondary btn-sm">로그아웃</a></li>
	                <% } %>
	            </ul>
	        </div>
	    </nav>
    
    </body>
    </html>