package com.myboard.controller;

import com.myboard.common.PageURL;
import com.myboard.dao.UserDAO;
import com.myboard.dto.User;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/user") 
public class UserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    String gotoRegisterUrl = PageURL.REGISTER_PAGE;
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        if ("register".equals(action)) {
            handleRegister(request, response);
        } else if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("edit".equals(action)) {
            handleEditProfile(request, response);
        } else if ("adminEdit".equals(action)) {
            handleAdminEditUser(request, response);
        } else {
            response.sendRedirect(PageURL.INDEX_PAGE); 
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
        
        if ("logout".equals(action)) {
            request.getSession().invalidate();
            response.sendRedirect(PageURL.INDEX_PAGE);
        } else if ("profile".equals(action)) {
            request.getRequestDispatcher(PageURL.EDIT_PROFILE_PAGE).forward(request, response);
        } else if ("delete".equals(action)) {
            handleDeleteAccount(request, response, loggedInUser);
        } else if ("adminList".equals(action) && loggedInUser.isAdmin()) {
            handleAdminUserList(request, response);
        } else if ("adminEdit".equals(action) && loggedInUser.isAdmin()) {
            handleAdminEditUserPage(request, response);
        } else if ("adminDelete".equals(action) && loggedInUser.isAdmin()) {
            handleAdminDeleteUser(request, response);
        } else {
            response.sendRedirect(PageURL.INDEX_PAGE);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        User newUser = new User();
        String userId = request.getParameter("userId");
        String password = request.getParameter("password");
        String userName = request.getParameter("userName");
        String email = request.getParameter("email");
        
        // 입력값 검증
        if (userId == null || userId.trim().isEmpty() || userId.trim().length() < 4) {
            request.setAttribute("errorMessage", "아이디는 4자 이상 입력해주세요.");
            request.getRequestDispatcher(gotoRegisterUrl).forward(request, response);
            return;
        }
        if (password == null || password.trim().isEmpty() || password.length() < 6) {
            request.setAttribute("errorMessage", "비밀번호는 6자 이상 입력해주세요.");
            request.getRequestDispatcher(gotoRegisterUrl).forward(request, response);
            return;
        }
        if (userName == null || userName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "이름을 입력해주세요.");
            request.getRequestDispatcher(gotoRegisterUrl).forward(request, response);
            return;
        }
        if (email == null || email.trim().isEmpty() || !email.contains("@")) {
            request.setAttribute("errorMessage", "올바른 이메일을 입력해주세요.");
            request.getRequestDispatcher(gotoRegisterUrl).forward(request, response);
            return;
        }
        
        // 중복 체크
        if (userDAO.checkUserIdExists(userId.trim())) {
            request.setAttribute("errorMessage", "이미 사용 중인 아이디입니다.");
            request.getRequestDispatcher(gotoRegisterUrl).forward(request, response);
            return;
        }
        if (userDAO.checkEmailExists(email.trim())) {
            request.setAttribute("errorMessage", "이미 사용 중인 이메일입니다.");
            request.getRequestDispatcher(gotoRegisterUrl).forward(request, response);
            return;
        }
        
        newUser.setUserId(userId.trim());
        newUser.setPassword(password);
        newUser.setUserName(userName.trim());
        newUser.setEmail(email.trim());

        try {
            if (userDAO.registerUser(newUser)) {
                request.setAttribute("successMessage", "회원가입이 완료되었습니다. 로그인해 주세요.");
                request.getRequestDispatcher(PageURL.LOGIN_PAGE).forward(request, response);
            } else {
                // 중복 체크는 이미 위에서 했지만, 동시 가입 등의 경우를 대비해 재확인
                if (userDAO.checkUserIdExists(userId.trim())) {
                    request.setAttribute("errorMessage", "이미 사용 중인 아이디입니다.");
                } else if (email != null && !email.trim().isEmpty() && userDAO.checkEmailExists(email.trim())) {
                    request.setAttribute("errorMessage", "이미 사용 중인 이메일입니다.");
                } else {
                    request.setAttribute("errorMessage", "회원가입에 실패했습니다. 다시 시도해 주세요.");
                }
                request.getRequestDispatcher(gotoRegisterUrl).forward(request, response);
            }
        } catch (Exception e) {
            System.err.println("회원가입 처리 중 예외 발생: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "회원가입 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
            request.getRequestDispatcher(gotoRegisterUrl).forward(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userId = request.getParameter("userId");
        String password = request.getParameter("password");
        
        // 입력값 검증
        if (userId == null || userId.trim().isEmpty()) {
            request.setAttribute("errorMessage", "아이디를 입력해주세요.");
            request.getRequestDispatcher(PageURL.LOGIN_PAGE).forward(request, response);
            return;
        }
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "비밀번호를 입력해주세요.");
            request.getRequestDispatcher(PageURL.LOGIN_PAGE).forward(request, response);
            return;
        }
        
        User user = userDAO.loginUser(userId.trim(), password);
        
        if (user != null) {
            request.getSession().setAttribute("loggedInUser", user);
            System.out.println("세션에 사용자 저장: " + user.getUserId() + " (관리자: " + user.isAdmin() + ")");
            response.sendRedirect(PageURL.BOARD_PAGE);
        } else {
            request.setAttribute("errorMessage", "아이디 또는 비밀번호가 일치하지 않습니다. 데이터베이스 연결을 확인해주세요.");
            request.getRequestDispatcher(PageURL.LOGIN_PAGE).forward(request, response);
        }
    }
    
    // 회원 정보 수정 처리 (DAO 호출)  신규 메서드
    private void handleEditProfile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        User loggedInUser = (User)request.getSession().getAttribute("loggedInUser");
        if (loggedInUser == null) {
        	response.sendRedirect(PageURL.LOGIN_PAGE);
            return;
        }

        User updatedUser = new User();
        updatedUser.setUserId(loggedInUser.getUserId()); // 아이디는 수정 불가, 세션에서 가져옴
        updatedUser.setPassword(request.getParameter("password")); // 수정된 비밀번호
        updatedUser.setUserName(request.getParameter("userName")); // 수정된 이름
        updatedUser.setEmail(request.getParameter("email")); // 수정된 이메일

        if (userDAO.updateUser(updatedUser)) {
            // 수정 성공 시, 세션 정보 갱신 후 목록으로 이동
            request.getSession().setAttribute("loggedInUser", updatedUser);
            request.setAttribute("successMessage", "회원 정보 수정이 완료되었습니다.");
            request.getRequestDispatcher(PageURL.BOARD_PAGE).forward(request, response);
        } else {
            request.setAttribute("errorMessage", "정보 수정에 실패했습니다. 다시 시도해 주세요.");
            request.getRequestDispatcher(PageURL.EDIT_PROFILE_PAGE).forward(request, response);
        }
    }
    
    // 계정 삭제 처리 (DAO 호출)
    private void handleDeleteAccount(HttpServletRequest request, HttpServletResponse response, User loggedInUser) 
            throws IOException, ServletException {
        
        if (userDAO.deleteUser(loggedInUser.getUserId())) {
            // 삭제 성공 시 세션을 무효화하고 메인 페이지로 이동
            request.getSession().invalidate();
            request.setAttribute("successMessage", "탈퇴가 완료되었습니다.");
            request.getRequestDispatcher(PageURL.INDEX_PAGE).forward(request, response);
        } else {
            // 삭제 실패 시 프로필 페이지로 돌아가 에러 메시지 표시
            request.setAttribute("errorMessage", "계정 삭제에 실패했습니다. 다시 시도해 주세요.");
            request.getRequestDispatcher(PageURL.EDIT_PROFILE_PAGE).forward(request, response);
        }
    }
    
    // 관리자: 사용자 목록 조회
    private void handleAdminUserList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<User> userList = userDAO.getAllUsers();
        request.setAttribute("userList", userList);
        request.getRequestDispatcher(PageURL.ADMIN_USER_LIST_PAGE).forward(request, response);
    }
    
    // 관리자: 사용자 수정 페이지
    private void handleAdminEditUserPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userId = request.getParameter("userId");
        if (userId == null || userId.isEmpty()) {
            response.sendRedirect("user?action=adminList");
            return;
        }
        
        User targetUser = userDAO.getUserById(userId);

        if (targetUser == null) {
            response.sendRedirect("user?action=adminList");
            return;
        }
        
        request.setAttribute("targetUser", targetUser);
        

        request.getRequestDispatcher(PageURL.ADMIN_USER_EDIT_PAGE).forward(request, response);
    }
    
    // 관리자: 사용자 정보 수정 처리
    private void handleAdminEditUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        User loggedInUser = (User)request.getSession().getAttribute("loggedInUser");
        if (loggedInUser == null || !loggedInUser.isAdmin()) {
            response.sendRedirect(PageURL.INDEX_PAGE);
            return;
        }
        
        String targetUserId = request.getParameter("userId");
        if (targetUserId == null || targetUserId.isEmpty()) {
            response.sendRedirect("user?action=adminList");
            return;
        }
        
        User updatedUser = new User();
        updatedUser.setUserId(targetUserId);
        updatedUser.setPassword(request.getParameter("password"));
        updatedUser.setUserName(request.getParameter("userName"));
        updatedUser.setEmail(request.getParameter("email"));
        
        // 관리자 권한 설정 (체크박스 값)
        String isAdminParam = request.getParameter("isAdmin");
        updatedUser.setAdmin("on".equals(isAdminParam) || "true".equals(isAdminParam));
        
        if (userDAO.updateUserByAdmin(updatedUser)) {
            request.setAttribute("successMessage", "사용자 정보가 수정되었습니다.");
            handleAdminUserList(request, response);
        } else {
            request.setAttribute("errorMessage", "사용자 정보 수정에 실패했습니다.");
            handleAdminEditUserPage(request, response);
        }
    }
    
    // 관리자: 사용자 계정 삭제
    private void handleAdminDeleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        User loggedInUser = (User)request.getSession().getAttribute("loggedInUser");
        if (loggedInUser == null || !loggedInUser.isAdmin()) {
            response.sendRedirect(PageURL.INDEX_PAGE);
            return;
        }
        
        String targetUserId = request.getParameter("userId");
        if (targetUserId == null || targetUserId.isEmpty()) {
            request.setAttribute("errorMessage", "삭제할 사용자 ID가 지정되지 않았습니다.");
            handleAdminUserList(request, response);
            return;
        }
        
        // 자기 자신은 삭제할 수 없도록 체크
        if (targetUserId.equals(loggedInUser.getUserId())) {
            request.setAttribute("errorMessage", "자신의 계정은 삭제할 수 없습니다. 계정 삭제는 내 정보 페이지에서 가능합니다.");
            handleAdminUserList(request, response);
            return;
        }
        
        if (userDAO.deleteUser(targetUserId)) {
            request.setAttribute("successMessage", "사용자 계정이 삭제되었습니다.");
            handleAdminUserList(request, response);
        } else {
            request.setAttribute("errorMessage", "사용자 계정 삭제에 실패했습니다.");
            handleAdminUserList(request, response);
        }
    }
}
