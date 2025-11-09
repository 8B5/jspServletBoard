package com.myboard.util;

public class PathConstants {
    
    // 기본 메인 페이지 (센터 파라미터가 없는 경우)
    public static final String INDEX_PAGE = "index.jsp";
    
    // 로그인 페이지 경로
    // '/sns/login.jsp'를 center 파라미터 값으로 사용합니다.
    public static final String LOGIN_PAGE_CENTER = "/sns/login.jsp";
    
    // 게시판 목록 페이지 경로
    public static final String BOARD_LIST_CENTER = "/sns/board.jsp";

    // 리다이렉션 URL을 생성하는 공통 메서드
    public static String getCenterRedirectPath(String centerPage) {
        return INDEX_PAGE + "?center=" + centerPage;
    }
}