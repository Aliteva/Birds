<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Connection conn = null;
        try
        {
            String userName = "root";
            String passwordDB = "1111";
            String url = "jdbc:mysql://localhost:3306/ornitology?zeroDateTimeBehavior=convertToNull";
            Class.forName ("org.gjt.mm.mysql.Driver").newInstance(); // загружаем драйвер
            conn = DriverManager.getConnection (url, userName, passwordDB); // задаём строку подключения
 
            Statement stat = conn.createStatement();
            // выполняем запрос
%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Птицы Беларуси</title>
<link rel="stylesheet" href="../css/style.css">
<link rel="stylesheet" href="../css/cssResp.css">
<link href="https://fonts.googleapis.com/css?family=Rubik:300,400,500,700&amp;subset=cyrillic" rel="stylesheet">
</head>

<body>
<div class="wrapper">
	<div class="content">
    	<a href="#"><header>
    		ПТИЦЫ БЕЛАРУСИ
    	</header></a>
    	<main>
            
            <% 
                ResultSet rescount = stat.executeQuery("SELECT COUNT(*) Name FROM regions"); 
                rescount.next();
                String[] namesofreg = new String[rescount.getInt(1)];
                ResultSet res = stat.executeQuery("SELECT Name FROM regions"); 
                for(int i=0;i<namesofreg.length;++i){
                    res.next();
                    namesofreg[i] = res.getString(1);
                }
            for(int i=0;i<6;++i){
            
            %>
                    
            	<section class="region">
               	<a href="../jsp/region.jsp?r=<%=i+1%>"><p><%=namesofreg[i]%></p></a>
                <%
                    ResultSet res1 = stat.executeQuery("SELECT birds.Name, birds.Photo, birds.Id FROM regions INNER JOIN (birds INNER JOIN bird_region ON birds.Id = bird_region.Id_bird) ON regions.Id = bird_region.Id_region WHERE (((bird_region.Id_region)=" + (i+1) +"));"); 
                    for(int j=0;j<4;++j){
                     if(res1.next()){%>
                    
                    <a href="../jsp/bird.jsp?b=<%=res1.getString(3)%>" class="photo-bird">
                	<img src="../img/<%=res1.getString(2)%>" alt="<%=res1.getString(1)%>" />
                    <p><%=res1.getString(1)%></p>
                    </a>
                <%}}%>
                </section>
            <%}%>    
        	
        </main>
    </div>
    <footer>
    	&copy; Алина Тоестева, 2016
    </footer>	
</div>
</body>
</html>
<%
            }
        catch (Exception e)
        {
            System.err.println (e.getMessage());
        }
        finally
        {
            if (conn != null)
            {
                try
                    {
                        conn.close ();
                    }
                catch (Exception e) {e.printStackTrace(); }
            }
        }
%>