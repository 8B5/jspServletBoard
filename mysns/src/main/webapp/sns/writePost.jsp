<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.myboard.common.PageURL" %>
<%@ page import="com.myboard.dto.User" %>

<% 
    User loggedInUser = (User)session.getAttribute("loggedInUser");
    
    if (loggedInUser == null) {
    	response.sendRedirect(PageURL.LOGIN_PAGE);
        return;
    };
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>새 글 작성 - 게시판 플랫폼</title>
 
</head>
<body>
    <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="neo-panel neo-glow" style="max-width: 780px; margin: 0 auto;">
            <h1>새로운 전송 작성</h1>
            
            <form action="<%= request.getContextPath() %>/board" method="post" id="writeForm">
                <input type="hidden" name="action" value="write">
                
                <div class="form-group">
                    <label>
                        작성자
                        <span style="display:block; margin-top:6px; color:var(--accent-cyan); letter-spacing:0.2em; text-transform:uppercase;">
                        <%= loggedInUser.getUserName() %> (<%= loggedInUser.getUserId() %>)
                        </span>
                    </label>
                </div>
                
                <div class="form-group">
                    <label for="title">제목</label>
                    <input type="text" id="title" name="title" placeholder="헤드라인 신호를 입력하세요" required autofocus>
                </div>
                
                <div class="form-group">
                    <label for="content">내용</label>
                    <textarea id="content" name="content" placeholder="방송하고 싶은 통찰력을 공유하세요" required></textarea>
                </div>
                
                <div class="flex gap-2">
                    <button type="submit" class="btn btn-success">
                        <span class="btn-icon">✓</span>
                        전송
                    </button>
                    <a href="<%= request.getContextPath() %>/index.jsp?center=/sns/board.jsp" class="btn btn-secondary">
                        <span class="btn-icon">&#x2190;</span>
                        게시판으로 돌아가기
                    </a>
                </div>
            </form>
        </div>
    </div>
    
    <script>
    </script>
</body>
</html>
