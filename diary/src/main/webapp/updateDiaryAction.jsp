<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	String diary_date = request.getParameter("diary_date");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	
	System.out.println("diary_date" + diary_date);
	System.out.println("title" + title);
	System.out.println("weather" + weather);
	System.out.println("content" + content);
	
	String sql = "update diary set title =?, weather=?, content=? WHERE diary_date=?";
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection c = null;
	c = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt = null;
	stmt = c.prepareStatement(sql);
	stmt.setString(1, title); 
	stmt.setString(2, weather); 
	stmt.setString(3, content);
	stmt.setString(4, diary_date);
	
	int row = 0; 
	row = stmt.executeUpdate();
	

	// 3. 결과
	if(row == 1){
		response.sendRedirect("/diary/diaryOne.jsp?diary_date=" + diary_date);
	}else {
		response.sendRedirect("/diary/updateDiaryForm.jsp?diary_date=" + diary_date);
	}
	
	// db서버 닫는다.
		stmt.close();
		c.close();
%>