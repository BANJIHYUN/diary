<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%
	String category = request.getParameter("category");
	String goods_title = request.getParameter("goods_title");
	String goods_price = request.getParameter("goods_price");
	String goods_amount = request.getParameter("goods_amount");
	String goods_content = request.getParameter("goods_content");
	
	System.out.println("category: " + category);
	System.out.println("goodTitle: " + goods_title);
	System.out.println("goods_price: " + goods_price);
	System.out.println("goods_amount" + goods_amount);
	System.out.println("goods_content: " + goods_content);
	
	String sql1 = "insert into goods(category, emp_id, goods_title, goods_price, goods_amount, goods_content, update_date, create_date) values(?, ,?, ?, ?, ?, ?, NOW(), NOW())"; 
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	PreparedStatement stmt1 = null;
	stmt1 = conn.prepareStatement(sql1); 
	
	stmt1.setString(1, category);
	stmt1.setString(2, goods_title);
	stmt1.setString(3, goods_price);
	stmt1.setString(4, goods_amount);
	stmt1.setString(5, goods_content);
	
	int row = 0;
	row = stmt1.executeUpdate();
	if(row == 0){
		System.out.println("입력 성공");
	}else{
		System.out.println("입력 실패");
	}
	response.sendRedirect("/shop/emp/goodsList.jsp");
%>
