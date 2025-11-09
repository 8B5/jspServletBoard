<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.myboard.dao.PostDAO" %>
<%@ page import="com.myboard.dto.Post" %>
<%@ page import="com.myboard.dto.User" %>
<%
    User loggedInUser = (User)session.getAttribute("loggedInUser");
    if (loggedInUser == null) { response.sendRedirect("index.jsp?center=/sns/login.jsp"); return; }
    
    int postId = 0;
    try { postId = Integer.parseInt(request.getParameter("id")); } catch(NumberFormatException e) { }
    
    PostDAO dao = new PostDAO();
    Post post = dao.getPostById(postId);

    if (post == null) {response.sendRedirect("index.jsp?center=/sns/board.jsp"); return; }
    
    boolean canEdit = post.getAuthor().equals(loggedInUser.getUserId()) || loggedInUser.isAdmin();
    if (!canEdit) {response.sendRedirect("index.jsp?center=/sns/postDetail.jsp?id=" + postId + "&error=permission"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 수정 - 게시판 플랫폼</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="container">
            <h1>게시글 수정</h1>
            
            <form action="board" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= post.getPostId() %>">
                
                <div class="form-group">
                    <label style="color: var(--text-secondary); font-size: 14px;">
                        작성자: <strong style="color: var(--text-primary);"><%= post.getAuthor() %></strong>
                        <% if (!post.getAuthor().equals(loggedInUser.getUserId())) { %>
                            <span style="color: var(--accent-color); font-size: 12px;">(관리자 권한으로 수정 중)</span>
                        <% } %>
                    </label>
                </div>
                
                <div class="form-group">
                    <label for="title">제목</label>
                    <input type="text" id="title" name="title" value="<%= post.getTitle() != null ? post.getTitle() : "" %>" 
                           placeholder="게시글 제목을 입력하세요" required autofocus>
                </div>
                
                <div class="form-group">
                    <label for="content">내용</label>
                    <textarea id="content" name="content" placeholder="게시글 내용을 입력하세요" required><%= post.getContent() != null ? post.getContent() : "" %></textarea>
                </div>
                
                <div class="flex gap-2">
                    <button type="submit" class="btn btn-success">
                        <span class="btn-icon">✓</span>
                        수정 완료
                    </button>
                    <a href="index.jsp?center=/sns/postDetail.jsp?id=<%= post.getPostId() %>" class="btn btn-secondary">
                        <span class="btn-icon">←</span>
                        취소
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>

