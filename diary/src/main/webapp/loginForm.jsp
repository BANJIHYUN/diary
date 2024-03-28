<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%
	// 로그인
	// diary.login.my_session  => "OFF" -> redirect loginForm.jsp
	// 
	String loginSql1 = "select my_session mySession from login";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt1 = conn.prepareStatement(loginSql1); 
	rs1 = stmt1.executeQuery();
	String mySession = null;
	if(rs1.next()){
		mySession = rs1.getString("mySession");
	}
	if(mySession.equals("on")) {
		response.sendRedirect("/diary/diary.jsp");
		return;	// 코드 끝냄.
	}
	
	// if문에 안 걸릴 때
	
	// 요청값 분석
	String errMsg = request.getParameter("errMsg");
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
	<style>
		body {
			/* background-image: url(/diary/image/login_background.jpg);  */
			background: linear-gradient(0.25turn, #3f87a6, #ebf8e1, #f69d3c);
			background-size: 100% 150%; 
		}

		*{
  		 font-family: "Playpen Sans", cursive;
  		  font-family: "Bagel Fat One", system-ui;
  		}
  		.login_head {
  			text-align:center;
  		}
  		.form {
  			 margin: 0 auto;
  		}
  		.login_btn{
  			text-align:center;
  		}
  		.memberID {
  			text-align: center;
  		}
  		.login_text {
  			background :linear-gradient(0.25turn, #3f87a6, #ebf8e1, #f69d3c);
  			opacity: 0.5;
  		}
  		.pic {
  			border-radius: 15%;
  		}
  		.login_pic{
  			border-radius: 50%;
  			position: relative;
  		}
	</style>
	
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<div class="row">
			<div class="col"></div>
			<div class="mt-5 col-7 bg-white border shadow-sm p-3 mb-5 bg-body-tertiary rounded">

				<%
					if(errMsg != null){
				%>
					<%=errMsg%>
				<% 
					}
				%>			
				<h1 class="login_btn">MEMBER LOGIN</h1>	
				<div class="login_head"><img src="/diary/image/people_login.png" class="login_pic"></div>
						<form method="post" action="/diary/loginAction.jsp" class="col-7 bg-white border shadow-sm p-3 mb-5 bg-body-tertiary rounded form">
							<div><img src="/diary/image/ID.png" class="pic"><input type="text" name="memberId" placeholder="memberID" class="mt-3 col-10 bg-white border shadow-sm p-3 mb-3 bg-body-tertiary rounded login_text"></div>
							<div><img src="/diary/image/pw.png" class="pic"><input type="password" name="memberPw" placeholder="memberPW" class="mt-3 col-10 bg-white border shadow-sm p-3 mb-3 bg-body-tertiary rounded login_text"></div>
							<br>
							<div class="login_btn">
									<button type="submit" class="btn btn-outline-dark">로그인</button>	
							</div>
						</form>
				</div>
			<div class="col"></div>
		</div>
	</div>
</body>
</html>