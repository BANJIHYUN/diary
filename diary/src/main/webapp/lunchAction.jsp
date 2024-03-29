<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import="java.net.*"%>
<%
    /* /* 점심 투표 / */
    String checkDate = request.getParameter("checkDate");
    String menu = request.getParameter("menu");

    System.out.println("**");
    System.out.println("checkDate: " + checkDate);
    System.out.println("menu: " + menu);

    Class.forName("org.mariadb.jdbc.Driver");
    Connection conn = null;
    conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
    String sql1 = "insert into lunch(lunch_date, menu, update_date, create_date) values(?, ?, Now(), NOW())";
    PreparedStatement stmt1 = null;
    stmt1 = conn.prepareStatement(sql1); 

    stmt1.setString(1, checkDate);
    stmt1.setString(2, menu);

    int row = 0;
    row = stmt1.executeUpdate();
    if(row == 1) {
        System.out.println("입력 성공");
    } else{
        System.out.println("입력 실패");
    }

    String sql4 = "select lunch_date, menu from lunch where lunch_date=?";
    PreparedStatement stmt4 =  null;
    stmt4 = conn.prepareStatement(sql4);
    ResultSet rs4 = null;
    stmt4.setString(1, checkDate);
    rs4 = stmt4.executeQuery();

    String lunch_date = "";
    String dbMenu = "";

    if(rs4.next()){
        lunch_date = rs4.getString("lunch_date");
        dbMenu = rs4.getString("menu");

    }

    response.sendRedirect("/diary/lunchOne.jsp?checkDate=" + checkDate+"&lunch_date="+lunch_date+"&menu="+URLEncoder.encode(dbMenu,"utf-8"));

%>