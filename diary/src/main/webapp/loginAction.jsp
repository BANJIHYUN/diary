<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@page import="java.net.*"%>
<%
	// 로그인
	// diary.login.my_session  => "OFF" -> redirect loginForm.jsp
	String loginMember = (String)(session.getAttribute("loginMember"));
	System.out.println("loginMember" + loginMember);
		
	if(loginMember != null){
		response.sendRedirect("/diary/diary.jsp"); 
			return;
	}
%>
<%
	// 요청값 분석 -> 로그인 성공 -> session loginMember 변수 생성.
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");

	System.out.println("memberId: " + memberId);
	System.out.println("memberPw: " + memberPw);
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
		
	String sql2 = "select member_id memberId from member where member_id=? and member_pw=?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, memberId);
	stmt2.setString(2, memberPw);
	rs2 = stmt2.executeQuery();
		
	if(rs2.next()){
		// 로그인 성공
		//response.sendRedirect();
		// diary.login.my_session 
		// mysession값을 On으로 변경
		System.out.println("로그인 성공");
/* 		String sql3 = "update login set my_session = 'on', on_date = NOW() where my_session='off'";
		PreparedStatement stmt3 = conn.prepareStatement(sql3); 
		int row =  stmt3.executeUpdate(); */
		// 로그인 성공 시 session 변경
		session.setAttribute("loginMember", rs2.getString("memberId"));
 		response.sendRedirect("/diary/diary.jsp"); 
			
		}else{
			// 로그인 실패
			System.out.println("로그인 실패");
			String errMsg = URLEncoder.encode("아이디 비밀번호 확인해주세요." ,"utf-8");
			response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		}
	
	
%>
