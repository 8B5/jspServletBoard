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
    <title>AWS 스터디 게시판</title>
 
</head>
<body>

    <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="container neo-stack">
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
            <div class="hero-section-compact neo-glow">
                <div class="hero-content">
                    <div style="width: 100%; text-align: center;">
                        <h1 class="hero-title-compact">AWS 스터디 게시판</h1>
                        <p class="hero-subtitle-compact">AWS 스터디 내용을 공유하는 소통의 공간</p>
                    </div>
                    <div class="hero-actions-compact">
                        <% if (loggedInUser == null) { %>
                            <a href="<%= request.getContextPath() %>/index.jsp?center=/sns/login.jsp" class="btn btn-primary btn-sm">
                                <span class="btn-icon">&#x1F510;</span>
                                로그인
                            </a>
                            <a href="<%= request.getContextPath() %>/index.jsp?center=/sns/register.jsp" class="btn btn-secondary btn-sm">
                                <span class="btn-icon">&#x270F;&#xFE0F;</span>
                                회원가입
                            </a>
                        <% } else { %>
                            <a href="<%= request.getContextPath() %>/index.jsp?center=/sns/board.jsp" class="btn btn-success btn-sm">
                                <span class="btn-icon">&#x1F4CB;</span>
                                게시판
                            </a>
                            <a href="<%= request.getContextPath() %>/index.jsp?center=/sns/writePost.jsp" class="btn btn-primary btn-sm">
                                <span class="btn-icon">&#x270D;&#xFE0F;</span>
                                글 작성
                            </a>
                        <% } %>
                    </div>
                </div>
            </div>

            <div class="neo-panel neo-stack neo-glow">
                <div class="flex-between">
                    <h2 style="margin:0;">System Pulse</h2>
                    <span class="neo-subtitle" style="font-size:11px; letter-spacing:0.3em; color:var(--text-secondary);">REALTIME SIGNAL</span>
                </div>
                <hr class="neo-divider" />
                <div class="card-list">
                    <div class="post-card">
                        <p class="neo-subtitle" style="color:var(--text-secondary); font-size:11px;">실시간 참여</p>
                        <h3 style="margin:0; font-size:26px; color:var(--accent-cyan);">라이브 모드</h3>
                        <p class="post-excerpt">실시간 스터디 기록을 함께 확인하고 빠르게 의견을 나눠보세요.</p>
                    </div>
                    <div class="post-card">
                        <p class="neo-subtitle" style="color:var(--text-secondary); font-size:11px;">정보 흐름</p>
                        <h3 style="margin:0; font-size:26px; color:var(--accent-violet);">데이터 싱크</h3>
                        <p class="post-excerpt">모든 게시글과 알림이 즉시 동기화되어 최신 정보를 놓치지 않습니다.</p>
                    </div>
                    <div class="post-card">
                        <p class="neo-subtitle" style="color:var(--text-secondary); font-size:11px;">관리 포털</p>
                        <h3 style="margin:0; font-size:26px; color:var(--accent-magenta);">보안 제어</h3>
                        <p class="post-excerpt">관리자는 전용 콘솔에서 계정과 게시물을 안전하게 관리할 수 있습니다.</p>
                    </div>
                </div>
            </div>

        </div>
    </div>
    
    <script>
    </script>
</body>
</html>

