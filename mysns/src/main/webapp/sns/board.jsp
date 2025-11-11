<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.myboard.dao.PostDAO" %>
<%@ page import="com.myboard.dto.Post" %>
<%@ page import="com.myboard.dto.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.myboard.common.PageURL" %>
<% 
    User loggedInUser = (User)session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
    	response.sendRedirect(PageURL.LOGIN_PAGE);
        return;
    }
    
    PostDAO dao = new PostDAO();
    List<Post> postList;
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    
    // 페이징 파라미터 처리
    int currentPage = 1;
    int pageSize = 10; // 페이지당 게시글 수
    try {
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            currentPage = Integer.parseInt(pageParam);
            if (currentPage < 1) currentPage = 1;
        }
    } catch (NumberFormatException e) {
        currentPage = 1;
    }
    
    // 검색 파라미터 처리
    String keyword = request.getParameter("keyword");
    String searchType = request.getParameter("searchType");
    if (searchType == null || searchType.isEmpty()) {
        searchType = "all";
    }
    
    int totalCount;
    if (keyword != null && !keyword.trim().isEmpty()) {
        postList = dao.searchPostsWithPaging(keyword, searchType, currentPage, pageSize);
        totalCount = dao.getSearchPostCount(keyword, searchType);
    } else {
        postList = dao.getPostsWithPaging(currentPage, pageSize);
        totalCount = dao.getTotalPostCount();
        keyword = "";
    }
    
    // 페이징 계산
    int totalPages = (int) Math.ceil((double) totalCount / pageSize);
    if (totalPages == 0) totalPages = 1;
    if (currentPage > totalPages) currentPage = totalPages;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>게시판 - 게시판 플랫폼</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- 메인 콘텐츠 -->
    <div class="main-content">
        <div class="container">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                <h1 style="margin: 0; font-size: 24px; font-weight: 700; color: var(--text-primary); letter-spacing: -0.5px;">게시판</h1>
                <a href="index.jsp?center=/sns/writePost.jsp" class="btn btn-success">
                    <span class="btn-icon">&#x270D;&#xFE0F;</span>
                    새 글 작성
                </a>
            </div>
            
            <!-- 검색 기능 (네이버 스타일) -->
            <div style="background: var(--bg-primary); border: 1px solid var(--border-color); padding: 20px; border-radius: var(--radius-md); margin-bottom: 24px;">
				<form action="index.jsp" method="get" style="display: flex; gap: 12px; align-items: flex-end;">
				    <input type="hidden" name="center" value="/sns/board.jsp">                    <input type="hidden" name="page" value="1">
                    <div style="flex: 1;">
                        <label for="searchType" style="display: block; margin-bottom: 8px; color: var(--text-primary); font-size: 14px; font-weight: 400;">검색 필터</label>
                        <select id="searchType" name="searchType" class="form-select">
                            <option value="all" <%= "all".equals(searchType) ? "selected" : "" %>>전체</option>
                            <option value="title" <%= "title".equals(searchType) ? "selected" : "" %>>제목</option>
                            <option value="content" <%= "content".equals(searchType) ? "selected" : "" %>>내용</option>
                            <option value="author" <%= "author".equals(searchType) ? "selected" : "" %>>작성자</option>
                        </select>
                    </div>
                    <div style="flex: 3;">
                        <label for="keyword" style="display: block; margin-bottom: 8px; color: var(--text-primary); font-size: 14px; font-weight: 400;">검색어</label>
                        <input type="text" id="keyword" name="keyword" value="<%= keyword != null ? keyword : "" %>" 
                               placeholder="검색어를 입력하세요" style="width: 100%;">
                    </div>
                    <div>
                        <button type="submit" class="btn btn-primary">
                            <span class="btn-icon">&#x1F50D;</span>
                            검색
                        </button>
                    </div>
                    <% if (keyword != null && !keyword.trim().isEmpty()) { %>
                    <div>
                        <a onclick="location.href='index.jsp?center=/sns/board.jsp'" class="btn btn-secondary">
                            <span class="btn-icon">&#x21BA;</span>
                            초기화
                        </a>
                    </div>
                    <% } %>
                </form>
                <% if (keyword != null && !keyword.trim().isEmpty()) { %>
                    <div style="margin-top: 16px; color: var(--text-secondary); font-size: 14px; font-weight: 400;">
                        검색 결과: <strong style="color: var(--primary-color); font-weight: 500;"><%= postList.size() %></strong>개
                    </div>
                <% } %>
            </div>
            
            <% if (postList.isEmpty()) { %>
                <div class="text-center" style="padding: 60px 20px;">
                    <div style="font-size: 48px; margin-bottom: 16px;">
                        <% if (keyword != null && !keyword.trim().isEmpty()) { %>
                            &#x1F50D;
                        <% } else { %>
                            &#x1F4DD;
                        <% } %>
                    </div>
                    <h3 style="color: var(--text-secondary); margin-bottom: 8px;">
                        <% if (keyword != null && !keyword.trim().isEmpty()) { %>
                            검색 결과가 없습니다
                        <% } else { %>
                            게시글이 없습니다
                        <% } %>
                    </h3>
                    <p style="color: var(--text-light); margin-bottom: 24px;">
                        <% if (keyword != null && !keyword.trim().isEmpty()) { %>
                            다른 검색어로 시도해보세요.
                        <% } else { %>
                            첫 번째 게시글을 작성해보세요!
                        <% } %>
                    </p>
                    <% if (keyword == null || keyword.trim().isEmpty()) { %>
                        <a href="index.jsp?center=/sns/writePost.jsp" class="btn btn-primary">글 작성하기</a>
                    <% } %>
                </div>
            <% } else { %>
                <div class="card-list">
                    <% for (Post post : postList) { 
                        String formattedDate = post.getCreatedAt() != null ? sdf.format(post.getCreatedAt()) : "";
                        String contentPreview = post.getContent() != null && post.getContent().length() > 100 
                            ? post.getContent().substring(0, 100) + "..." 
                            : (post.getContent() != null ? post.getContent() : "");
                    %>
                    <a href="index.jsp?center=/sns/postDetail.jsp?id=<%= post.getPostId() %>" class="post-card">
                        <div style="display: flex; align-items: flex-start; gap: 16px;">
                            <div style="flex: 1; min-width: 0;">
                                <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 8px;">
                                    <h3 class="post-title" style="margin: 0; flex: 1;"><%= post.getTitle() %></h3>
<%--                                     <span style="color: var(--text-light); font-size: 12px; font-weight: 400; white-space: nowrap;">
											#<%= post.getRowNum() %>
										</span>
 --%>                                </div>
                                <p class="post-excerpt" style="margin: 0 0 12px 0;"><%= contentPreview %></p>
                                <div class="post-meta" style="margin: 0;">
                                    <span class="post-meta-item">
                                        <span style="color: var(--text-secondary);">작성자</span>
                                        <span style="color: var(--text-primary); font-weight: 500;"><%= post.getAuthor() %></span>
                                    </span>
                                    <span class="post-meta-item">
                                        <span style="color: var(--text-secondary);">조회</span>
                                        <span style="color: var(--text-primary); font-weight: 500;"><%= post.getViewCount() %></span>
                                    </span>
                                    <span class="post-meta-item">
                                        <span style="color: var(--text-secondary);"><%= formattedDate %></span>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </a>
                    <% } %>
                </div>
                
                <!-- 페이징 UI (구글 스타일) -->
                <% if (totalPages > 1) { %>
                <div style="margin-top: 48px; display: flex; justify-content: center; align-items: center; gap: 8px; flex-wrap: wrap;">
                    <% if (currentPage > 1) { %>
                        <a href="index.jsp?center=/sns/board.jsp?page=<%= currentPage - 1 %><% if (keyword != null && !keyword.trim().isEmpty()) { %>&keyword=<%= java.net.URLEncoder.encode(keyword, "UTF-8") %>&searchType=<%= searchType %><% } %>" 
                           class="btn btn-secondary btn-sm">이전</a>
                    <% } %>
                    
                    <% 
                    int startPage = Math.max(1, currentPage - 2);
                    int endPage = Math.min(totalPages, currentPage + 2);
                    for (int i = startPage; i <= endPage; i++) { 
                    %>
                        <% if (i == currentPage) { %>
                            <span class="btn btn-primary btn-sm" style="cursor: default; box-shadow: var(--shadow-sm);"><%= i %></span>
                        <% } else { %>
                            <a href="index.jsp?center=/sns/board.jsp?page=<%= i %><% if (keyword != null && !keyword.trim().isEmpty()) { %>&keyword=<%= java.net.URLEncoder.encode(keyword, "UTF-8") %>&searchType=<%= searchType %><% } %>" 
                               class="btn btn-secondary btn-sm"><%= i %></a>
                        <% } %>
                    <% } %>
                    
                    <% if (currentPage < totalPages) { %>
                        <a href="index.jsp?center=/sns/board.jsp?page=<%= currentPage + 1 %><% if (keyword != null && !keyword.trim().isEmpty()) { %>&keyword=<%= java.net.URLEncoder.encode(keyword, "UTF-8") %>&searchType=<%= searchType %><% } %>" 
                           class="btn btn-secondary btn-sm">다음</a>
                    <% } %>
                </div>
                <div style="text-align: center; margin-top: 16px; color: var(--text-secondary); font-size: 13px; font-weight: 400;">
                    전체 <%= totalCount %>개 중 <%= (currentPage - 1) * pageSize + 1 %>-<%= Math.min(currentPage * pageSize, totalCount) %>개 표시
                </div>
                <% } %>
            <% } %>
            
            <div class="text-center mt-3">
                <a href="index.jsp" class="btn btn-secondary">메인으로</a>
            </div>
        </div>
    </div>
</body>
</html>
