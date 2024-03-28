<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>

<%
	// 입력값
	String diary_date = request.getParameter("diary_date");
	String feeling = request.getParameter("feeling");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	
	// 디버깅
	System.out.println("diary_date: " + diary_date);
	System.out.println("feeling" + feeling);
	System.out.println("title: " + title);
	System.out.println("weather: " + weather);
	System.out.println("content: " + content);

	String sql1 = "insert into diary(diary_date, feeling, title, weather, content, update_date, create_date) values(?, ?, ?, ?, ?, Now(), Now())";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt1 = null;
	stmt1 = conn.prepareStatement(sql1); 
	
	stmt1.setString(1, diary_date);
	stmt1.setString(2, feeling);
	stmt1.setString(3, title);	
	stmt1.setString(4, weather);
	stmt1.setString(5, content);

	
	int row = 0;
	row = stmt1.executeUpdate();
	if(row == 0){
		System.out.println("입력 성공");
	}else{
		System.out.println("입력 실패");
	}
	response.sendRedirect("/diary/diary.jsp");
%>