/*
 * Autor    : Ingrid Farkaš
 * Projekat : Ptica
 * SignUpServlet.java : kada korisnik na stranici Novi nalog klikne na Pošaljite dugme tada se poziva ovaj servlet
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

public class SignUpServlet extends HttpServlet {

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
            out.println("<title>Ptica - Novi nalog</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SignUpServlet at " + request.getContextPath() + "</h1>");
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
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try{	    
            // pročitaj tekst iz polja username, passw1, first_name, last_name, admin ( login_form.jsp ) 
            String userName = request.getParameter("username"); 
            String password = request.getParameter("passw1");
            String first_name = request.getParameter("first_name");
            String last_name = request.getParameter("last_name");
            String admin = request.getParameter("admin");
            
            // deleteSpaces: uklanja prazan prostor sa početka i kraja stringa i zamenjuje 2 ili više prazna mesta ( unutar stringa )
            // sa jednim praznim mestom
            first_name = PticaMetodi.deleteSpaces(first_name);
            last_name = PticaMetodi.deleteSpaces(last_name);
            
            // addBacksl : poziva metod koji zamenjuje svaku pojavu \ sa \\\\ i zamenjuje svaku pojavu ' sa \\'
            first_name = PticaMetodi.addBacksl(first_name);
            last_name = PticaMetodi.addBacksl(last_name);
            userName = PticaMetodi.addBacksl(userName);
            password = PticaMetodi.addBacksl(password);
            
            String name = first_name + " " + last_name;
            HttpSession hSession = request.getSession(); // sesija kojoj ću da dodam varijable
            
            // metod userExists vraća TRUE ako korisnik sa tim korisničkim imenom i lozinkom postoji u bazi, inače vraća FALSE
            boolean userExists = UserDAO.userExists(userName, password); 
            if (userExists){ 
                // postavljanje varijabli sesije ( da bi se prosledile u error_succ.jsp ) i prikazivanje veb stranice error_succ.jsp
                String sTitle = "Greška"; // koristi se za prosleđivanje naslova
                String sMessage = "ERR_USER_EXISTS"; // koristi se za prosleđivanje naslova	 
                hSession.setAttribute("source_name", "Novi nalog"); // naziv veb strane na kojoj sam sada
                hSession.setAttribute("message", sMessage); 
                hSession.setAttribute("title", sTitle); 
                hSession.setAttribute("sign_up", "false" ); // korisnik je završio unošenje novog naloga 
                response.sendRedirect("error_succ.jsp"); // preusmeravanje na error_succ.jsp     
            } else { // korisničko ime i lozinka ne postoje
                // signUp: vraća TRUE ako je novi korisnik uspešno dodat u tabelu login, inače vraća FALSE
                boolean result = UserDAO.signUp(userName, password, name, admin);

                if (result){ // novi korisnik je uspešno dodat bazi 
                    // postavljanje varijabli sesije ( da bi se prosledile u error_succ.jsp ) i prikazivanje veb stranice error_succ.jsp
                    String sTitle = "Novi nalog"; // za prosleđivanje naslova u JSP
                    String sMessage = "SUCC_SIGN_UP"; // za prosleđivanje poruke u JSP	 
                    hSession.setAttribute("source_name", "Novi nalog"); // naziv veb strane na kojoj sam sada
                    hSession.setAttribute("message", sMessage); 
                    hSession.setAttribute("title", sTitle); 
                    hSession.setAttribute("sign_up", "false" ); // korisnik je završio unošenje novog naloga 
                    response.sendRedirect("error_succ.jsp"); // preusmeravanje na error_succ.jsp   
                } else { // novi korisnik nije uspešno dodat bazi  
                    // postavljanje varijabli sesije ( da bi se prosledile u error_succ.jsp ) i prikazivanje veb stranice error_succ.jsp
                    String sTitle = "Greška"; // za prosleđivanje naslova u JSP
                    String sMessage = "ERR_SIGN_UP"; // za prosleđivanje poruke u JSP	 
                    hSession.setAttribute("source_name", "Novi nalog"); // naziv veb strane na kojoj sam sada
                    hSession.setAttribute("message", sMessage); 
                    hSession.setAttribute("title", sTitle); 
                    hSession.setAttribute("sign_up", "false"); // korisnik je završio unošenje novog naloga 
                    response.sendRedirect("error_succ.jsp"); // preusmeravanje na error_succ.jsp
                }
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
