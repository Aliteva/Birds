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
<title>Птица</title>
<script type="text/javascript" src="../js/script.js"></script>

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
            	<p class="admin-title"><a href="../jsp/admin.jsp">Администрирование</a></p>
                	<p class="block-title">Добавить птицу</p>
                <form id="addphoto" name="add-form" action="../AddBird" method="POST" enctype="multipart/form-data">
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
                        <div id="dowload"></div>
                    </section>
                
                
                    <div  id="dow" >
                        <p class="lable">Название:</p>
                        <p>
                        <input value="" type="text" name="name" size="40"></p>
                        <p class="lable">Международне название:</p>
                        <p><input value="" type="text" name="intname" size="40"></p>
                        <p class="lable">Отряд:</p>
                        <P>
                            <SELECT name="otr" onchange="ChangeOtr(this.value)">
                                <% 
                                    ResultSet res = stat.executeQuery("SELECT Id, Name FROM squad"); 
                                    //ResultSet Idres = stat.executeQuery("SELECT Id FROM squad"); 
                                    while (res.next()){
                                        
                                %>  
                                <OPTION value="<%= res.getString(1) %>"><%= res.getString(2) %></OPTION> 
                                <% }                               
                                %>
    				
                            </SELECT>
                        </p>
                        <p class="lable" >Семейство:</p>
                        <P>
                            <SELECT name="fam" onchange="ChangeFam(this.value)">
                                <% 
                                    res = stat.executeQuery("SELECT Id, Name FROM family WHERE Squard=1"); 
                                   while (res.next()){
                                        
                                %>  
                                <OPTION value="<%= res.getString(1) %>"><%= res.getString(2) %></OPTION> 
                                <% }                               
                                %>
    			</SELECT>
                        </p>
                        <p class="lable">Род:</p>
                        <P>
                            <SELECT name="kind">
                                <% 
                                    res = stat.executeQuery("SELECT Id, Name FROM kind WHERE Family=2"); 
                                   while (res.next()){
                                        
                                %>  
                                <OPTION value="<%= res.getString(1) %>"><%= res.getString(2) %></OPTION> 
                                <% }                               
                                %>
                            </SELECT>
                        </p>
                        <p class="lable">Регионы обитания:</p>
                        <p><input type="checkbox" name="a" value="1" id="brest"><label for="brest" class="check-lable">Брестская область</label></p>
                        <p><input type="checkbox" name="a" value="2" id="vitebsk"><label for="vitebsk" class="check-lable">Витебская область</label></p>
                        <p><input type="checkbox" name="a" value="3" id="gomel"><label for="gomel" class="check-lable">Гомельская область</label></p>
                        <p><input type="checkbox" name="a" value="4" id="grodno"><label for="grodno" class="check-lable">Гродненская область</label></p>
                        <p><input type="checkbox" name="a" value="5" id="minsk"><label for="minsk" class="check-lable">Минская область</label></p>
                        <p><input type="checkbox" name="a" value="6" id="mogilev"><label for="mogilev" class="check-lable">Могилевская область</label></p>
                      
                    </div>
                    <div id="errors" style="margin-top: 25px;"></div>
                
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