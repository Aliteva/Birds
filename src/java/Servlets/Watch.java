package Servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
/**
 *
 * @author Алина
 */
public class Watch extends HttpServlet {

  
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
       
        String ans = "";
        String IdBird = request.getParameter("bird");
        HttpSession session = request.getSession(true);
        //System.out.println(session.getAttribute("user"));
                
        Connection conn = null;
        try
        {
            String userName = "root";
            String passwordDB = "1111";
            String url = "jdbc:mysql://localhost:3306/ornitology?zeroDateTimeBehavior=convertToNull";
            Class.forName ("org.gjt.mm.mysql.Driver").newInstance(); // загружаем драйвер
            conn = DriverManager.getConnection (url, userName, passwordDB); // задаём строку подключения
 
            Statement stat = conn.createStatement();
            ResultSet res = stat.executeQuery("SELECT IdUser, IdBird FROM watch WHERE IdBird='" + IdBird +"' AND IdUser='" + session.getAttribute("user") + "'"); // выполняем запрос
            if (res.next()){  // переходим к очередной строке ответа от сервера, в данном случае - первой
            //    response.sendRedirect("/Ornitology/html/registration.html?error");
                res = stat.executeQuery("SELECT Count FROM birds WHERE Id=" + IdBird);
                res.next();
                ans =  res.getString(1);
            }
            else{
                stat.executeUpdate("INSERT INTO `watch` (`IdUser`, `IdBird`) VALUES ('" + session.getAttribute("user") + "', '" + IdBird + "')");
                res = stat.executeQuery("SELECT COUNT(*) FROM `watch` WHERE IdBird=" + IdBird);
                res.next();
                String c = res.getString(1);
                stat.executeUpdate("UPDATE birds SET Count='" + c + "' WHERE Id='" + IdBird + "'");
           
                ans =  c;
            }
            response.setContentType("text/html;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println(ans);
            }
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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
