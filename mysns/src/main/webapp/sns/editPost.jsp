<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.myboard.dao.PostDAO" %>
<%@ page import="com.myboard.dto.Post" %>
<%@ page import="com.myboard.dto.User" %>
<%@ page import="com.myboard.common.PageURL" %>
<%
    User loggedInUser = (User)session.getAttribute("loggedInUser");
    if (loggedInUser == null) { response.sendRedirect(PageURL.LOGIN_PAGE); return; }
    
    int postId = 0;
    try { postId = Integer.parseInt(request.getParameter("id")); } catch(NumberFormatException e) { }
    
    PostDAO dao = new PostDAO();
    Post post = dao.getPostById(postId);

    if (post == null) {response.sendRedirect(PageURL.BOARD_PAGE); return; }
    
    boolean canEdit = post.getAuthor().equals(loggedInUser.getUserId()) || loggedInUser.isAdmin();
    if (!canEdit) {response.sendRedirect(PageURL.getPostDetailPageWithError(postId, "permission")); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 수정 - 게시판 플랫폼</title>
 
</head>
<body>
    <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="neo-panel neo-glow" style="max-width: 760px; margin: 0 auto;">
            <h1>전송 수정</h1>
            
            <form action="<%= request.getContextPath() %>/board" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= post.getPostId() %>">
                
                <div class="form-group">
                    <label>
                        작성자
                        <span style="display:block; margin-top:6px; color:var(--accent-cyan); letter-spacing:0.2em; text-transform:uppercase;">
                            <%= post.getAuthor() %>
                        </span>
                        <% if (!post.getAuthor().equals(loggedInUser.getUserId())) { %>
                            <span style="display:block; margin-top:4px; color: var(--accent-magenta); font-size: 12px; letter-spacing:0.18em; text-transform:uppercase;">(관리자 권한으로 수정 중)</span>
                        <% } %>
                    </label>
                </div>
                
                <div class="form-group">
                    <label for="title">제목</label>
                    <input type="text" id="title" name="title" value="<%= post.getTitle() != null ? post.getTitle() : "" %>" 
                           placeholder="헤드라인 신호를 업데이트하세요" required autofocus>
                </div>
                
                <div class="form-group">
                    <label for="content">내용</label>
                    <textarea id="content" name="content" placeholder="방송 메시지를 수정하세요" required><%= post.getContent() != null ? post.getContent() : "" %></textarea>
                </div>
                
                <div class="flex gap-2">
                    <button type="submit" class="btn btn-success">
                        <span class="btn-icon">✓</span>
                        수정 완료
                    </button>
                    <a href="<%= request.getContextPath() %>/index.jsp?center=/sns/postDetail.jsp?id=<%= post.getPostId() %>" class="btn btn-secondary">
                        <span class="btn-icon">←</span>
                        취소
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>

