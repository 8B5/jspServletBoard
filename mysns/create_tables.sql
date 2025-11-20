-- 1. 데이터베이스 생성 및 선택
-- 데이터베이스가 없다면 생성하고 사용합니다.
CREATE DATABASE IF NOT EXISTS board_project_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE board_project_db;

-- 2. 사용자 테이블 (로그인/회원가입)

-- 외래 키 제약 조건 순서에 따라 드롭
DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS user;

CREATE TABLE user (
user_id VARCHAR(50) PRIMARY KEY,
password VARCHAR(255) NOT NULL,
user_name VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE,
is_admin BOOLEAN DEFAULT FALSE,  -- 관리자 여부
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 초기 계정 삽입
INSERT INTO user (user_id, password, user_name, email, is_admin) VALUES
('admin', '1234', '관리자', 'admin@example.com', TRUE),
('testuser', '1234', '테스터', 'test@example.com', FALSE);

-- 3. 게시글 테이블
-- 테이블 이름: post
CREATE TABLE post (
post_id INT AUTO_INCREMENT PRIMARY KEY,
title VARCHAR(200) NOT NULL,
content TEXT NOT NULL,
author_id VARCHAR(50) NOT NULL, 
view_count INT DEFAULT 0,            -- 조회수
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
is_deleted TINYINT DEFAULT 0 NOT NULL,

FOREIGN KEY (author) REFERENCES user(user_id) ON DELETE CASCADE

);

-- 게시글 데이터 삽입
INSERT INTO post (title, content, author) VALUES
('첫 번째 게시글', '도커 컴포즈로 완성한 JSP 프로젝트입니다.', 'admin'),
('도커 복원 테스트', '모든 파일이 정상적으로 복원되었는지 확인해 주세요.', 'testuser');

-- 4. 댓글 테이블
CREATE TABLE comment (
comment_id INT AUTO_INCREMENT PRIMARY KEY,
post_id INT NOT NULL,
author_id VARCHAR(50) NOT NULL,
content TEXT NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

FOREIGN KEY (post_id) REFERENCES post(post_id) ON DELETE CASCADE,
FOREIGN KEY (author) REFERENCES user(user_id) ON DELETE CASCADE


);

-- 샘플 댓글 삽입
INSERT INTO comment (post_id, author_id, content) VALUES
(1, 'testuser', '첫 게시글 축하합니다!'),
(2, 'admin', '네, 정상적으로 복원된 것 같습니다.');
