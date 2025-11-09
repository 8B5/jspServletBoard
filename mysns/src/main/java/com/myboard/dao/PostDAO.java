package com.myboard.dao;

import com.myboard.dto.Post;
import com.myboard.util.DBUtil;
import java.sql.*;
import java.util.*;

public class PostDAO {
    
    // 1. 전체 목록 조회 (Read All) - 게시판에 글을 표시합니다.
    public List<Post> getAllPosts() {
        List<Post> postList = new ArrayList<>();
        String SQL = "SELECT ROW_NUMBER() OVER (ORDER BY created_at DESC) AS rowNum, "
        		+ "post_id AS postId, title, author_id AS authorId, view_count AS viewCount, created_at AS createdAt"
        		+ " FROM post WHERE is_deleted = 0 ORDER BY post_id DESC"; 
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Post post = new Post();
                post.setRowNum(rs.getInt("rowNum"));
                post.setPostId(rs.getInt("postId"));
                post.setTitle(rs.getString("title"));
                post.setAuthor(rs.getString("authorId"));
                post.setViewCount(rs.getInt("viewCount"));
                post.setCreatedAt(rs.getTimestamp("createdAt")); 
                postList.add(post);
            }
        } catch (SQLException e) { 
            System.err.println("PostDAO.getAllPosts() 실행 중 SQL 오류 발생! 테이블 생성 확인 필요.");
            System.err.println("오류 메시지: " + e.getMessage());
        }
        return postList;
    }
    
    // 1-1. 페이징된 전체 목록 조회
    public List<Post> getPostsWithPaging(int page, int pageSize) {
        List<Post> postList = new ArrayList<>();
        int offset = (page - 1) * pageSize;                
        String SQL = "SELECT ROW_NUMBER() OVER (ORDER BY created_at DESC) AS rowNum, "
        		+ "post_id AS postId, title, author_id AS authorId, view_count AS viewCount, created_at AS createdAt"
        		+ " FROM post WHERE is_deleted = 0 ORDER BY post_id DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            
            pstmt.setInt(1, pageSize);
            pstmt.setInt(2, offset);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Post post = new Post();
                    post.setRowNum(rs.getInt("rowNum"));
                    post.setPostId(rs.getInt("postId"));
                    post.setTitle(rs.getString("title"));
                    post.setAuthor(rs.getString("authorId"));
                    post.setViewCount(rs.getInt("viewCount"));
                    post.setCreatedAt(rs.getTimestamp("createdAt")); 
                    postList.add(post);
                }
            }
        } catch (SQLException e) { 
            System.err.println("PostDAO.getPostsWithPaging() 실행 중 SQL 오류 발생!");
            System.err.println("오류 메시지: " + e.getMessage());
        }
        return postList;
    }
    
    // 1-2. 전체 게시글 개수 조회
    public int getTotalPostCount() {
        String SQL = "SELECT COUNT(*) FROM post WHERE is_deleted = 0";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) { 
            System.err.println("PostDAO.getTotalPostCount() 실행 중 SQL 오류 발생!");
            System.err.println("오류 메시지: " + e.getMessage());
        }
        return 0;
    }
    
    // 1-3. 검색된 게시글 개수 조회
    public int getSearchPostCount(String keyword, String searchType) {
        String SQL = "";
        if (keyword == null || keyword.trim().isEmpty()) {
            return getTotalPostCount();
        }
        
        keyword = "%" + keyword.trim() + "%";
        
        switch (searchType) {
            case "title":
                SQL = "SELECT COUNT(*) FROM post WHERE title LIKE ? AND is_deleted = 0";
                break;
            case "author":
                SQL = "SELECT COUNT(*) FROM post WHERE author_id LIKE ? AND is_deleted = 0";
                break;
            case "content":
                SQL = "SELECT COUNT(*) FROM post WHERE content LIKE ? AND is_deleted = 0";
                break;
            default: // "all"
                SQL = "SELECT COUNT(*) FROM post WHERE (title LIKE ? OR content LIKE ? OR author_id LIKE ? ) AND is_deleted = 0";
                break;
        }
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            
            if ("all".equals(searchType)) {
                pstmt.setString(1, keyword);
                pstmt.setString(2, keyword);
                pstmt.setString(3, keyword);
            } else {
                pstmt.setString(1, keyword);
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) { 
            System.err.println("PostDAO.getSearchPostCount() 실행 중 SQL 오류 발생!");
            System.err.println("오류 메시지: " + e.getMessage());
        }
        return 0;
    }
    
    // 2. 게시글 작성 (Create)
    public boolean writePost(Post post) {
        String SQL = "INSERT INTO post (title, content, author_id) VALUES (?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            
            pstmt.setString(1, post.getTitle());
            pstmt.setString(2, post.getContent());
            pstmt.setString(3, post.getAuthor());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) { 
            System.err.println("PostDAO.writePost() 실행 중 심각한 SQL 오류 발생!");
            System.err.println("오류 메시지: " + e.getMessage()); 
            e.printStackTrace(); // 스택 트레이스 출력 추가
            return false;
        }
    }
    
    // 3. 상세보기 (Read One)
    public Post getPostById(int postId) {
        String SQL = "SELECT post_id AS postId, title, content, author_id AS authorId, view_count AS viewCount, created_at AS createdAt"
        		+ " FROM post WHERE post_id = ? AND is_deleted = 0";
        Post post = null;
        
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            
            pstmt.setInt(1, postId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    post = new Post();
                    post.setPostId(rs.getInt("postId"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setAuthor(rs.getString("authorId"));
                    post.setViewCount(rs.getInt("viewCount"));
                    post.setCreatedAt(rs.getTimestamp("createdAt"));
                }
            }
        } catch (SQLException e) { 
            System.err.println("게시글 상세보기 중 SQL 오류 발생: " + e.getMessage());
        }
        return post;
    }
    
    // 3-1. 조회수 증가
    public boolean increaseViewCount(int postId) {
        String SQL = "UPDATE post SET view_count = view_count + 1 WHERE post_id = ?";
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            
            pstmt.setInt(1, postId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { 
            System.err.println("조회수 증가 중 SQL 오류 발생: " + e.getMessage());
            return false;
        }
    }
    
    // 4. 게시글 수정 (Update)
    public boolean updatePost(Post post) {
        String SQL = "UPDATE post SET title = ?, content = ? WHERE post_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, post.getTitle());
            pstmt.setString(2, post.getContent());
            pstmt.setInt(3, post.getPostId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { 
            System.err.println("게시글 수정 중 SQL 오류 발생: " + e.getMessage()); 
            return false;
        }
    }
    
    // 5. 게시글 삭제 (Delete) - 작성자 또는 관리자가 삭제 가능
    public boolean deletePost(int postId, String userId) {
        String SQL = "UPDATE post SET is_deleted = 1 WHERE post_id = ? AND author_id = ?";
        try (Connection conn = DBUtil.getConnection(); 
        		PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, postId);
            pstmt.setString(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { 
            System.err.println("게시글 삭제 중 SQL 오류 발생: " + e.getMessage()); 
            return false;
        }
    }
    
    // 6. 관리자가 게시글 삭제 (관리자 전용 - 작성자 확인 없이)
    public boolean deletePostByAdmin(int postId) {
        String SQL = "UPDATE post SET is_deleted = 1 WHERE post_id = ?";
        try (Connection conn = DBUtil.getConnection(); 
        		PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, postId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { 
            System.err.println("관리자 게시글 삭제 중 SQL 오류 발생: " + e.getMessage()); 
            return false;
        }
    }
    
    // 7. 게시글 검색 (제목, 내용, 작성자로 검색)
    public List<Post> searchPosts(String keyword, String searchType) {
        List<Post> postList = new ArrayList<>();
        String SQL = "";
        
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllPosts();
        }
        
        keyword = "%" + keyword.trim() + "%";
        System.out.println("s"+searchType);
        switch (searchType) {
            case "title":
                SQL = "SELECT  ROW_NUMBER() OVER (ORDER BY created_at DESC) AS rowNum, "
                		+ "post_id AS postId, title, author_id AS authorId, view_count AS viewCount, created_at AS createdAt "
                		+ "FROM post WHERE title LIKE ? AND is_deleted = 0 ORDER BY post_id DESC";
                break;
            case "author":
                SQL = "SELECT  ROW_NUMBER() OVER (ORDER BY created_at DESC) AS rowNum, "
                		+ "post_id AS postId, title, author_id AS authorId, view_count AS viewCount, created_at AS createdAt"
                		+ " FROM post WHERE author_id LIKE ? AND is_deleted = 0 ORDER BY post_id DESC";
                break;
            case "content":
                SQL = "SELECT  ROW_NUMBER() OVER (ORDER BY created_at DESC) AS rowNum, "
                		+ "post_id AS postId, title, author_id AS authorId, view_count AS viewCount, created_at AS createdAt"
                		+ " FROM post WHERE content LIKE ? AND is_deleted = 0 ORDER BY post_id DESC";
                break;
            default: // "all"
                SQL = "SELECT  ROW_NUMBER() OVER (ORDER BY created_at DESC) AS rowNum, "
                		+ "post_id AS postId, title, author_id AS authorId, view_count AS viewCount, created_at AS createdAt"
                		+ " FROM post WHERE ( title LIKE ? OR content LIKE ? OR author_id LIKE ? ) AND is_deleted = 0 ORDER BY post_id DESC";
                break;
        }
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            
            if ("all".equals(searchType)) {
                pstmt.setString(1, keyword);
                pstmt.setString(2, keyword);
                pstmt.setString(3, keyword);
                
                System.out.println("pstmt"+pstmt);
            } else {
                pstmt.setString(1, keyword);
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Post post = new Post();
                    post.setRowNum(rs.getInt("rowNum"));
                    post.setPostId(rs.getInt("postId"));
                    post.setTitle(rs.getString("title"));
                    post.setAuthor(rs.getString("authorId"));
                    post.setViewCount(rs.getInt("viewCount"));
                    post.setCreatedAt(rs.getTimestamp("createdAt"));
                    if (rs.getString("content") != null) {
                        post.setContent(rs.getString("content"));
                    }
                    postList.add(post);
                }
            }
        } catch (SQLException e) { 
            System.err.println("게시글 검색 중 SQL 오류 발생: " + e.getMessage()); 
        }
        return postList;
    }
    
    // 7-1. 페이징된 게시글 검색
    public List<Post> searchPostsWithPaging(String keyword, String searchType, int page, int pageSize) {
        List<Post> postList = new ArrayList<>();
        String SQL = "";
        int offset = (page - 1) * pageSize;
        
        if (keyword == null || keyword.trim().isEmpty()) {
            return getPostsWithPaging(page, pageSize);
        }
        
        keyword = "%" + keyword.trim() + "%";
        
        switch (searchType) {
            case "title":
                SQL = "SELECT  ROW_NUMBER() OVER (ORDER BY created_at DESC) AS rowNum, "
                		+ "post_id AS postId, title, content, author_id AS authorId, view_count AS viewCount, created_at AS createdAt"
                		+ " FROM post WHERE title LIKE ? AND is_deleted = 0 ORDER BY post_id DESC LIMIT ? OFFSET ?";
                break;
            case "author":
                SQL = "SELECT  ROW_NUMBER() OVER (ORDER BY created_at DESC) AS rowNum, "
                		+ "post_id AS postId, title, content, author_id AS authorId, view_count AS viewCount, created_at AS createdAt"
                		+ " FROM post WHERE author_id LIKE ? AND is_deleted = 0 ORDER BY post_id DESC LIMIT ? OFFSET ?";
                break;
            case "content":
                SQL = "SELECT  ROW_NUMBER() OVER (ORDER BY created_at DESC) AS rowNum, "
                		+ "post_id AS postId, title, content, author_id AS authorId, view_count AS viewCount, created_at AS createdAt"
                		+ " FROM post WHERE content LIKE ? AND is_deleted = 0 ORDER BY post_id DESC LIMIT ? OFFSET ?";
                break;
            default: // "all"
                SQL = "SELECT  ROW_NUMBER() OVER (ORDER BY created_at DESC) AS rowNum, "
                		+ "post_id AS postId, title, content, author_id AS authorId, view_count AS viewCount, created_at AS createdAt"
                		+ " FROM post WHERE (title LIKE ? OR content LIKE ? OR author_id LIKE ? )AND is_deleted = 0 "
                		+ "ORDER BY post_id DESC LIMIT ? OFFSET ?";
                
                break;
        }
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            
            if ("all".equals(searchType)) {
                pstmt.setString(1, keyword);
                pstmt.setString(2, keyword);
                pstmt.setString(3, keyword);
                pstmt.setInt(4, pageSize);
                pstmt.setInt(5, offset);
                System.out.println("==pstmt" + pstmt);
            } else {
                pstmt.setString(1, keyword);
                pstmt.setInt(2, pageSize);
                pstmt.setInt(3, offset);
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Post post = new Post();
                    post.setRowNum(rs.getInt("rowNum"));
                    post.setPostId(rs.getInt("postId"));
                    post.setTitle(rs.getString("title"));
                    post.setAuthor(rs.getString("authorId"));
                    post.setViewCount(rs.getInt("viewCount"));
                    post.setCreatedAt(rs.getTimestamp("createdAt"));
                    if (rs.getString("content") != null) {
                        post.setContent(rs.getString("content"));
                    }
                    postList.add(post);
                }
            }
        } catch (SQLException e) { 
            System.err.println("게시글 검색(페이징) 중 SQL 오류 발생: " + e.getMessage()); 
        }
        return postList;
    }
}
