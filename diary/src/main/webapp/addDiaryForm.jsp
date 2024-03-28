<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%
	String sql1 = "select my_session mySession from login";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	String mySession = null;
	if(rs1.next()) {
		mySession = rs1.getString("mySession");
	}
	//  로그인 off되었을 떄
	if(mySession.equals("off")){
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
		return;
	}
%>
<%
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
		msg = "일기가 이미 존재하는 날짜입니다.";
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>addDiaryForm</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- 구글 폰트 -->
 	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Bagel+Fat+One&family=Playpen+Sans:wght@100..800&display=swap" rel="stylesheet">
	<style>
		body {
			background: linear-gradient(0.25turn, #3f87a6, #ebf8e1, #f69d3c);
			background-size: 100% 150%; 
		}
		*{
  		 font-family: "Playpen Sans", cursive;
  		  font-family: "Bagel Fat One", system-ui;
  		}
  		.a{
  			align-cotent : center
  			text-align:
  		}
	</style>
</head>
<body>
<div class="a">
	<div class="row">
	<div class="col"></div>
		<div class="mt-5 col-7 bg-success-white border shadow-sm p-3 mb-5 bg-body-tertiary rounded">
				<h1>&#129528;TOday's Diary&#129528;</h1>
				<form method="post" action="/diary/checkDateAction.jsp">
					<div>
						날짜확인: <input type="date" name="checkDate" value ="<%=checkDate%>" class="btn btn-outline-warning">
						<span><%=msg%></span>
					</div>
					<br>
				<button type="submit" class="btn btn-outline-warning">가능한 날짜인지 확인</button>	 -> checkDate : <%=checkDate%> / ck : <%=ck%>	
				<hr>
				</form>
				<form method ="post" action="/diary/addDiaryAction.jsp">
					<div>
						날짜 &nbsp;
						<% 
							if(ck.equals("T")){
						%>
						 		<input type="text" name="diary_date" readonly="readonly" value ="<%=checkDate%>" class="btn btn-outline-info">
						<% 
							}else if(ck.equals("F")){
						%>
								<input type="text" name="diary_date" readonly="readonly">
						<% 
							}
						%>
					</div>
					<br>
					<div>
						기분 &nbsp;
						<input type="radio" name="feeling" value="&#128513;"> &#128513;
						<input type="radio" name="feeling" value="&#128529;"> &#128529;
						<input type="radio" name="feeling" value="&#128545;"> &#128545;
						<input type="radio" name="feeling" value="&#128557;"> &#128557;
						<input type="radio" name="feeling" value="&#128567;"> &#128567;
					</div>
					<br>
					<div>
						제목 &nbsp;<input type="text" name= "title" class="btn btn-outline-info">
					</div>
					<br>
					<div>
						날씨 &nbsp;
						<select name= "weather"  class="btn btn-outline-dark">
							<option value="맑음">맑음</option>
							<option value="흐림">흐림</option>
							<option value="비">비</option>
							<option value="눈">눈</option>
						</select>
					</div>
					<br>
					<div>
						내용 <br> 
						<textarea rows="7" cols="50" name = "content" class="btn btn-outline-info"></textarea>
					</div>
					<br>
						<button type="submit"  class="btn btn-info">입력</button>	
						<button type="submit" class="btn btn-danger"><a href="/diary/diary.jsp">취소</a></button>	
					</form>
					</div>
					<div class="col"></div>
					</div>
	</div>
</body>
</html>