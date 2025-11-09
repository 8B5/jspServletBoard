<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.myboard.dto.User" %>
<%
    User loggedInUser = (User)session.getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>3 Tier 통신 프로젝트 게시판</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="container">
            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="success-message message mb-2">
                    <span>&#x2705;</span> 
                    <%= request.getAttribute("successMessage") %>
                </div>
            <% } %>
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message message mb-2">
                    <span>&#x26A0;&#xFE0F;</span>
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            <!-- 컴팩트한 Hero 섹션 -->
            <div class="hero-section-compact">
                <div class="hero-content">
                    <div style="width: 100%; text-align: center;">
                        <h1 class="hero-title-compact">3 Tier 통신 프로젝트 게시판</h1>
                        <p class="hero-subtitle-compact">커뮤니티와 함께하는 소통의 공간</p>
                    </div>
                    <div class="hero-actions-compact">
                        <% if (loggedInUser == null) { %>
                            <a href="index.jsp?center=/sns/login.jsp" class="btn btn-primary btn-sm">
                                <span class="btn-icon">&#x1F510;</span>
                                로그인
                            </a>
                            <a href="index.jsp?center=/sns/register.jsp" class="btn btn-secondary btn-sm">
                                <span class="btn-icon">&#x270F;&#xFE0F;</span>
                                회원가입
                            </a>
                        <% } else { %>
                            <a href="index.jsp?center=/sns/board.jsp" class="btn btn-success btn-sm">
                                <span class="btn-icon">&#x1F4CB;</span>
                                게시판
                            </a>
                            <a href="index.jsp?center=/sns/writePost.jsp" class="btn btn-primary btn-sm">
                                <span class="btn-icon">&#x270D;&#xFE0F;</span>
                                글 작성
                            </a>
                        <% } %>
                    </div>
                </div>
            </div>

        </div>
    </div>
    
    <script>
    </script>
</body>
</html>

