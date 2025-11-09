<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.myboard.dto.User" %>

 <link rel="stylesheet" href="sns/css/style.css">


<%
request.setCharacterEncoding("UTF-8");
	String center = request.getParameter("center");
	if(center == null){
		center = "sns/main.jsp";
	}
%>

<%-- 1. 헤더 포함 (로그인 UI 포함) --%>
<%@ include file="sns/comm/header.jsp" %> 

<!-- <div class="container"> -->
     <!--메뉴에 따라 바뀔 부분 -->
	<jsp:include page="<%=center %>" />
    <!-- 여기까지 바뀌는 부분 -->
<!-- </div> -->

<%-- 2. 푸터 포함 --%>
<%-- <%@ include file="sns/comm/footer.jsp" %> --%>