<%-- 
    Document   : prediction_output
    Created on : 06-Mar-2021, 13:27:55
    Author     : Dinma okonicha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Types"%>
<%@page import="com.mysql.jdbc.PreparedStatement"%>
<%@page import="com.mysql.jdbc.Connection"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        
        <div style="  background: #ffff00; padding: 60px; position: relative; top: 270px; width: 60%; margin: 0 auto" >
            <h1 style="text-align: center">Is it competitive: 
                <% try {
            String id = session.getAttribute("ID").toString();
            Connection conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost:3306/auction", "root", "");
            PreparedStatement ps = (PreparedStatement) conn.prepareStatement("SELECT Competitive FROM auction_table WHERE ID = ?");
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            rs.first();
            Boolean value = rs.getBoolean("Competitive");
            out.print(value);  
        } catch (Exception e) {
            e.printStackTrace();
        }
        %>  
            </h1>
        
        
        <h2 style="text-align: center">ID: 
            <% try {
            String id = session.getAttribute("ID").toString();
            Connection conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost:3306/auction", "root", "");
            PreparedStatement ps = (PreparedStatement) conn.prepareStatement("SELECT Competitive FROM auction_table WHERE ID = ?");
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            rs.first();
            Boolean value = rs.getBoolean("Competitive");
            out.print(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        %></h2>
        </div>
        
        
    </body>
</html>
