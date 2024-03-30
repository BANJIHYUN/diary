<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import= "java.net.URLEncoder"%>
<%@ page import = "java.util.Calendar"%>
﻿
<%
	// 로그인
	// diary.login.my_session  => "OFF" -> redirect loginForm.jsp
	String loginMember = (String)(session.getAttribute("loginMember"));
	if(loginMember == null){
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요.", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" +errMsg);
		return;
	}
%>
<%
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	// 달력 page
	// 1. 요청-> 출력하고자는 달력 년과 월값
	String targetYear = request.getParameter("targetYear");
	String targetMonth = request.getParameter("targetMonth");
	Calendar target = Calendar.getInstance();
	
	//디버깅
	System.out.println("targetYear : " + targetYear);
	System.out.println("targetMonth : " + targetMonth);
	
	
	if(targetYear != null && targetMonth != null) {
		target.set(Calendar.YEAR, Integer.parseInt(targetYear));
		target.set(Calendar.MONTH, Integer.parseInt(targetMonth));
		
	}
	// 시작 공백 -> 1일로 변경되게
	target.set(Calendar.DATE, 1);
	int tYear = target.get(Calendar.YEAR);
	int tMonth = target.get(Calendar.MONTH);
	
	int yoNum = target.get(Calendar.DAY_OF_WEEK);	// 일:0, 월: 1....
	
	System.out.println("yoNum :" + yoNum);	// 일 
	// 시작 공백 개수, yoNum이 blank 개수 
	int startBlank = yoNum - 1;
	int lastDate = target.getActualMaximum(Calendar.DATE);	// 마지막 날
	int countDiv = startBlank + lastDate;
	
	
	// tYear 와 tMonth에 해당되는 diary목록을 출력
	String sql2 = "select diary_date, day(diary_date) day, feeling, left(title,5) title from diary where year(diary_date) =? and month(diary_date) =?"; // 다이어리 year, month 데이터값 가져오기
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1, tYear);
	stmt2.setInt(2, tMonth+1);
	System.out.println("stmt2" + stmt2);
	rs2 = stmt2.executeQuery();	
%>
<!DOCTYPE html>
<html> 
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<!-- 구글 폰트 -->
 	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Bagel+Fat+One&family=Playpen+Sans:wght@100..800&display=swap" rel="stylesheet">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/moonspam/NanumSquare@2.0/nanumsquare.css">
	
	<style>
	@import url(https://cdn.jsdelivr.net/gh/moonspam/NanumSquare@2.0/nanumsquare.css);
/* 	  	*{
  			 font-family: 'NanumSquare', sans-serif;
  			 font-weight: 800;
  		} */
  		*{
  		 font-family: "Playpen Sans", cursive;
  		  font-family: "Bagel Fat One", system-ui;
  		}
		/* 달력 */
		.cell {	
			width: 100px; height: 80px;
			float: left;
			background-color: #E0FFDB;
			color: black;
			text-align:right;
			border: 1px solid #3DB7CC;
			border-radius: 5px;
			
		}
		.date {
			float: left;
			background-color: white;
			width:50px; height: 50px;
			border: 1px solid #B2CCFF;
			border-radius: 5px;
			margin: 5px;
		}
		.sun {
			clear: both;
			color : red;
		}
		.sat {
			color: blue;
		}
		.yo {
			float: left;
			width: 90px; height: 20px;
			margin: 5px;
			text-align: center;
		}
		a {
			text-decoration: none;
		}

  		.diary_center {
  			display: inline-block;
			vertical-align: middle;
			color: black;
			margin: 0.5rem;
			padding: 0;
			text-align:center;
  		}
  		.back{
  			background-image: url("/diary/image/main_page.jpg");
  			background-size :100%;
  			background-repeat : no-repeat;
  			background-position: center center;
  		}
  		.btn_head{
  			text-align:right;
  		}
   		nav {
  			display: inline-block;
  			vertical-align: middle;
  			float: right;
		} 
 		ul {
			  list-style: none;
			  margin: 0;
			  padding: 0;
			  display: flex;
			  float: right;
			}  
			
		.q{
			display: flex;
			flex-direction: column;
			height: 150px;
			text-align:center;
		}

			
	</style>
</head>
<body class="back">
	<div class="container">
		<div class="row">
			<div class="col"></div>
	<header class="q">
	<h1 class="diary_center">&#129528;Diary&#129528;</h1>
	<h1><button class="btn btn-warning"><a href="/diary/addDiaryForm.jsp">글쓰기</a></button>
		<button class="btn btn-warning"><a href="/diary/diaryList.jsp">다이어리 리스트</a></button>
		<button class="btn btn-warning"><a href="/diary/statsLunch.jsp">오늘점심뭐먹지?</a></button>
		<button class="btn btn-warning"><a href="/diary/logout.jsp">로그아웃</a></button>
	</h1>
	</header>
	 	

	
	<h1 style="color: black;"  class= "text-center">
		<a href="./diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth-1%>"><<</a>
		<%=tYear%>년 <%=tMonth+1%>월 
		<a href="./diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth+1%>">>></a>
	</h1>
	
	
	<div class="ms-5">
	<div class="ms-5">
	<div class="ms-5">
	<div class="ms-5">
	<div class="ms-5">
	<div class="ms-5">
	
	<!-- 요일 -->
	<div class="sun yo date">S</div>
	<div class="yo date">M</div>
	<div class="yo date">T</div>
	<div class="yo date">W</div>
	<div class="yo date">T</div>
	<div class="yo date">F</div>
	<div class="yo sat date">S</div>
	
	
	

	<!-- Date -->
	<% 
		for(int i=1; i<=countDiv; i=i+1){
			if(i%7 == 1){
	%>
				<div class="cell sun">
	<%
			}else{
	%>
				<div class="cell">
	<%
			}
	%>
	<%
			if(i-startBlank > 0){
	%>
				<%=i-startBlank%><br>
	<%
			// 현재날짜(i-startBlank)의 일기가 rs2 목록에 있는지 비교
			while(rs2.next()){
				// 날짜에 일기 존재
				if(rs2.getInt("day") == (i-startBlank)){
	%>
						<div>
						<span><%=rs2.getString("feeling") %></span>
							<a href='/diary/diaryOne.jsp?diary_date=<%=rs2.getString("diary_date")%>'>
								<%=rs2.getString("title")%>...
							</a>
						</div>
	<%
						break;
					}
				}
				rs2.beforeFirst();
			}else{
	%>
				&nbsp;
	<%
			}
	%>
			</div>
	<%
		}
	%>

	</div>
</div>	
</div>
</div>
</div>
</body>
</html>