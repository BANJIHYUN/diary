<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import="java.net.*"%>
<%
	//로그인
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
%>
<%-- <%
	// checkDate
	String checkDate = request.getParameter("checkDate");
	System.out.println("checkDate: " + checkDate);
	if(checkDate == null){
		checkDate = "";
	}
	String ck = request.getParameter("ck");
	System.out.println("ck: " + ck);
	if(ck == null) {
		ck = "";
	}
	
	String msg = "";
	if(ck.equals("T")){
		msg = "입력이 가능한 날짜입니다.";
	} else if(ck.equals("F")){		
		msg = "점심 투표를 이미 진행했습니다.";
	}
%>  --%>
<%-- <%
	/* 점심 투표 */
	String lunch_date = request.getParameter("lunch_date");
	String menu = request.getParameter("menu");
	
	System.out.println("lunch_date: " + lunch_date);
	System.out.println("menu: " + menu);
	
	String sql3 = "insert into lunch(lunch_date, menu, update_date, create_date) values(?, ?, Now(), NOW())";
	PreparedStatement stmt3 = null;
	stmt3 = conn.prepareStatement(sql3); 
	
	stmt3.setString(1, lunch_date);
	stmt3.setString(2, menu);
	
	int row = 0;
	
	if(row == 0) {
		System.out.println("입력 성공");
		response.sendRedirect("/diary/lunchOne.jsp");
	} else{
		System.out.println("입력 실패");
	}
	
%> --%>

<%
 	String lunch_date = request.getParameter("lunch_date");
 	String menu = request.getParameter("menu");
 
 	System.out.println("****");
 	System.out.println("lunch_date:" + lunch_date);
 	System.out.println("menu:" + menu);
	
 	
%>
<%
	String checkDate = request.getParameter("checkDate");
	System.out.println("checkDate:" + checkDate);
%>
 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>점심 투표하기 + 상세 페이지</title>
	<!-- 구글 폰트 -->
 	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Bagel+Fat+One&family=Playpen+Sans:wght@100..800&display=swap" rel="stylesheet">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		*{
  		 font-family: "Playpen Sans", cursive;
  		 font-family: "Bagel Fat One", system-ui;
  		}
  		.a {
  			background: linear-gradient(0.25turn, #3f87a6, #ebf8e1, #f69d3c);
  		}
	</style>
</head>
<body>
<div class="container">
		<div class="row">
				<div class="col"></div>
				<div class="mt-5 col-7 bg-success-white border shadow-sm p-3 mb-5 bg-body-tertiary rounded">

				<h1>&#129528;점심 투표하기&#129528;</h1>
				
					<form method="post" action="/diary/lunchAction.jsp">
					<input type="text" name="checkDate" value ="<%=checkDate%>">
					<br>
					<span><점심 리스트></span>
					<div>
						<input type="radio" name= "menu" value="한식"> 한식 <br>
						<input type="radio" name="menu" value="중식"> 중식 <br>
						<input type="radio" name="menu" value="일식"> 일식 <br>
						<input type="radio" name="menu" value="양식"> 양식 <br>
						<input type="radio" name="menu" value="기타"> 기타 
					</div><br>
						<button type="submit" class="btn btn-warning">투표하기</button>
					<hr>
					</form>
					<form method="post" action="/diary/deleteLunch.jsp">
						<h1>&#129528;오늘의 점심은?&#129528;</h1>
						<div>날짜: <input type="text" name="lunch_date" value ="<%=lunch_date%>" readonly="readonly"></div>
						<div>메뉴: <input type="text" name="menu" value ="<%=menu%>" readonly="readonly"></div><br>
						<button type="submit" class="btn btn-warning">삭제</button>
					</form>
					</div>
					<div class="col"></div>
					</div>
					</div>
					
</body>
</html>