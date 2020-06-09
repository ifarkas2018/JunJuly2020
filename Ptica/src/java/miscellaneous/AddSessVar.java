/*
 * author: Ingrid Farkaš
 * project: Ptica
 * AddSessVar.java : this servlet is called to read the values in cookies (JavaScript) and to add them as session var.
 */
package miscellaneous;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AddSessVar", urlPatterns = {"/AddSessVar"})
public class AddSessVar extends HttpServlet {

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
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Ptica</title>");            
            out.println("</head>");
            out.println("<body>");
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
            // setToEmptyInput: set the session variable values to "" for the variables named input0, input1, ...
            PticaMetodi.setToEmptyInput(hSession2); 
            
            Cookie[] cookies = request.getCookies(); // retrieving the array of cookies
            // going throught the cookies
            for (Cookie cookie:cookies) {
                // get the name of the cookie
                String cookie_name = cookie.getName();

                // is the name of the cookie fill_in
                boolean is_fill_in = cookie_name.startsWith("fill_in", 0); 
                boolean is_webpg_name = cookie_name.equalsIgnoreCase("webpg_name");

                String cookie_val = cookie.getValue();
                // if the cookie contains the name of the web page to be shown set the session variable cookie_name (= webpg_name)
                // to the cookie_val
                if ((is_webpg_name) || (is_fill_in))
                    hSession2.setAttribute(cookie_name, cookie_val);
            }
            String pageName = "";
            if (PticaMetodi.sessVarExists( hSession2, "webpg_name")) {
                pageName = String.valueOf( hSession2.getAttribute("webpg_name") );
            }
            
            response.sendRedirect(pageName); // redirects the response to the jsp page
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
