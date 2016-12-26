<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String Id = request.getParameter("b");
    Connection conn = null;
        try
        {
            String userName = "root";
            String passwordDB = "1111";
            String url = "jdbc:mysql://localhost:3306/ornitology?zeroDateTimeBehavior=convertToNull";
            Class.forName ("org.gjt.mm.mysql.Driver").newInstance(); // загружаем драйвер
            conn = DriverManager.getConnection (url, userName, passwordDB); // задаём строку подключения
 
            Statement stat = conn.createStatement();
            ResultSet res = stat.executeQuery("SELECT Photo, Name, IntName, Squard, Family, Kind, Count FROM birds WHERE Id='" + Id + "'"); 
            res.next();
            String squard = res.getString(4);
            String fam = res.getString(5);
            String kind = res.getString(6);
            String count = res.getString(7);
            // выполняем запрос
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Птица</title>
<link rel="stylesheet" href="../css/style.css">
<link rel="stylesheet" href="../css/cssResp.css">
<link href="https://fonts.googleapis.com/css?family=Rubik:300,400,500,700&amp;subset=cyrillic" rel="stylesheet">
<script type="text/javascript" src="../js/script.js"></script>
 
</head>

<body>
<div class="wrapper">
	<div class="content">
    	<a href="../jsp/main.jsp"><header>
    		ПТИЦЫ БЕЛАРУСИ
    	</header></a>
    	<main>
    		<section class="bird">
                    <p><%=res.getString(2)%></p>
            	<div class="birdoneimage"><img src="../img/<%=res.getString(1)%>" /></div>
                <div class="information">
                    <p><strong>Международное название: </strong><br><%=res.getString(3)%></p>
                    <%
                        res = stat.executeQuery("SELECT Name FROM squad WHERE Id='" + squard + "'"); 
                        res.next();
                    %>
                    <p><strong>Отряд: </strong><br><%=res.getString(1)%></p>
                    <%
                        res = stat.executeQuery("SELECT Name FROM family WHERE Id='" + fam + "'"); 
                        res.next();
                    %>
                    <p><strong>Семейство: </strong><br><%=res.getString(1)%></p>
                    <%
                        res = stat.executeQuery("SELECT Name FROM kind WHERE Id='" + kind + "'"); 
                        res.next();
                    %>
                    <p><strong>Род: </strong><br><%=res.getString(1)%></p>
                    <p><strong>Регионы обитания: </strong><br>
                    <%
                        res = stat.executeQuery("SELECT regions.Id, regions.Name FROM regions INNER JOIN (birds INNER JOIN bird_region ON birds.Id = bird_region.Id_bird) ON regions.Id = bird_region.Id_region WHERE (((bird_region.Id_bird)=" + Id + "));"); 
                        while(res.next()){
                    %>
                    <a href="../jsp/region.jsp?r=<%=res.getString(1)%>"><%=res.getString(2)%></a><br>
                    <%}%></p>
                </div>
                <div id="but">
                    <button onclick="Watch(<%=Id%>)">Я видел!</button> Видели <%=count%> человек
                </div>
            </section>
            
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