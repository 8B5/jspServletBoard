<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.myboard.dao.PostDAO" %>
<%@ page import="com.myboard.dao.CommentDAO" %>
<%@ page import="com.myboard.dao.UserDAO" %>
<%@ page import="com.myboard.dto.Post" %>
<%@ page import="com.myboard.dto.Comment" %>
<%@ page import="com.myboard.dto.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="com.myboard.common.PageURL" %>
<%
    User loggedInUser = (User)session.getAttribute("loggedInUser");
    if (loggedInUser == null) { response.sendRedirect(PageURL.LOGIN_PAGE); return; }
    
    int postId = 0;
    try { postId = Integer.parseInt(request.getParameter("id")); } catch(NumberFormatException e) { }
    
    PostDAO postDAO = new PostDAO();
    Post post = postDAO.getPostById(postId);

    if (post == null) {response.sendRedirect(PageURL.BOARD_PAGE); return; }
    
    // 조회수 증가 (중복 방지를 위해 세션 체크는 간단하게 처리)
    postDAO.increaseViewCount(postId);
    post.setViewCount(post.getViewCount() + 1); // 화면에 표시할 조회수 업데이트
    
    // 댓글 목록 조회
    CommentDAO commentDAO = new CommentDAO();
    List<Comment> commentList = commentDAO.getCommentsByPostId(postId);
    
    // 댓글 작성자들의 관리자 여부 확인을 위한 UserDAO
    UserDAO userDAO = new UserDAO();
    
    boolean isAuthor = loggedInUser.getUserId().equals(post.getAuthor());
    boolean canEdit = isAuthor || loggedInUser.isAdmin(); // 작성자이거나 관리자
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일 HH:mm");
    String formattedDate = post.getCreatedAt() != null ? sdf.format(post.getCreatedAt()) : "";
    
    String errorParam = request.getParameter("error");
    String errorMessage = null;
    if ("permission".equals(errorParam)) {
        errorMessage = "수정 권한이 없습니다.";
    } else if ("update_fail".equals(errorParam)) {
        errorMessage = "게시글 수정에 실패했습니다.";
    } else if ("delete_fail".equals(errorParam)) {
        errorMessage = "게시글 삭제에 실패했습니다.";
    } else if ("comment_empty".equals(errorParam)) {
        errorMessage = "댓글 내용을 입력해주세요.";
    } else if ("comment_fail".equals(errorParam)) {
        errorMessage = "댓글 작성에 실패했습니다.";
    } else if ("comment_permission".equals(errorParam)) {
        errorMessage = "댓글 수정 권한이 없습니다.";
    } else if ("comment_update_fail".equals(errorParam)) {
        errorMessage = "댓글 수정에 실패했습니다.";
    } else if ("comment_delete_fail".equals(errorParam)) {
        errorMessage = "댓글 삭제에 실패했습니다.";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= post.getTitle() %> - 게시판 플랫폼</title>
 
</head>
<body>
    <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="container post-detail neo-stack">
            <div class="post-detail-header">
                <h1 class="post-detail-title"><%= post.getTitle() %></h1>
                <div class="post-detail-meta">
                    <span class="post-meta-item">
                        <span>&#x1F464;</span>
                        <span><strong><%= post.getAuthor() %></strong></span>
                    </span>
                    <span class="post-meta-item">
                        <span>&#x1F4C5;</span>
                        <span><%= formattedDate %></span>
                    </span>
                    <span class="post-meta-item">
                        <span>&#x1F441;&#xFE0F;</span>
                        <span><%= post.getViewCount() %></span>
                    </span>
                    <span class="post-meta-item">
                        <span>#</span>
                        <span><%= post.getPostId() %></span>
                    </span>
                </div>
            </div>
            
            <% if (errorMessage != null) { %>
                <div class="error-message message mb-2">
                    <span>&#x26A0;&#xFE0F;</span>
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <div class="post-detail-content">
                <%= post.getContent() != null ? post.getContent().replace("\n", "<br>") : "" %>
            </div>
            
            <div class="post-detail-actions">
                <a href="<%= request.getContextPath() %>/index.jsp?center=/sns/board.jsp" class="btn btn-secondary">
                    <span class="btn-icon">&#x2190;</span>
                    목록으로
                </a>
                
                <% if (canEdit) { %>
                    <a href="<%= request.getContextPath() %>/index.jsp?center=/sns/editPost.jsp?id=<%= post.getPostId() %>" class="btn btn-primary">
                        <span class="btn-icon">&#x270F;&#xFE0F;</span>
                        수정
                    </a>
                <% } %>
                
                <% if (canEdit) { %> 
                    <a href="<%= request.getContextPath() %>/board?action=delete&id=<%= post.getPostId() %>" class="btn btn-danger"
                       onclick="return confirm('정말로 이 글을 삭제하시겠습니까?');">
                        <span class="btn-icon">&#x1F5D1;&#xFE0F;</span>
                        삭제
                    </a>
                <% } %>
            </div>
            
            <!-- 댓글 섹션 -->
            <div class="neo-panel neo-glow" style="margin-top: 12px;">
                <h2 style="margin-bottom: 24px; font-size: 24px; font-weight: 400; color: var(--text-primary); letter-spacing: -0.3px;">
                    댓글 (<%= commentList.size() %>)
                </h2>
                
                <!-- 댓글 작성 폼 -->
                <div class="neo-panel" style="padding:28px 24px; background:rgba(7,13,30,0.72); border-color:rgba(0,245,255,0.12); margin-bottom:32px;">
                    <form action="<%= request.getContextPath() %>/comment" method="post">
                        <input type="hidden" name="action" value="write">
                        <input type="hidden" name="postId" value="<%= post.getPostId() %>">
                        <div class="form-group">
                            <label for="commentContent">
                                댓글 작성
                            </label>
                            <textarea id="commentContent" name="content" 
                                      placeholder="댓글을 입력하면 게시글에 등록됩니다." 
                                      required 
                                      style="min-height: 100px;"></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">
                            <span class="btn-icon">&#x1F4AC;</span>
                            등록
                        </button>
                    </form>
                </div>
                
                <!-- 댓글 목록 -->
                <% if (commentList.isEmpty()) { %>
                    <div class="text-center" style="padding: 40px 20px; color: var(--text-secondary); letter-spacing:0.18em; text-transform:uppercase;">
                        <p>아직 댓글이 없습니다. 첫 댓글을 남겨보세요.</p>
                    </div>
                <% } else { %>
                    <div class="neo-stack">
                        <% for (Comment comment : commentList) {
                            boolean isCommentAuthor = comment.getAuthorId().equals(loggedInUser.getUserId());
                            boolean canEditComment = isCommentAuthor || loggedInUser.isAdmin();
                            String commentDate = comment.getCreatedAt() != null ? sdf.format(comment.getCreatedAt()) : "";
                            
                            // 댓글 작성자가 관리자인지 확인
                            String commentAuthorId = comment.getAuthorId();
                            User commentAuthor = null;
                            boolean isCommentAuthorAdmin = false;
                            
                            if (commentAuthorId != null && !commentAuthorId.trim().isEmpty()) {
                                commentAuthor = userDAO.getUserById(commentAuthorId);
                                if (commentAuthor != null) {
                                    isCommentAuthorAdmin = commentAuthor.isAdmin();
                                }
                            }
                        %>
                        <div class="post-card">
                            <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 16px;">
                                <div>
                                    <strong style="color: var(--accent-cyan); font-weight: 600; font-size: 14px; letter-spacing:0.12em;"><%= comment.getAuthorId() %></strong>
                                    <% 
                                    // 댓글 작성자가 실제로 관리자인 경우에만 관리자 마크 표시
                                    if (isCommentAuthorAdmin) { 
                                    %>
                                        <span style="color: var(--accent-magenta); font-size: 11px; margin-left: 6px; font-weight: 500;">관리자</span>
                                    <% } %>
                                    <span style="color: var(--text-secondary); font-size: 11px; margin-left: 12px; letter-spacing:0.12em;"><%= commentDate %></span>
                                </div>
                                <% if (canEditComment) { 
                                    String commentContentForJs = "";
                                    if (comment.getContent() != null) {
                                        commentContentForJs = comment.getContent()
                                            .replace("\\", "\\\\")
                                            .replace("\"", "&quot;")
                                            .replace("\n", "\\n")
                                            .replace("\r", "")
                                            .replace("'", "&#39;");
                                    }
                                %>
                                <div style="display: flex; gap: 8px;">
                                    <button data-comment-id="<%= comment.getCommentId() %>" 
                                            data-comment-content="<%= commentContentForJs %>"
                                            onclick="editCommentFromButton(this)" 
                                            class="btn btn-secondary btn-sm">
                                        수정
                                    </button>
                                    <a href="<%= request.getContextPath() %>/comment?action=delete&commentId=<%= comment.getCommentId() %>" 
                                       class="btn btn-danger btn-sm" 
                                       onclick="return confirm('정말로 이 댓글을 삭제하시겠습니까?');">
                                        삭제
                                    </a>
                                </div>
                                <% } %>
                            </div>
                            <div id="comment-content-<%= comment.getCommentId() %>" style="color: var(--text-primary); line-height: 1.7; white-space: normal; font-size: 14px;">
                                <%= comment.getContent() != null ? comment.getContent().replace("\n", "<br>") : "" %>
                            </div>
                            <!-- 댓글 수정 폼 (숨김) -->
                            <div id="comment-edit-<%= comment.getCommentId() %>" style="display: none; margin-top: 16px; padding-top: 16px; border-top: 1px solid rgba(255,255,255,0.08);">
                                <form action="<%= request.getContextPath() %>/comment" method="post">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="commentId" value="<%= comment.getCommentId() %>">
                                    <input type="hidden" name="postId" value="<%= post.getPostId() %>">
                                    <textarea name="content" required style="min-height: 80px;"></textarea>
                                    <div style="margin-top: 12px; display: flex; gap: 8px;">
                                        <button type="submit" class="btn btn-primary btn-sm">저장</button>
                                        <button type="button" data-comment-id="<%= comment.getCommentId() %>" onclick="cancelEditFromButton(this)" class="btn btn-secondary btn-sm">취소</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <script>
        function editCommentFromButton(button) {
            var commentId = button.getAttribute('data-comment-id');
            var originalContent = button.getAttribute('data-comment-content');
            editComment(commentId, originalContent);
        }
        
        function editComment(commentId, originalContent) {
            // 원본 내용을 textarea에 설정
            var editForm = document.getElementById('comment-edit-' + commentId);
            var textarea = editForm.querySelector('textarea');
            // HTML 엔티티를 다시 원래 문자로 변환
            var decodedContent = originalContent
                .replace(/&quot;/g, '"')
                .replace(/&#39;/g, "'")
                .replace(/\\n/g, '\n')
                .replace(/\\\\/g, '\\');
            textarea.value = decodedContent;
            
            // 댓글 내용 숨기고 수정 폼 표시
            document.getElementById('comment-content-' + commentId).style.display = 'none';
            editForm.style.display = 'block';
        }
        
        function cancelEditFromButton(button) {
            var commentId = button.getAttribute('data-comment-id');
            cancelEdit(commentId);
        }
        
        function cancelEdit(commentId) {
            // 수정 폼 숨기고 댓글 내용 표시
            document.getElementById('comment-edit-' + commentId).style.display = 'none';
            document.getElementById('comment-content-' + commentId).style.display = 'block';
        }
    </script>
</body>
</html>

