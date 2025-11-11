package com.myboard.common;

/**
 * 페이지 URL 상수 관리 클래스
 * 애플리케이션 전체에서 사용되는 URL을 중앙에서 관리합니다.
 */
public class PageURL {

	// 메인 페이지
	public static final String INDEX_PAGE = "index.jsp";
    
    // 기본 페이지
    private static final String INDEX_BASE = "index.jsp?center=";
    
    // SNS 관련 페이지
    public static final String LOGIN_PAGE = INDEX_BASE + "/sns/login.jsp";
    public static final String BOARD_PAGE = INDEX_BASE + "/sns/board.jsp";
    public static final String WRITE_POST_PAGE = INDEX_BASE + "/sns/writePost.jsp";

	 // 사용자 관련 페이지
	 public static final String REGISTER_PAGE = INDEX_BASE + "/sns/register.jsp";
	 public static final String EDIT_PROFILE_PAGE = INDEX_BASE + "/sns/editProfile.jsp";
	 public static final String ADMIN_USER_LIST_PAGE = INDEX_BASE + "/sns/adminUserList.jsp";
    
    // 에러 파라미터가 포함된 페이지
    public static final String WRITE_POST_ERROR = WRITE_POST_PAGE + "?error=fail";
    
    /**
     * 게시글 상세 페이지 URL 생성
     * @param postId 게시글 ID
     * @return 게시글 상세 페이지 URL
     */
    public static String getPostDetailPage(int postId) {
        return INDEX_BASE + "/sns/postDetail.jsp?id=" + postId;
    }
    
    /**
     * 게시글 상세 페이지 URL 생성 (에러 포함)
     * @param postId 게시글 ID
     * @param error 에러 메시지
     * @return 게시글 상세 페이지 URL (에러 포함)
     */
    public static String getPostDetailPageWithError(int postId, String error) {
        return INDEX_BASE + "/sns/postDetail.jsp?id=" + postId + "&error=" + error;
    }

    /**
     * 댓글 관련 에러가 포함된 게시글 상세 페이지 URL 생성
     * @param postId 게시글 ID
     * @param errorType 에러 타입 (comment_empty, comment_fail, comment_permission, comment_update_fail, comment_delete_fail)
     * @return 게시글 상세 페이지 URL (댓글 에러 포함)
     */
    public static String getPostDetailPageWithCommentError(int postId, String errorType) {
        return INDEX_BASE + "/sns/postDetail.jsp?id=" + postId + "&error=" + errorType;
    }
    
    // Private constructor to prevent instantiation
    private PageURL() {
        throw new AssertionError("Cannot instantiate constants class");
    }
}