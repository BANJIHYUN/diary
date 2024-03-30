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
	//
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
	String sql4 = "select diary_date, title from diary where title like ? order by diary_date desc limit ?, ?";
	PreparedStatement stmt4 = null;
	ResultSet rs4 = null;
	stmt4 = conn.prepareStatement(sql4);
	stmt4.setString(1, "%" + searchWord + "%");
	stmt4.setInt(2, startRow);
	stmt4.setInt(3, rowPerPage);
	rs4 = stmt4.executeQuery();
	
	//select count(*) from board 전체 행의 수
	String sql1 = "Select count(*) from diary";
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	
	int totalRow = 0;
	if(rs1.next()){
		totalRow = rs1.getInt("count(*)");
	}
	// 디버깅
	System.out.println("totalRow " + totalRow);
		
	int lastPage = totalRow / rowPerPage;
	if(totalRow%rowPerPage != 0){	// 나머지가 0이 아니면 +1 해줘야 함. '실수'로 바꿔서 올림해버리면 똑같은 결과값이 나옴.
		lastPage = lastPage + 1;
	}
	// 디버깅
	System.out.println("lastPage " + lastPage);
		
	// 데이터(모델)
	String sql3 = "SELECT diary_date, title, content FROM diary ORDER BY diary_date DESC LIMIT ?, ?";
	PreparedStatement stmt3 = null;
	ResultSet rs3 = null;
		
	stmt2 = conn.prepareStatement(sql3);
	stmt2.setInt(1, (currentPage-1)*rowPerPage);
	stmt2.setInt(2, rowPerPage);
	rs2= stmt2.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- 구글 폰트 -->
 	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Bagel+Fat+One&family=Playpen+Sans:wght@100..800&display=swap" rel="stylesheet">
	<style>
		.background {
			background: linear-gradient(0.25turn, #3f87a6, #ebf8e1, #f69d3c);
		}
		*{
  		 font-family: "Playpen Sans", cursive;
  		  font-family: "Bagel Fat One", system-ui;
  		}
	</style>

</head>
<body class="background">
	<div class="container">
		<div class="row">
			<div class="col"></div>
			<div class="mt-5 col-7 bg-white border shadow-sm p-3 mb-5 bg-body-tertiary rounded">
				<h1 class="h">&#129528;DiaryList&#129528;</h1>
				<table class="table table-hover">
					<thead>
						<tr>
							<th>diary_date</th>
							<th>title</th>
						</tr>
					</thead>
		 				<%
							while(rs4.next()){
						%>
						<tr>
								<td><%=rs4.getString("diary_date")%></td>
								<td><%=rs4.getString("title") %></td>
						</tr>
						<%
							}
						%> 
					
					<form method="post" action="">
						<div>
							제목 검색:
							<input type="text" name="searchWord">
							<button type="submit" class="btn btn-info">검색</button>
						</div>
					</form>
					</table>
	

				
				<div class="write">
					<span>
						<%=currentPage%>페이지
					</span>
				</div>
				
				<table class="table table-hover">
					<thead>
						<tr>
							<th>diary_date</th>
							<th>title</th>
						</tr>
					</thead>
					<tbody>
						<%
							while(rs2.next()){
						%>
							<tr>
								<td><%=rs2.getString("diary_date")%></td>
								<td><a href="./diaryOne.jsp?diary_date=<%=rs2.getString("diary_date")%>"><%=rs2.getString("title")%></a></td>
							</tr>
						<%
							}
						%>
					</tbody>
				</table>
					<!-- 페이징 --> <!-- 페이지 버튼 -->
             	<nav aria-label="Page navigation example">
         			<ul class="pagination justify-content-center">		
         				
					<%
						if(currentPage > 1) {
					%>
						<li class="page-item">
							<a class = "page-link" href="./diaryList.jsp?currentPage=1">처음페이지</a>
						</li>
						<li class="page-item">
							<a class = "page-link" href="./diaryList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
						</li>
					<% 		
						} else{
					%>
						<li class="page-item disabled">
							<a class = "page-link" href="./diaryList.jsp?currentPage=1">처음페이지</a>
						</li>
						<li class="page-item disabled">
							<a class ="page-link" href="./diaryList.jsp?currentPage=<%=currentPage-1%>">이전페이지</a>
						</li>
					<%
						}
						if(currentPage < lastPage){
					%>	
							<li class="page-item">
								<a class = "page-link" href="./diaryList.jsp?currentPage=<%=currentPage+1%>">다음페이지</a>
							</li>
							<li class="page-item">
								<a class = "page-link" href="./diaryList.jsp?currentPage=<%=lastPage%>">마지막페이지</a>
							</li>
					<%
						}
					%>
					</ul>
					</nav>
							
					<div class="d-grid">
						<a href= "./addDiaryForm.jsp" class="btn btn-info">글쓰기</a>
					</div>
					</div>
				<div class="col"></div>
			</div>
		</div>
</body>
</html>