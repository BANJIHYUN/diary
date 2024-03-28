<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%
	// 입력값
	String diary_date = request.getParameter("diary_date");

	//디버깅
	System.out.println("diary_date" + diary_date);
	
	//
	String sql = "select diary_date, title, weather, content from diary where diary_date=?";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt1 = conn.prepareStatement(sql);
	ResultSet rs1 = null;
	stmt1.setString(1, diary_date);
	rs1 = stmt1.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>&#129528;diary 상세보기</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- 구글 폰트 -->
 	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Bagel+Fat+One&family=Playpen+Sans:wght@100..800&display=swap" rel="stylesheet">
	<style>
		*{ font-family: "Playpen Sans", cursive;
  		   font-family: "Bagel Fat One", system-ui;
  		}
		body{
			background: linear-gradient(0.25turn, #3f87a6, #ebf8e1, #f69d3c);
		}
  		
	</style>
</head>
<body>
	<div class="container">
		<div class="row">
			<div class="col"></div>
				<div class="mt-5 col-7 bg-success-white border shadow-sm p-3 mb-5 bg-body-tertiary rounded">
					<!-- 다이어리 상세내용 -->
					<h1>&#129528;상세내용&#129528;</h1>
					<%
						if(rs1.next()){
					%>	
						<div>diary_date:&nbsp; 
						<%=rs1.getString("diary_date")%>
						</div><br>
						<div>title:&nbsp; <%=rs1.getString("title")%></div><br>
						<div>weather:&nbsp; <%=rs1.getString("weather")%></div><br>
						<div>content<br> 
							<textarea rows="7" cols="50" name = "content" class="btn btn-outline-info"><%=rs1.getString("content")%></textarea>
						</div><br>
					<%
						}	
					%>
					<a href="/diary/updateDiaryForm.jsp?diary_date=<%=diary_date%>" class="btn btn-info">수정</a>
					<a href="/diary/deleteDiary.jsp?diary_date=<%=diary_date%>" class="btn btn-danger">삭제</a>
					<a href="/diary/diary.jsp" class="btn btn-info">취소</a>
				</div>
			<div class="col"></div>
			<div>
			</div>
		</div>
	</div>
	
</body>
</html>