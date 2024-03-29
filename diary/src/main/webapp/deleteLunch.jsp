<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import="java.net.*"%>
<%
	/* 점심 투표 */
	String lunch_date = request.getParameter("lunch_date");
	
	System.out.println("****");
	System.out.println("lunch_date: " + lunch_date);
	
	String sql1 = "delete from lunch where lunch_date=?";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt1 = null;
	stmt1 = conn.prepareStatement(sql1); 
	
	stmt1.setString(1, lunch_date);
	
	int row = 0;
	row = stmt1.executeUpdate();
	
	if(row == 1) {
		System.out.println("삭제 성공");
	} else{
		System.out.println("삭제 실패");
	}
	response.sendRedirect("/diary/statsLunch.jsp");
%>