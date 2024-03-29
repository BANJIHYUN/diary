<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import= "java.net.URLEncoder"%>
<%
	String diary_date = request.getParameter("diary_date");
	String memo = request.getParameter("memo");
	// 디버깅
	
	String sql1 = "insert into comment(diary_date, memo, create_date, update_date) values(?, ?, NOW(), NOW())";
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	
	stmt1.setString(1, diary_date);
	stmt1.setString(2, memo);
	
	int row = 0;
	row = stmt1.executeUpdate();
	
	if(row == 1){
		System.out.println("입력 성공");
	}else {
		System.out.println("입력 실패");
	}
	response.sendRedirect("/diary/diaryOne.jsp?diary_date=" + diary_date);
	
%>