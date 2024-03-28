<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import="java.net.*"%>
<%
	//로그인
	// diary.login.my_session  => "OFF" -> redirect loginForm.jsp
	// 로그인 했을 때만 들어오기 가능.
	String Sql1 = "select my_session mySession from login";
	Class.forName("org.mariadb.jdbc.Driver");
	
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt1 = conn.prepareStatement(Sql1);
	rs1 = stmt1.executeQuery();
	String mySession = null;
	if(rs1.next()){
		mySession = rs1.getString("mySession");
	}
	System.out.println("mySession: " + mySession);
	if(mySession.equals("off")) {
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 부터 해주세요." ,"utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg); 
		 return;	// 코드 끝냄.
	}
%>
<%
	// 페이지
	int currentPage = 1;
		
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 디버깅
	System.out.println("currentPage " + currentPage);
	int rowPerPage = 10;
	/* if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	} */
	int startRow = (currentPage-1);
		
	// 검색
	String searchWord = "";
	if(request.getParameter("searchWord") != null){
		searchWord = request.getParameter("searchWord");
	}
	String sql2 = "select diary_date, title from diary where title like ? order by diary_date desc limit ?, ?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, "%" + searchWord + "%");
	stmt2.setInt(2, startRow);
	stmt2.setInt(3, rowPerPage);
	rs2 = stmt2.executeQuery();
	
	
	// 라스트 페이지 
	String sql3 = "Select count(*) cnt from diary where title like ?";
	PreparedStatement stmt3 = null;
	ResultSet rs3 = null;
	stmt3 = conn.prepareStatement(sql3);
	stmt3.setString(1, "%"+searchWord+"%");
	rs3 = stmt3.executeQuery();
	
	int totalRow = 0;
	if(rs3.next()){
		totalRow = rs3.getInt("cnt");
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
</head>
<body>
	<h2>검색</h2>		
				<table border="1">
				<th>날짜</th>
				<th>제목</th>
					<%
						while(rs2.next()){
					%>
					<tr>
						<td><%=rs2.getString("diary_date")%></td>
						<td><%=rs2.getString("title") %></td>
					<%
						}
					%>
					</tr>
					<form method="post" action="/diary/">
						<div>
							제목 검색:
							<input type="text" name="searchWord">
							<button type="submit">검색</button>
						</div>
					</form>
				</table>		
</body>
</html>