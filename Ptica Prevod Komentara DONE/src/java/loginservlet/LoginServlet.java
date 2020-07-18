/*
 * autor   : Ingrid Farkaš
 * projekat: Ptica
 * LoginServlet.java : kada korisnik klikne na dugme Prijava ( login_form.jsp ) tada se poziva ovaj servlet
 */
package loginservlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import miscellaneous.PticaMetodi;

public class LoginServlet extends HttpServlet {

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
            out.println("<title>Ptica - Login</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
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
    
    // kada korisnik klikne na dugme Prijava ( login_form.jsp ) tada se poziva ovaj metod
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            
            // pročitaj korisničko ime ( login_form.jsp )
            String userName = request.getParameter("username"); 
            // pročitaj lozinku ( login_form.jsp )
            String password = request.getParameter("passw");
            
            // addBacksl : poziva metod koji zamenjuje svaku pojavu \ sa \\\\ i zamenjuje svaku pojavu ' sa \\'
            userName = PticaMetodi.addBacksl(userName);
            password = PticaMetodi.addBacksl(password);
            
            // metod login vraća admin - za administratora, emp - za zaposlenog koji nije admnistrator, none ako korisnik nije prijavljen 
            String userType = UserDAO.login(userName, password);
            HttpSession hSession = PticaMetodi.returnSession(request);
            if (userType.equals("emp")) { // prijava zaposelnog
                hSession.setAttribute("user_type", "emp"); // korisnik koji se prijavio kao zaposleni ( može sve da uradi izuzev da doda novi nalog )
                hSession.setAttribute("logged_in", "true" ); // postavi varijablu sesije logged_in ( da li se korisnik prijavio )
                response.sendRedirect("index.jsp");     
            } else if (userType.equals("admin")) { // prijava administratora
                hSession.setAttribute("user_type", "admin"); // korisnik se prijavio kao administrator ( može sve da uradi )
                hSession.setAttribute("logged_in", "true" ); // postavi varijablu sesije logged_in ( da li se korisnik prijavio )
                response.sendRedirect("index.jsp"); // prikaži index.jsp - korisnik se prijavio    
            } else {
                // postavljanje vrednosti varijabli sesije
                String sTitle = "Greška"; // koristi se za prosleđivanje naslova
                String sMessage = "ERR_LOGIN"; // koristi se za prosleđivanje naslova	 
                hSession.setAttribute("source_name", "Prijava"); // naziv veb strane na kojoj sam sada
                hSession.setAttribute("message", sMessage); 
                hSession.setAttribute("title", sTitle); 
                hSession.setAttribute("logged_in", "false"); // da li se korisnik ulogovao
                response.sendRedirect("error_succ.jsp"); // preusmeravanje na error_succ.jsp                            
            }
        } catch (Throwable theException) {
            System.out.println(theException); 
        }
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
