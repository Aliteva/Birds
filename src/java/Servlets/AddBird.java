package Servlets;

import java.io.DataInputStream;
/*import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import ru.java.dbservice.DbServise;*/
 
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import javax.servlet.ServletException;
import java.io.IOException;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;
import java.util.Iterator;
import  java.util.Collection;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
@WebServlet(name = "AddBird", urlPatterns = {"/AddBird"})
@MultipartConfig
public class AddBird extends HttpServlet {

    private final static Logger LOGGER = Logger.getLogger(AddBird.class.getCanonicalName());
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
       response.setContentType("text/html;charset=UTF-8");
       request.setCharacterEncoding("UTF-8");
    
    final String path = "D:\\учёба\\4 курс\\курсач\\java\\Ornitology\\web\\img";
    final String name = request.getParameter("name");
    final String intname = request.getParameter("intname");
    final String otr = request.getParameter("otr");
    final String fam = request.getParameter("fam");
    final String kind = request.getParameter("kind");
    final String[] reg = request.getParameterValues("a"); 
    
    final Part filePart = request.getPart("user_pic");
    Date now = new Date();
    Long dnow = now.getTime();
    final String fileName = dnow + getFileName(filePart);
   
    OutputStream out = null;
    InputStream filecontent = null;
    final PrintWriter writer = response.getWriter();

    try {
        out = new FileOutputStream(new File(path + File.separator  + fileName));
        filecontent = filePart.getInputStream();

        int read = 0;
        final byte[] bytes = new byte[1024];

        while ((read = filecontent.read(bytes)) != -1) {
            out.write(bytes, 0, read);
        }
        Connection conn = null;
        try
        {
            String userName = "root";
            String passwordDB = "1111";
            String url = "jdbc:mysql://localhost:3306/ornitology?zeroDateTimeBehavior=convertToNull";
            Class.forName ("org.gjt.mm.mysql.Driver").newInstance(); // загружаем драйвер
            conn = DriverManager.getConnection (url, userName, passwordDB); // задаём строку подключения
 
            Statement stat = conn.createStatement();
            stat.executeUpdate("INSERT INTO `ornitology`.`birds` (`Name`, `IntName`, `Photo`, `Squard`, `Family`, `Kind`, `Count`) VALUES ('" + name + "', '" + intname + "', '" + fileName + "', '" + otr + "', '" + fam + "', '" + kind + "', 0)");
            
            ResultSet res = stat.executeQuery("SELECT Id FROM birds WHERE Photo='" + fileName +"'"); // выполняем запрос
            if (res.next()){  // переходим к очередной строке ответа от сервера, в данном случае - первой
                String id = res.getString(1);
                System.out.println(id);
                for(int i=0; i<reg.length;++i){
                    System.out.println(reg[i]);
                    stat.executeUpdate("INSERT INTO `bird_region` (`Id_bird`, `Id_region`) VALUES ('" + id + "', '" + reg[i] + "')");
                System.out.println(reg[i]);
                }
                    
                response.sendRedirect("/Ornitology/html/successAdd.html");
            }
        }
        catch (Exception e)
        {
            response.sendRedirect("/Ornitology/html/errorAdd.html");
        }
        finally
        {
            if (conn != null)
            {
                try
                    {
                        conn.close ();
                    }
                catch (Exception e) {e.printStackTrace();}
            }
        }
        LOGGER.log(Level.INFO, "File{0}being uploaded to {1}", new Object[]{fileName, path});
        
        
    } catch (FileNotFoundException fne) {
        //response.sendRedirect("/Ornitology/html/errorAdd.html");
        LOGGER.log(Level.SEVERE, "Problems during file upload. Error: {0}", 
                new Object[]{fne.getMessage()});
    } finally {
        if (out != null) {
            out.close();
        }
        if (filecontent != null) {
            filecontent.close();
        }
        if (writer != null) {
            writer.close();
        }
    }
}     
       
private String getFileName(final Part part) {
    final String partHeader = part.getHeader("content-disposition");
    LOGGER.log(Level.INFO, "Part Header = {0}", partHeader);
    for (String content : part.getHeader("content-disposition").split(";")) {
        if (content.trim().startsWith("filename")) {
            return content.substring(
                    content.indexOf('=') + 1).trim().replace("\"", "");
        }
    }
    return null;
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
    }
// </editor-fold>

}