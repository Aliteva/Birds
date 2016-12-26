<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String Id = request.getParameter("id");
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
<title>Птица</title>
<script type="text/javascript" src="../js/script.js"></script>

<link rel="stylesheet" href="../css/style.css">
<link rel="stylesheet" href="../css/cssResp.css">
<link href="https://fonts.googleapis.com/css?family=Rubik:300,400,500,700&amp;subset=cyrillic" rel="stylesheet">
</head>

<body onload="Fill()">

<div class="wrapper">
	<div class="content">
    	<a href="#"><header>
    		ПТИЦЫ БЕЛАРУСИ
    	</header></a>
    	<main>
    		<section class="administration">
            	<p class="admin-title"><a href="../jsp/admin.jsp">Администрирование</a></p>
                	<p class="block-title">Добавить птицу</p>
                	<form id="addphoto" name = "add-form" action="../Redact" method="POST" enctype="multipart/form-data">
                     <input name="IdBird" type="hidden" value="<%=Id%>">
                            <section id="uploadphoto">
                        <div>
                            <p><input type="hidden" name="MAX_FILE_SIZE" value="4000000"/></p>
                            <p>
                                <label class="file_upload">
                                    Загрузить фотографию<br><span>нажмите для выбора</span>
                                    <input type="file" name="user_pic" onChange="AddPhoto();">
                                </label>
                            </p>
                        </div>
                        <% 
                            ResultSet res = stat.executeQuery("SELECT Photo, Name, IntName, Squard, Family, Kind FROM birds WHERE Id='" + Id + "'"); 
                            res.next();                                        
                        %>  
                                 <img id="dowload" src=<%="../img/" + res.getString(1)%> >
                                              
                       
                    </section>
                    <div  id="dow" >
                        <p class="lable">Название:</p>
                        <p>
                        <input type="text" name="name" size="40" value="<%= res.getString(2)%>"></p>
                        <p class="lable">Международное название</p>
                        <p><input type="text" name="intname" size="40"  value="<%= res.getString(3)%>"></p>
                        <p class="lable">Отряд</p>
                        <P>
                            <SELECT name="otr" onchange="ChangeOtr(this.value)" title="<%= res.getString(4)%>" >
                                <% 
                                    ResultSet resdop = stat.executeQuery("SELECT Id, Name FROM squad"); 
                                    while (resdop.next()){
                                        
                                %>  
                                <OPTION value="<%= resdop.getString(1) %>"><%= resdop.getString(2) %></OPTION> 
                                <% }  
                                res = stat.executeQuery("SELECT Photo, Name, IntName, Squard, Family, Kind FROM birds WHERE Id='" + Id + "'"); 
                                    res.next();    
                                %>
    				
                            </SELECT>
                        </p>
                        <p class="lable">Семейство:</p>
                        <P>
                            <SELECT name="fam" onchange="ChangeFam(this.value)" title="<%= res.getString(5)%>">
                                <% 
                                   
                                    resdop = stat.executeQuery("SELECT Id, Name FROM family WHERE Squard='" + res.getString(4) + "'"); 
                                   while (resdop.next()){
                                        
                                %>  
                                <OPTION value="<%= resdop.getString(1) %>"><%= resdop.getString(2) %></OPTION> 
                                <% }
                                 res = stat.executeQuery("SELECT Photo, Name, IntName, Squard, Family, Kind FROM birds WHERE Id='" + Id + "'"); 
                                    res.next();
                                %>
                            </SELECT>
                        </p>
                        <p class="lable">Род:</p>
                        <P>
                            <SELECT name="kind" title="<%= res.getString(6)%>">
                                <% 
                                    
                                    resdop = stat.executeQuery("SELECT Id, Name FROM kind WHERE Family='" + res.getString(5) +"'"); 
                                   while (resdop.next()){
                                        
                                %>  
                                <OPTION value="<%= resdop.getString(1) %>"><%= resdop.getString(2) %></OPTION> 
                                <% }                               
                                %>
                            </SELECT>
                        </p>
                        <p class="lable">Регионы обитания:</p>
                        <% 
                            resdop = stat.executeQuery("SELECT Id_region FROM bird_region WHERE Id_bird='" + Id +"'"); 
                            while (resdop.next()){
                        %>  
                        <input type="hidden" name="hidreg" value="<%= resdop.getString(1) %>">
                        <%}%>
                        <p><input type="checkbox" name="a" value="1" id="brest"><label for="brest" class="check-lable">Брестская область</label></p>
                        <p><input type="checkbox" name="a" value="2" id="vitebsk"><label for="vitebsk" class="check-lable">Витебская область</label></p>
                        <p><input type="checkbox" name="a" value="3" id="gomel"><label for="gomel" class="check-lable">Гомельская область</label></p>
                        <p><input type="checkbox" name="a" value="4" id="grodno"><label for="grodno" class="check-lable">Гродненская область</label></p>
                        <p><input type="checkbox" name="a" value="5" id="minsk"><label for="minsk" class="check-lable">Минская область</label></p>
                        <p><input type="checkbox" name="a" value="6" id="mogilev"><label for="mogilev" class="check-lable">Могилевская область</label></p>
                      
                    </div>
                    
                </form>
                <button class="saveNew" onclick="CheckAdd();">Сохранить</button>
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