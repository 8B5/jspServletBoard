package com.myboard.dao;

import com.myboard.dto.Comment;
import com.myboard.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {
    
    // 1. 댓글 작성 (Create)
    public boolean writeComment(Comment comment) {
        String SQL = "INSERT INTO comment (post_id, author_id, content) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            
            pstmt.setInt(1, comment.getPostId());
            pstmt.setString(2, comment.getAuthorId());
            pstmt.setString(3, comment.getContent());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { 
            System.err.println("댓글 작성 중 SQL 오류 발생: " + e.getMessage()); 
            return false;
        }
    }
    
    // 2. 게시글의 모든 댓글 조회
    public List<Comment> getCommentsByPostId(int postId) {
        List<Comment> commentList = new ArrayList<>();
        String SQL = "SELECT comment_id AS commentId, post_id AS postId, author_id AS authorId, content, created_at AS createdAt"
        		+ " FROM comment WHERE post_id = ? ORDER BY created_at ASC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            
            pstmt.setInt(1, postId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Comment comment = new Comment();
                    comment.setCommentId(rs.getInt("commentId"));
                    comment.setPostId(rs.getInt("postId"));
                    comment.setAuthorId(rs.getString("authorId"));
                    comment.setContent(rs.getString("content"));
                    comment.setCreatedAt(rs.getTimestamp("createdAt"));
                    commentList.add(comment);
                }
            }
        } catch (SQLException e) { 
            System.err.println("댓글 조회 중 SQL 오류 발생: " + e.getMessage()); 
        }
        return commentList;
    }
    
    // 3. 댓글 수정 (Update)
    public boolean updateComment(int commentId, String userId, String content) {
        String SQL = "UPDATE comment SET content = ? WHERE comment_id = ? AND author_id = ?";
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            
            pstmt.setString(1, content);
            pstmt.setInt(2, commentId);
            pstmt.setString(3, userId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { 
            System.err.println("댓글 수정 중 SQL 오류 발생: " + e.getMessage()); 
            return false;
        }
    }
    
    // 4. 댓글 삭제 (Delete) - 작성자만 삭제 가능
    public boolean deleteComment(int commentId, String userId) {
        String SQL = "DELETE FROM comment WHERE comment_id = ? AND author_id = ?";
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            
            pstmt.setInt(1, commentId);
            pstmt.setString(2, userId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { 
            System.err.println("댓글 삭제 중 SQL 오류 발생: " + e.getMessage()); 
            return false;
        }
    }
    
    // 5. 관리자가 댓글 삭제 (관리자 전용)
    public boolean deleteCommentByAdmin(int commentId) {
        String SQL = "DELETE FROM comment WHERE comment_id = ?";
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            
            pstmt.setInt(1, commentId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { 
            System.err.println("관리자 댓글 삭제 중 SQL 오류 발생: " + e.getMessage()); 
            return false;
        }
    }
    
    // 6. 댓글 조회 (ID로)
    public Comment getCommentById(int commentId) {
        String SQL = "SELECT comment_id AS commentId, post_id AS postId, author_id AS authorId, content, created_at AS createdAt"
        		+ " FROM comment WHERE comment_id = ?";
        Comment comment = null;
        
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            
            pstmt.setInt(1, commentId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    comment = new Comment();
                    comment.setCommentId(rs.getInt("commentId"));
                    comment.setPostId(rs.getInt("postId"));
                    comment.setAuthorId(rs.getString("authorId"));
                    comment.setContent(rs.getString("content"));
                    comment.setCreatedAt(rs.getTimestamp("createdAt"));
                }
            }
        } catch (SQLException e) { 
            System.err.println("댓글 조회 중 SQL 오류 발생: " + e.getMessage()); 
        }
        return comment;
    }
}

