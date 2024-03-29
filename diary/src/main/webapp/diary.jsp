<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import= "java.net.URLEncoder"%>
<%@ page import = "java.util.Calendar"%>
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
	<style>
		/* 달력 */
		.cell {	
			width: 180px; height: 60px;
			float: left;
			background-color: #E0FFDB;
			color: black;
			text-align:center;
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
			width: 170px; height: 20px;
			margin: 5px;
			text-align: center;
			font-weight: bold;
		}
		a {
			text-decoration: none;
		}

		.h {
			color: #E4F7BA;
		}
		.q {
			display: flex;
			flex-direction: column;
			height: 200px;
			background: linear-gradient(0.25turn, #3f87a6, #ebf8e1, #f69d3c);
			text-align:center;
		}
		
		.ss {
			text-align:right;
			color : black;
		}
		.dd {
			background-color: black;
			background-size : 200%
		}
		.head {
			text-align:center;
		}
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
		<div class="q">
		<h1>&#129528;Diary&#129528;</h1>
		</div>
	<div>

		<button class="btn btn-warning"><a href="/diary/logout.jsp">로그아웃</a></button>	
		<button class="btn btn-warning"><a href="/diary/addDiaryForm.jsp">글쓰기</a></button>	
		<button class="btn btn-warning"><a href="/diary/diaryList.jsp">다이어리 리스트</a></button>
		<button class="btn btn-warning"><a href="/diary/statsLunch.jsp">오늘점심뭐먹지?</a></button>
		
	</div>
	
	<h1 style="color: #F361DC" class="head">
		<a href="./diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth-1%>">PREV<<</a>
		<%=tYear%>년 <%=tMonth+1%>월 
		<a href="./diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth+1%>">>>NEXT</a>
	</h1>
	
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
</body>
</html>