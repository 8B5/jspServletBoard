package com.myboard.controller;

import com.myboard.common.PageURL;
import com.myboard.dao.PostDAO;
import com.myboard.dto.Post;
import com.myboard.dto.User;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/board") 
public class BoardServlet extends HttpServlet {
    private PostDAO postDAO = new PostDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        User loggedInUser = (User)request.getSession().getAttribute("loggedInUser");
        if (loggedInUser == null) {
            response.sendRedirect(PageURL.LOGIN_PAGE); 
            return;
        }

        if ("write".equals(action)) {
            handleWritePost(request, response, loggedInUser);
        } else if ("update".equals(action)) {
            handleUpdatePost(request, response, loggedInUser);
        } else {
        	response.sendRedirect(PageURL.BOARD_PAGE); 
        }
    }

    private void handleWritePost(HttpServletRequest request, HttpServletResponse response, User loggedInUser) 
            throws IOException {
        
        Post newPost = new Post();
        newPost.setTitle(request.getParameter("title"));
        newPost.setContent(request.getParameter("content"));
        newPost.setAuthor(loggedInUser.getUserId());

        if (postDAO.writePost(newPost)) {
        	response.sendRedirect(PageURL.BOARD_PAGE); 
        } else {
        	response.sendRedirect(PageURL.WRITE_POST_ERROR); 
        }
    }
    
    private void handleUpdatePost(HttpServletRequest request, HttpServletResponse response, User loggedInUser) 
            throws IOException {
        
        try {
            int postId = Integer.parseInt(request.getParameter("id"));
            Post post = postDAO.getPostById(postId);
            
            if (post == null) {
            	response.sendRedirect(PageURL.BOARD_PAGE);
                return;
            }
            
            // 작성자이거나 관리자인지 확인
            boolean canEdit = post.getAuthor().equals(loggedInUser.getUserId()) || loggedInUser.isAdmin();
            
            if (!canEdit) {
            	response.sendRedirect(PageURL.getPostDetailPageWithError(postId, "permission"));
                return;
            }
            
            // 게시글 수정
            post.setTitle(request.getParameter("title"));
            post.setContent(request.getParameter("content"));
            
            if (postDAO.updatePost(post)) {
            	response.sendRedirect(PageURL.getPostDetailPage(postId));
            } else {
            	response.sendRedirect(PageURL.getPostDetailPageWithError(postId, "update_fail"));
            }
        } catch (NumberFormatException e) {
        	response.sendRedirect(PageURL.BOARD_PAGE);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        User loggedInUser = (User)request.getSession().getAttribute("loggedInUser");
        
        if (loggedInUser == null) {
        	response.sendRedirect(PageURL.LOGIN_PAGE);
            return;
        }
        
        if ("delete".equals(action)) { 
            handleDeletePost(request, response, loggedInUser);
        } else {
        	response.sendRedirect(PageURL.BOARD_PAGE);
        }
    }
    
    private void handleDeletePost(HttpServletRequest request, HttpServletResponse response, User loggedInUser) 
            throws IOException {
        
        try {
            int postId = Integer.parseInt(request.getParameter("id"));
            Post post = postDAO.getPostById(postId);
            
            if (post == null) {
            	response.sendRedirect(PageURL.BOARD_PAGE);
                return;
            }
            
            boolean deleted = false;
            
            // 관리자는 모든 게시글 삭제 가능
            if (loggedInUser.isAdmin()) {
                deleted = postDAO.deletePostByAdmin(postId);
            } else if (post.getAuthor().equals(loggedInUser.getUserId())) {
                // 작성자는 자신의 게시글만 삭제 가능
                deleted = postDAO.deletePost(postId, loggedInUser.getUserId());
            }
            
            if (deleted) {
            	response.sendRedirect(PageURL.BOARD_PAGE);
            } else {
            	response.sendRedirect(PageURL.getPostDetailPageWithError(postId, "delete_fail"));
            }
        } catch (NumberFormatException e) {
        	response.sendRedirect(PageURL.BOARD_PAGE);
        }
    }
}