package com.myboard.listener;

import java.io.InputStream;
import java.util.Properties;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;


@WebListener
public class EnvLoaderListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
    	
        // 1. APP_ENV 환경 변수(또는 시스템 속성)를 확인
        String appEnv = System.getenv("APP_ENV");
        if (appEnv == null) {
            appEnv = System.getProperty("APP_ENV", "dev"); // 기본값은 dev로 설정
        }
        // 2. 환경에 따라 파일 이름 결정
        // dev.env - local
        // prod.env - 배포
        String envFileName = appEnv + ".env"; // "dev.env"
        
        // 3. WEB-INF 리소스 경로 지정
        // env 파일을 WEB-INF 폴더 밑에 둠
        String resourcePath = "/WEB-INF/" + envFileName;

        Properties props = new Properties();

        // 4. getResourceAsStream()을 사용하여 InputStream을 얻습니다. (WEB-INF 파일 접근)
        try (InputStream input = sce.getServletContext().getResourceAsStream(resourcePath)) {
            
            // 파일이 존재하지 않는 경우 (InputStream이 null) 처리
            if (input == null) {
                // 파일 시스템 에러가 아닌, 리소스 미발견으로 간주하고 예외 처리
                throw new IllegalStateException("웹 리소스 스트림을 찾을 수 없습니다.");
            }
            
            props.load(input);

            // 5. 읽은 값을 JVM 시스템 속성으로 주입
            props.forEach((key, value) -> 
                System.setProperty(key.toString(), value.toString()));

            System.out.println("==" + resourcePath + " 파일 로드 성공!");
            
        } catch (Exception e) {
            // 실패 시 정확한 리소스 경로를 출력
            System.err.println("==" + resourcePath + " 파일 로드 실패!");
            // System.err.println("원인: " + e.getMessage()); // 필요 시 주석 해제하여 상세 로그 확인
        }
    }
}