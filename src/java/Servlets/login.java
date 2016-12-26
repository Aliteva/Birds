package Servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class login extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");
        String login = request.getParameter("login");	
        String password = request.getParameter("password");
        
        Connection conn = null;
        try
        {
            String userName = "root";
            String passwordDB = "1111";
            String url = "jdbc:mysql://localhost:3306/ornitology?zeroDateTimeBehavior=convertToNull";
            Class.forName ("org.gjt.mm.mysql.Driver").newInstance(); // загружаем драйвер
            conn = DriverManager.getConnection (url, userName, passwordDB); // задаём строку подключения
 
            Statement stat = conn.createStatement();
            ResultSet res = stat.executeQuery("SELECT * FROM users WHERE Login='" + login + "'AND Password='" + password.hashCode() + "'"); // выполняем запрос
            if (res.next()){  // переходим к очередной строке ответа от сервера, в данном случае - первой
                HttpSession session = request.getSession(true);
                session.setAttribute("user",res.getString("Id"));
                
                if(res.getString("Status").equals("admin"))
                   response.sendRedirect("/Ornitology/jsp/admin.jsp");
                else
                    response.sendRedirect("/Ornitology/jsp/main.jsp");
                    
            }
            else
                response.sendRedirect("/Ornitology/?error");
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
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
