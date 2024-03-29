<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%
	String diary_date = request.getParameter("diary_date");
	int comment_no = Integer.parseInt(request.getParameter("comment_no"));
	
	System.out.println("diary_date" + diary_date);
	System.out.println("comment_no" + comment_no);
	
	String sql = "delete from comment where comment_no=?";
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt1 = null;
	stmt1 = conn.prepareStatement(sql);
	stmt1.setInt(1, comment_no);
	
	int row = 0;
	row = stmt1.executeUpdate();
	
	if(row == 0){
		System.out.println("삭제성공");
	}
	response.sendRedirect("/diary/diaryOne.jsp?diary_date=" + diary_date + "&comment_no=" + comment_no);
%>
