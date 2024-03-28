<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import="java.net.*"%>
<%
	// 로그인
	// diary.login.my_session  => "OFF" -> redirect loginForm.jsp
	// 
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
	
	String checkDate = request.getParameter("checkDate");
	
	String sql2 = "select diary_date diaryDate from diary where diary_date=?";
	// 결과가 있으면 이미 이 날짜에 일기가 있음. 이 날짜는 입력 안됨.
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, checkDate);
	rs2 = stmt2.executeQuery();
	if(rs2.next()){
		/*  System.out.println("");*/
		response.sendRedirect("/diary/addDiaryForm.jsp?checkDate=" + checkDate+"&ck=F");
	}else{
		response.sendRedirect("/diary/addDiaryForm.jsp?checkDate=" + checkDate+"&ck=T");
	}
			
%>