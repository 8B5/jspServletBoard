// my-board-project/src/main/java/com/myboard/dao/UserDAO.java

package com.myboard.dao;
import com.myboard.dto.User;
import com.myboard.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private static final String DEFAULT_PASSWORD = "1234";

    static {
        normalizeLegacyPasswords();
    }

    private static void normalizeLegacyPasswords() {
        String SQL = "UPDATE user SET password = ? WHERE password LIKE '$2%'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, DEFAULT_PASSWORD);
            int updated = pstmt.executeUpdate();
            if (updated > 0) {
                System.out.println("기존 해시 비밀번호 " + updated + "건을 기본 비밀번호로 초기화했습니다.");
            }
        } catch (SQLException e) {
            System.err.println("기존 해시 비밀번호 초기화 중 SQL 오류: " + e.getMessage());
        }
    }

    // 0. 아이디 중복 체크
    public boolean checkUserIdExists(String userId) {
        String SQL = "SELECT COUNT(*) FROM user WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) { 
            System.err.println("아이디 중복 체크 중 SQL 오류: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // 0-1. 이메일 중복 체크
    public boolean checkEmailExists(String email) {
        String SQL = "SELECT COUNT(*) FROM user WHERE email = ?";
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) { 
            System.err.println("이메일 중복 체크 중 SQL 오류: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // 1. 회원가입
    public boolean registerUser(User user) {
        // 입력값 검증
        if (user == null || user.getUserId() == null || user.getUserId().trim().isEmpty()) {
            System.err.println("회원가입 실패: 아이디가 비어있습니다.");
            return false;
        }
        if (user.getPassword() == null || user.getPassword().isEmpty()) {
            System.err.println("회원가입 실패: 비밀번호가 비어있습니다.");
            return false;
        }
        
        // 아이디 중복 체크
        if (checkUserIdExists(user.getUserId())) {
            System.err.println("이미 존재하는 아이디입니다: " + user.getUserId());
            return false;
        }
        
        // 이메일 중복 체크
        if (user.getEmail() != null && !user.getEmail().trim().isEmpty() && checkEmailExists(user.getEmail())) {
            System.err.println("이미 존재하는 이메일입니다: " + user.getEmail());
            return false;
        }
        
        String SQL = "INSERT INTO user (user_id, password, user_name, email, is_admin) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            
            pstmt.setString(1, user.getUserId().trim()); 
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getUserName() != null ? user.getUserName().trim() : ""); 
            pstmt.setString(4, user.getEmail() != null ? user.getEmail().trim() : null);
            pstmt.setBoolean(5, false); // 일반 회원가입은 관리자 아님
            
            int result = pstmt.executeUpdate();
            if (result > 0) {
                System.out.println("회원가입 성공: " + user.getUserId());
                return true;
            } else {
                System.err.println("회원가입 실패: executeUpdate 반환값이 0");
                return false;
            }
        } catch (SQLException e) {
            // 중복 키 에러 처리 (동시 가입 시 발생 가능)
            String sqlState = e.getSQLState();
            int errorCode = e.getErrorCode();
            
            // MariaDB 중복 키 에러 코드
            if ("23000".equals(sqlState) || errorCode == 1062) {
                String errorMsg = e.getMessage().toLowerCase();
                if (errorMsg.contains("userid") || errorMsg.contains("primary")) {
                    System.err.println("회원가입 실패: 이미 존재하는 아이디입니다.");
                } else if (errorMsg.contains("email")) {
                    System.err.println("회원가입 실패: 이미 존재하는 이메일입니다.");
                } else {
                    System.err.println("회원가입 실패: 중복된 데이터가 있습니다.");
                }
            } else {
                System.err.println("회원가입 중 SQL 오류: " + e.getMessage());
                System.err.println("SQL 상태 코드: " + sqlState);
                System.err.println("에러 코드: " + errorCode);
            }
            e.printStackTrace();
            return false; 
        }
    }
    
    // 2. 로그인
    public User loginUser(String userId, String password) {
        // 입력값 검증
        if (userId == null || userId.trim().isEmpty()) {
            System.err.println("로그인 실패: 아이디가 비어있습니다.");
            return null;
        }
        if (password == null || password.isEmpty()) {
            System.err.println("로그인 실패: 비밀번호가 비어있습니다.");
            return null;
        }
        
        String SQL = "SELECT user_id AS userId, password, user_name AS userName, email, is_admin AS isAdmin"
        		+ " FROM user WHERE user_id = ?";
        User user = null;
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, userId.trim()); 
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    if (password.equals(storedPassword)) {
                        user = new User(); 
                        user.setUserId(rs.getString("userId")); 
                        user.setPassword(rs.getString("password"));
                        user.setUserName(rs.getString("userName")); 
                        user.setEmail(rs.getString("email"));
                        user.setAdmin(rs.getBoolean("isAdmin"));
                        System.out.println("로그인 성공: " + userId + " (관리자: " + user.isAdmin() + ")");
                    } else {
                        System.err.println("로그인 실패: 비밀번호 불일치 (아이디: " + userId + ")");
                    }
                } else {
                    System.err.println("로그인 실패: 존재하지 않는 아이디 (" + userId + ")");
                }
            }
        } catch (SQLException e) { 
            System.err.println("로그인 중 SQL 오류: " + e.getMessage());
            System.err.println("SQL 상태 코드: " + e.getSQLState());
            System.err.println("에러 코드: " + e.getErrorCode());
            e.printStackTrace();
        }
        return user;
    }
    
    // 3. 회원 정보 수정 (Update)
    public boolean updateUser(User user) {
        String SQL = "UPDATE user SET password = ?, user_name = ?, email = ? WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            String passwordToUpdate = user.getPassword();
            if (passwordToUpdate != null && !passwordToUpdate.isEmpty()) {
                // 제공된 비밀번호 그대로 사용
            } else {
                // 비밀번호가 비어있으면 기존 비밀번호 유지
                User existingUser = getUserById(user.getUserId());
                if (existingUser != null) {
                    passwordToUpdate = existingUser.getPassword();
                } else {
                    return false;
                }
            }
            
            pstmt.setString(1, passwordToUpdate); 
            pstmt.setString(2, user.getUserName());
            pstmt.setString(3, user.getEmail()); 
            pstmt.setString(4, user.getUserId()); 
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { 
            System.err.println("회원 정보 수정 중 SQL 오류 발생: " + e.getMessage()); 
            return false; 
        }
    }
    
    // 4. 관리자가 다른 사용자 정보 수정 (관리자 전용)
    public boolean updateUserByAdmin(User user) {
        String SQL = "UPDATE user SET password = ?, user_name = ?, email = ?, is_admin = ? WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            String passwordToUpdate = user.getPassword();
            if (passwordToUpdate != null && !passwordToUpdate.isEmpty()) {
                // 제공된 비밀번호 그대로 사용
            } else {
                // 비밀번호가 비어있으면 기존 비밀번호 유지
                User existingUser = getUserById(user.getUserId());
                if (existingUser != null) {
                    passwordToUpdate = existingUser.getPassword();
                } else {
                    return false;
                }
            }
            
            pstmt.setString(1, passwordToUpdate); 
            pstmt.setString(2, user.getUserName());
            pstmt.setString(3, user.getEmail());
            pstmt.setBoolean(4, user.isAdmin()); // 관리자 권한도 수정 가능
            pstmt.setString(5, user.getUserId()); 
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { 
            System.err.println("관리자 회원 정보 수정 중 SQL 오류 발생: " + e.getMessage()); 
            return false; 
        }
    }
    
    // 5. 계정 삭제 (Delete)
    public boolean deleteUser(String userId) {
        String SQL = "DELETE FROM user WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { 
            System.err.println("계정 삭제 중 SQL 오류 발생: " + e.getMessage()); 
            return false;
        }
    }
    
    // 6. 모든 사용자 목록 조회 (관리자 전용)
    public List<User> getAllUsers() {
        List<User> userList = new ArrayList<>();
        String SQL = "SELECT user_id AS userId, password, user_name AS userName, email, is_admin AS isAdmin"
        		+ " FROM user ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(SQL);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getString("userId"));
                user.setPassword(rs.getString("password"));
                user.setUserName(rs.getString("userName"));
                user.setEmail(rs.getString("email"));
                user.setAdmin(rs.getBoolean("isAdmin"));
                userList.add(user);
            }
        } catch (SQLException e) { 
            System.err.println("사용자 목록 조회 중 SQL 오류 발생: " + e.getMessage()); 
        }
        return userList;
    }
    
    // 7. 특정 사용자 조회
    public User getUserById(String userId) {
        if (userId == null || userId.trim().isEmpty()) {
            return null;
        }
        
        String SQL = "SELECT user_id AS userId, password, user_name AS userName, email, is_admin AS isAdmin "
        		+ "FROM user WHERE user_id = ?";
        User user = null;
        try (Connection conn = DBUtil.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, userId.trim());
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getString("userId"));
                    user.setPassword(rs.getString("password"));
                    user.setUserName(rs.getString("userName"));
                    user.setEmail(rs.getString("email"));
                    // isAdmin 필드를 명시적으로 조회 (BOOLEAN 또는 TINYINT(1))
                    boolean isAdmin = rs.getBoolean("isAdmin");
                    // ResultSet이 null이거나 0이면 false, 1이면 true
                    if (rs.wasNull()) {
                        isAdmin = false;
                    }
                    user.setAdmin(isAdmin);
                    System.out.println("getUserById: " + userId + " isAdmin=" + isAdmin);
                }
            }
        } catch (SQLException e) { 
            System.err.println("사용자 조회 중 SQL 오류 발생: " + e.getMessage());
            System.err.println("조회하려는 userId: " + userId);
            e.printStackTrace();
        }
        return user;
    }
}
