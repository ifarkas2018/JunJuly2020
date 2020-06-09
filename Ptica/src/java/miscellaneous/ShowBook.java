/*
 * author: Ingrid Farkaš
 * project: Ptica
 * ShowBook.java : invoked from the index_content.jsp when the user clicks on one of the book images 
 */
package miscellaneous;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author user
 */
public class ShowBook extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ShowBook</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ShowBook at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            HttpSession hSession2 = PticaMetodi.returnSession(request);
            
            int i = 0;
            Cookie[] cookies = request.getCookies(); // retrieving the array of cookies
            int c_length = cookies.length;
            boolean found = false; // whether the cookie named book_index was found 

            // going throught the cookies until the cookie named book_index wasn't found
            while ( i < c_length && !found ) {
                Cookie cookie = cookies[i];
                // get the name of the cookie
                String cookie_name = cookie.getName();

                // is the name of the cookie book_index
                boolean is_bk_index = cookie_name.equalsIgnoreCase("book_index");
                if (is_bk_index){
                   String cookie_val = cookie.getValue();
                   // set the session variable book_index to cookie_val
                   hSession2.setAttribute(cookie_name, cookie_val);
                   found = true;
                }
                i++;
            }
            
            response.sendRedirect("home_book.jsp"); // redirects the response to the jsp page
        }
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
