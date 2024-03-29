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
<%
	String sql2 = "select menu, count(*)cnt from lunch group by menu";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	rs2 = stmt2.executeQuery();
	
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
		msg = "점심 투표를 이미 진행했습니다.";
	}
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
		*{
  		 font-family: "Playpen Sans", cursive;
  		 font-family: "Bagel Fat One", system-ui;
  		}
  		.a {
  			background: linear-gradient(0.25turn, #3f87a6, #ebf8e1, #f69d3c);
  			
  		}
  		.center {
  			 text-align: center;
  		}
  		.table_center {
  			margin:auto; 
  		}
	</style>
</head>
<body class="a">
<div class="container">
		<div class="row">
				<div class="col"></div>
				<div class="mt-5 col-7 bg-success-white border shadow-sm p-3 mb-5 bg-body-tertiary rounded">
				<h1 class="center">&#129528;투표&#129528;</h1>
					<form method="post" action="/diary/lunchDate_checkDateAction.jsp">
						<div class="center">
							날짜확인: <input type="date" name="checkDate" value ="<%=checkDate%>" class="btn btn-outline-warning">
							<span><%=msg%></span>
						</div>
					<br>
						<div class="center"><button type="submit" class="btn btn-outline-warning">가능한 날짜인지 확인</button> &nbsp; <%-- checkDate : <%=checkDate%> / ck : <%=ck%>	&nbsp; --%>
						<% 
							if(ck.equals("T")){
							msg = "입력이 가능한 날짜입니다.";
						%>
							<a href="/diary/lunchOne.jsp?checkDate=<%=checkDate%>" class="btn btn-danger center">투표하러가기</a>
						<%
							}
						%>
						</div>	
					</form>
					<hr>
				<h1 class="center">&#129528;통계&#129528;</h1>
			<%
				double maxHeight = 500;
				double totalCnt = 0;
				while(rs2.next()){
					totalCnt = totalCnt + rs2.getInt("cnt");
				}
				rs2.beforeFirst();
			%>
			<div class="center">
				전체 투표수: <%=(int)totalCnt%>
			</div>
			<table style="width: 400px;" class="center table_center">
				<tr>
				
				<%
				String[] c = {"#FF0000", "#FF5E00", "#FFE400", "#1DDB16", "#0054FF","#FF0000", "#FF5E00", "#FFE400", "#1DDB16", "#0054FF"};	
				int i = 0;
				while(rs2.next()){
					int h = (int)(maxHeight * (rs2.getInt("cnt")/totalCnt));
			%>
				<td style="vertical-align: bottom;">
					<div style="height:<%=h%>px; 
								background-color: <%=c[i]%>; 
								text-align: center">	
							<%=rs2.getInt("cnt")%>
					</div>
				</td>
			<%
				i = i +1;
				}
			%>
		</tr>
		<tr>
			<%
				rs2.beforeFirst();
			
				while(rs2.next()){
			%>
				<td><%=rs2.getString("menu")%></td>
			<%
				}
			%>
		</tr>
	</table>
	</div>
		<div class="col"></div>
	</div>
	</div>
</body>
</html>