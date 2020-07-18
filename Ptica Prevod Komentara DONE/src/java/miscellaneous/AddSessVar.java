/*
 * autor    : Ingrid Farkaš
 * projekat : Ptica
 * AddSessVar.java : ovaj servlet se koristi za čitanje vrednosti kolačića ( JavaScript ) a zatim se dodaju varijablama sesije
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
            // setToEmptyInput: postavljanje vrednosti varijabli sesije input0, input1, ... na ""
            PticaMetodi.setToEmptyInput(hSession2); 
            
            Cookie[] cookies = request.getCookies(); // niz koji sadrži kolačiće
            for (Cookie cookie:cookies) {
                // ime kolačića
                String cookie_name = cookie.getName();

                // da li je ime kolačića fill_in
                boolean is_fill_in = cookie_name.startsWith("fill_in", 0); 
                boolean is_webpg_name = cookie_name.equalsIgnoreCase("webpg_name");

                String cookie_val = cookie.getValue();
                // ako kolačić sadrži ime veb stranice koja treba da se prikaže postavi varijablu sesije cookie_name ( = webpg_name )
                // na vrednost cookie_val
                if ((is_webpg_name) || (is_fill_in))
                    hSession2.setAttribute(cookie_name, cookie_val);
            }
            String pageName = "";
            if (PticaMetodi.sessVarExists( hSession2, "webpg_name")) {
                pageName = String.valueOf( hSession2.getAttribute("webpg_name") );
            }
            
            response.sendRedirect(pageName); // preusmeravanje na veb stranicu sa imenom pageName 
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
