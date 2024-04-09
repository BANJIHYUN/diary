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

<%
	String sql3 = "select * from diary where diary_date =?";
	PreparedStatement stmt3 = conn.prepareStatement(sql3);
	stmt3.setString(1, diary_date);
	System.out.println(stmt3);
	ResultSet rs3 = null;
	rs3 = stmt3.executeQuery();
	
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
		*{
  		 font-family: "Playpen Sans", cursive;
  		  font-family: "Bagel Fat One", system-ui;
  		}
		body{
			background: linear-gradient(0.25turn, #3f87a6, #ebf8e1, #f69d3c);
		}
		.text {
			border-radius: 10px;
			border-color: skyblue;
		}
  		a {
			text-decoration: none;
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
							<textarea rows="7" cols="50" name = "content" class="text"><%=rs1.getString("content")%></textarea>
						</div><br>
					<%
						}	
					%>
					<a href="/diary/updateDiaryForm.jsp?diary_date=<%=diary_date%>" class="btn btn-info">수정</a>
					<a href="/diary/deleteDiary.jsp?diary_date=<%=diary_date%>" class="btn btn-danger">삭제</a>
					<a href="/diary/diary.jsp" class="btn btn-info">취소</a>
					<div>
					<br>
					<div>댓글입력</div>
						<form method="post" action="/diary/addCommentAction.jsp">
							<input type="hidden" name="diary_date" value="<%=diary_date%>">		
							<textarea rows="5" cols="50" name="memo" class="text"></textarea><br>
							<button type="submit" class="btn btn-info">입력</button>
						</form>
					</div>
					<hr>
					<h2>댓글 리스트</h2><br>
					<!-- 댓글 리스트 -->
					<%
						String sql2 = "select comment_no, diary_date, memo, update_date, create_date from comment where diary_date=?";
						PreparedStatement stmt2 = null;
						ResultSet rs2 = null;		
						stmt2 = conn.prepareStatement(sql2);
						stmt2.setString(1, diary_date);
						rs2 = stmt2.executeQuery();
					%>
					 <div>
						<%
							while(rs2.next()){
								System.out.println(rs2.getString("memo"));
						%>
							<table border="1" class="text">
							<tr>
								<td>내용: <%=rs2.getString("memo")%><td>
							<tr>	
							<tr>		
								<td>작성 날짜(시간): <%=rs2.getString("create_date")%><td>
							</tr>
							</table>
							<br><div class="a btn btn-info"><a href='/diary/deleteComment.jsp?diary_date=<%=diary_date%>&comment_no=<%=rs2.getInt("comment_no")%>'>삭제</a><br></div>
						<hr>
						<%
							}
						%>
					</div>	
				</div>
			<div class="col"></div>
		</div>
	</div>
	
</body>
</html>