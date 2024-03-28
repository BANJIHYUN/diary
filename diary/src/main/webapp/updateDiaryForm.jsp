<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	String diary_date = request.getParameter("diary_date");
	System.out.println("diary_date" + diary_date);
	
	String sql = "select diary_date, title, weather, content, update_date, create_date from diary where diary_date = ?";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, diary_date);
	rs = stmt.executeQuery();
	
	String weather = null;
	
	if(rs.next()){
		
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
<body class="bg-success-subtle">
<div class="a">
	<div class="row">
	<div class="col"></div>
		<div class="mt-5 col-7 bg-success-white border shadow-sm p-3 mb-5 bg-body-tertiary rounded">
				<h1>&#129528;TOday's Diary 수정&#129528;</h1>
				
				<form method="post" action="/diary/updateDiaryAction.jsp">
					
					<div>
						날짜 &nbsp;
						<input type="text" class="btn btn-outline-warning" name="diary_date" value='<%=rs.getString("diary_date")%>' readonly="readonly">
					</div>
					<br>
					<div >
						제목 &nbsp;<input type="text" class="btn btn-outline-info" name="title" value='<%=rs.getString("title")%>'>
					</div>
					<br>
					<div>
						날씨 &nbsp;
						<select name="weather">
					<%
						if(rs.getString("weather").equals("맑음")){
					%>
							<option value="맑음" selected>맑음</option>
							<option value="흐림">흐림</option>
							<option value="비">비</option>
							<option value="눈">눈</option>
					<% 
						}else if(rs.getString("weather").equals("흐림")){
					%>
							<option value="맑음">맑음</option>
							<option value="흐림" selected>흐림</option>
							<option value="비">비</option>
							<option value="눈">눈</option>
					<% 
						}else if(rs.getString("weather").equals("비")){
					%>
							<option value="맑음">맑음</option>
							<option value="흐림">흐림</option>
							<option value="비" selected>비</option>
							<option value="눈">눈</option>
					<% 	
						}else{
					%>
							<option value="맑음">맑음</option>
							<option value="흐림">흐림</option>
							<option value="비">비</option>
							<option value="눈" selected>눈</option>
					<% 	
						}
					
					
					%>
				</select>
					<br>
					<div>
						내용 <br> 
						<textarea rows="5" cols="50" name="content" class="btn btn-outline-info"><%=rs.getString("content")%></textarea>
					</div>
					<br>
						<button type="submit" class="btn btn-outline-info">수정하기</button>	
						<button type="submit" class="btn btn-outline-info"><a href="/diary/diary.jsp">취소</a></button>	
					</form>
					</div>
					<div class="col"></div>
					</div>
				</form>
			</div>
	</body>
</html>

<% 
	}
%>
