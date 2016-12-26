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
%>
        
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Администрирование</title>
<link rel="stylesheet" href="../css/style.css">
<link rel="stylesheet" href="../css/cssResp.css">
<link href="https://fonts.googleapis.com/css?family=Rubik:300,400,500,700&amp;subset=cyrillic" rel="stylesheet">
<script type="text/javascript" src="../js/script.js"></script>
</head>

<body>
<div class="wrapper">
    <div class="content">
    	<a href="#"><header>
    		ПТИЦЫ БЕЛАРУСИ
    	</header></a>
    	<main>
            
            <section class="administration">
            	<p class="admin-title">Администрирование</p>
                
                <div class="editBird">
                <p class="block-title">Редактировать информацию</p>
                <p class="search">Найти: <input type="search" onkeyup="KeyPress(this.value)"></p>
                <form name="admin-form" action="../Delete" method="GET">
                <div class="view">
                <% 
                    ResultSet res = stat.executeQuery("SELECT Name, Photo, Id FROM birds"); 
                    while (res.next()){
                %>  
                    <div class="photo-bird-all" onClick="Select(this)">
                        <input type='text' class='box' name='b' value="" alt="<%= res.getString(3)%>">
                      <img src=<%="../img/" + res.getString(2)%> alt="<%= res.getString(1)%>" />
                      <p><%= res.getString(1)%></p>
                      </div>
                <% }                               
                %>  
                          
                 
                
                </div>
                </form>
            	
               <button id="redaction" onClick="CheckSelectedRedaction()">Редактировать</button>
               <button id="delete" onClick="CheckSelectedDelete()">Удалить</button>
               <button onClick="window.location.href = '../jsp/addBird.jsp'">Добавить</button>
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