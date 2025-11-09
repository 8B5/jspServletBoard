package com.myboard.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    // 1. 드라이버 이름은 상수로 유지하거나, 시스템 속성에서 읽어옵니다.
    // 여기서는 시스템 속성을 먼저 시도하고, 없으면 하드코딩된 MariaDB 드라이버를 사용합니다.
    private static final String DEFAULT_DRIVER = "org.mariadb.jdbc.Driver";

    // 2. 드라이버 로드는 getConnection() 전에 static 블록에서 처리
    static {
        // DB_DRIVER 속성을 읽어오거나, 기본값을 사용
        String driver = System.getProperty("DB_DRIVER");
        if (driver == null) {
            driver = DEFAULT_DRIVER;
        }

        try {
            // 드라이버 로드
            Class.forName(driver);
            System.out.println("MariaDB 드라이버 로드 성공");
        } catch (ClassNotFoundException e) {
            System.err.println("MariaDB 드라이버를 찾을 수 없습니다!");
            e.printStackTrace();
            // 애플리케이션 시작을 막거나 로그를 남기는 것이 일반적
        }
    }

    /**
     * 환경 변수 또는 시스템 속성에서 DB 정보를 가져와 연결을 생성합니다.
     * @return Connection 객체
     * @throws SQLException 연결 실패 시
     */
    public static Connection getConnection() throws SQLException {
        
        // 3. DB 접속 정보는 메서드 호출 시 시스템 속성(EnvLoaderListener가 주입)을 먼저 확인
        String url = System.getProperty("DB_URL");
        String user = System.getProperty("DB_USER");
        String password = System.getProperty("DB_PASSWORD");
        
        // 시스템 속성에 없으면 환경 변수(Docker run -e) 확인 (안전 장치)
        if (url == null) {
            url = System.getenv("DB_URL");
            user = System.getenv("DB_USER");
            password = System.getenv("DB_PASSWORD");
        }
        
        // 4. URL 정보가 없는 경우 예외 처리
        if (url == null || url.isEmpty()) {
            throw new SQLException("DB_URL 정보가 환경 설정에 없습니다.");
        }

        try {
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("데이터베이스 연결 성공: " + url);
            return conn;
        } catch (SQLException e) {
            System.err.println("데이터베이스 연결 실패!");
            System.err.println("URL: " + url);
            System.err.println("사용자: " + user);
            System.err.println("에러 메시지: " + e.getMessage());
            System.err.println("SQL 상태: " + e.getSQLState());
            System.err.println("에러 코드: " + e.getErrorCode());
            System.err.println("원인: DB 설정을 확인하거나 Docker 컨테이너 실행 여부를 확인하세요.");
            throw e;
        }
    }
}