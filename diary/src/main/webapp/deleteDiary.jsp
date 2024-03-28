<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	String diary_date = request.getParameter("diary_date");
	System.out.println("diary_date: " + diary_date);
	
	// 구현 코드
	String sql = "delete from diary where diary_date = ?";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection c = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt = c.prepareStatement(sql);
	stmt.setString(1, diary_date);
	int row = stmt.executeUpdate();
	
	System.out.println(row + " <-- row");
	
	if(row == 0) {
		System.out.println("삭제 성공");
		response.sendRedirect("/diary/diary.jsp");
		
	}else {
		System.out.println("삭제 실패");
		response.sendRedirect("/diary/diary.jsp");
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>&#129528;삭제</title>
</head>
<body>

</body>
</html>