<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String Id = request.getParameter("r");
    Connection conn = null;
        try
        {
            String userName = "root";
            String passwordDB = "1111";
            String url = "jdbc:mysql://localhost:3306/ornitology?zeroDateTimeBehavior=convertToNull";
            Class.forName ("org.gjt.mm.mysql.Driver").newInstance(); // загружаем драйвер
            conn = DriverManager.getConnection (url, userName, passwordDB); // задаём строку подключения
 
            Statement stat = conn.createStatement();
            ResultSet res = stat.executeQuery("SELECT Name FROM regions WHERE Id=" + Id);
            res.next();

%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Птицы Области</title>
<link rel="stylesheet" href="../css/style.css">
<link rel="stylesheet" href="../css/cssResp.css">
<link href="https://fonts.googleapis.com/css?family=Rubik:300,400,500,700&amp;subset=cyrillic" rel="stylesheet">
</head>

<body>
<div class="wrapper">
	<div class="content">
    	<a href="../jsp/main.jsp"><header>
    		ПТИЦЫ БЕЛАРУСИ
    	</header></a>
    	<main>
            <section class="regionallbirds">
                <p><%=res.getString(1)%> область</p>
                <%
                    res = stat.executeQuery("SELECT birds.Name, birds.Photo, birds.Id FROM regions INNER JOIN (birds INNER JOIN bird_region ON birds.Id = bird_region.Id_bird) ON regions.Id = bird_region.Id_region WHERE (((bird_region.Id_region)=" + Id +"));"); 
                    while(res.next()){%>
                    <a href="bird.jsp?b=<%=res.getString(3)%>" class="photo-bird-all">
                	<img src="../img/<%=res.getString(2)%>" alt="<%=res.getString(1)%>" />
                        <p><%=res.getString(1)%></p>
                    </a>
                <%}%>
                
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
