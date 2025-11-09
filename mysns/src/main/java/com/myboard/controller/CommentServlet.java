package com.myboard.controller;

import com.myboard.dao.CommentDAO;
import com.myboard.dto.Comment;
import com.myboard.dto.User;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/comment") 
public class CommentServlet extends HttpServlet {
    private CommentDAO commentDAO = new CommentDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        User loggedInUser = (User)request.getSession().getAttribute("loggedInUser");
        if (loggedInUser == null) {
            response.sendRedirect("index.jsp?center=/sns/login.jsp"); 
            return;
        }

        if ("write".equals(action)) {
            handleWriteComment(request, response, loggedInUser);
        } else if ("update".equals(action)) {
            handleUpdateComment(request, response, loggedInUser);
        } else {
        	response.sendRedirect("index.jsp?center=/sns/board.jsp"); 
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        User loggedInUser = (User)request.getSession().getAttribute("loggedInUser");
        
        if (loggedInUser == null) {
        	response.sendRedirect("index.jsp?center=/sns/login.jsp");
            return;
        }
        
        if ("delete".equals(action)) {
            handleDeleteComment(request, response, loggedInUser);
        } else {
        	response.sendRedirect("index.jsp?center=/sns/board.jsp");
        }
    }
    
    private void handleWriteComment(HttpServletRequest request, HttpServletResponse response, User loggedInUser) 
            throws IOException {
        
        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            String content = request.getParameter("content");
            
            if (content == null || content.trim().isEmpty()) {
            	response.sendRedirect("index.jsp?center=/sns/postDetail.jsp?id=" + postId + "&error=comment_empty");
                return;
            }
            
            Comment comment = new Comment();
            comment.setPostId(postId);
            comment.setAuthorId(loggedInUser.getUserId());
            comment.setContent(content.trim());
            
            if (commentDAO.writeComment(comment)) {
            	response.sendRedirect("index.jsp?center=/sns/postDetail.jsp?id=" + postId);
            } else {
            	response.sendRedirect("index.jsp?center=/sns/postDetail.jsp?id=" + postId + "&error=comment_fail");
            }
        } catch (NumberFormatException e) {
        	response.sendRedirect("index.jsp?center=/sns/board.jsp");
        }
    }
    
    private void handleUpdateComment(HttpServletRequest request, HttpServletResponse response, User loggedInUser) 
            throws IOException {
        
        try {
            int commentId = Integer.parseInt(request.getParameter("commentId"));
            int postId = Integer.parseInt(request.getParameter("postId"));
            String content = request.getParameter("content");
            
            if (content == null || content.trim().isEmpty()) {
            	response.sendRedirect("index.jsp?center=/sns/postDetail.jsp?id=" + postId + "&error=comment_empty");
                return;
            }
            
            Comment comment = commentDAO.getCommentById(commentId);
            if (comment == null) {
            	response.sendRedirect("index.jsp?center=/sns/postDetail.jsp?id=" + postId);
                return;
            }
            
            // 작성자이거나 관리자인지 확인
            boolean canEdit = comment.getAuthorId().equals(loggedInUser.getUserId()) || loggedInUser.isAdmin();
            
            if (!canEdit) {
            	response.sendRedirect("index.jsp?center=/sns/postDetail.jsp?id=" + postId + "&error=comment_permission");
                return;
            }
            
            if (commentDAO.updateComment(commentId, loggedInUser.getUserId(), content.trim())) {
            	response.sendRedirect("index.jsp?center=/sns/postDetail.jsp?id=" + postId);
            } else {
            	response.sendRedirect("index.jsp?center=/sns/postDetail.jsp?id=" + postId + "&error=comment_update_fail");
            }
        } catch (NumberFormatException e) {
        	response.sendRedirect("index.jsp?center=/sns/board.jsp");
        }
    }
    
    private void handleDeleteComment(HttpServletRequest request, HttpServletResponse response, User loggedInUser) 
            throws IOException {
        
        try {
            int commentId = Integer.parseInt(request.getParameter("commentId"));
            Comment comment = commentDAO.getCommentById(commentId);
            
            if (comment == null) {
            	response.sendRedirect("index.jsp?center=/sns/board.jsp");
                return;
            }
            
            boolean deleted = false;
            
            // 관리자는 모든 댓글 삭제 가능
            if (loggedInUser.isAdmin()) {
                deleted = commentDAO.deleteCommentByAdmin(commentId);
            } else if (comment.getAuthorId().equals(loggedInUser.getUserId())) {
                // 작성자는 자신의 댓글만 삭제 가능
                deleted = commentDAO.deleteComment(commentId, loggedInUser.getUserId());
            }
            
            if (deleted) {
            	response.sendRedirect("index.jsp?center=/sns/postDetail.jsp?id=" + comment.getPostId());
            } else {
            	response.sendRedirect("index.jsp?center=/sns/postDetail.jsp?id=" + comment.getPostId() + "&error=comment_delete_fail");
            }
        } catch (NumberFormatException e) {
        	response.sendRedirect("index.jsp?center=/sns/board.jsp");
        }
    }
}

