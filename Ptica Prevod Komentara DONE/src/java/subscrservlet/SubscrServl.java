/*
 * autor    : Ingrid Farkaš
 * projekat : Ptica
 * SubscribeServl.java: posle klika na dugme Prijavite se ( footer.jsp ) poziva se ovaj servlet
 */
package subscrservlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import miscellaneous.PticaMetodi;

public class SubscrServl extends HttpServlet {

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
            out.println("<title>APtica - Subscribe</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SubscrServl at " + request.getContextPath() + "</h1>");
            out.println("Subscribe Servlet");
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
        
        String valid_email = "false"; // da li je to važeći email 
        String cookie_val = ""; // vrednost kolačića
        
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {	    
            HttpSession hSession2 = PticaMetodi.returnSession(request);
            // ako ne postoji kolačić čije ime počinje sa "input" tada nema podataka kojima treba da se popuni formular
            hSession2.setAttribute("fill_in", "false");
            
            // čitanje teksta iz subscr_email ( footer.jsp ) - email adresa za Newsletter
            String subscrEmail = request.getParameter("subscr_email"); // tekst u input kontroli subscr_email ( footer.jsp )
            String pageName = "";
            if (PticaMetodi.sessVarExists( hSession2, "webpg_name") ) {
                pageName = String.valueOf( hSession2.getAttribute("webpg_name") );
            }
           
            // ako je pre unošenja email-a jedna od veb stranica ( index.jsp, contact_page.jsp, about_page.jsp ) bila prikazana nije potrebno
            // da čitam kolačiće koji sadrže vrednosti input polja i da ih čuvam u varijablama sesije 
            if ((!(pageName.equalsIgnoreCase("index.jsp"))) && (!(pageName.equalsIgnoreCase("contact_page.jsp"))) && 
                    (!(pageName.equalsIgnoreCase("about_page.jsp"))) && (!(pageName.equalsIgnoreCase("")))) {
                Cookie[] cookies = request.getCookies();
                boolean first_time = false; // da li je prvi kolačić čije ime počinje sa "input" 

                // prolazim kroz kolačiće
                for (Cookie cookie:cookies) {
                    // postavljanje vrednosti varijabli sesije na "" za varijable sa imenom input0, input1, ...
                    String cookie_name = cookie.getName();
                    // da li kolačić koji sam pročitala sadrži tekst koji je bio u jednom od input polja
                    boolean is_input = cookie_name.startsWith("input", 0); 

                    if (is_input) {
                        // ako je ovo prvi kolačić čije ime počinje sa "input" postavi varijablu fill_in na true
                        // kada učitam stranicu ako je fill_in postavljen na true tada obrazac treba da se popuni sa vrednostima iz 
                        // varijabli sesije
                        if (!first_time) {
                            first_time = true;
                            hSession2.setAttribute("fill_in", "true");
                        }
                        cookie_val = cookie.getValue();
                        
                        // dodajem ovu vrednost sesiji zbog prijave na NEWSLETTER
                        // IDEJA prijave na NEWSLETTER : posle unosa email adrese i klika na dugme ( prijava na Newsletter ) korisnik se uspešno 
                        // prijavio na Newsletter - posle toga kada korisnik klikne na Zatvori dugme veb stranica koja je bila prethodno prikazana
                        // treba da se popuni sa vrednostima - ove vrednosti su vrednosti koje treba da zapamtim u sesiji
                        hSession2.setAttribute(cookie_name, cookie_val);
                    }
                }  
            }
            
            String exOccurred = "false";
            
            Cookie[] cookies = request.getCookies();
            // prolazim kroz kolačiće
            for (Cookie cookie:cookies) {
                String cookie_name = cookie.getName();
                if (cookie_name.equalsIgnoreCase("valid_email")){
                    // da li je to važeći email 
                    valid_email = cookie.getValue();
                    // formiram varijablu sesije sa imenom cookie_name koja sadrži vrednost valid_email 
                    hSession2.setAttribute(cookie_name, valid_email);
                }
            }
            
            // metod addEmail dodaje emajl za Newsletter u tabelu subscription
            // vraća TRUE ako je došlo do izuzetka inače vraća FALSE 
            if (valid_email.equalsIgnoreCase("true")) {
                exOccurred = SubscrDAO.addEmail(subscrEmail);
            }
            hSession2.setAttribute("db_exoccurred", exOccurred );
            // prikaži veb stranicu subscrres_page.jsp
            response.sendRedirect("subscrres_page.jsp"); 
        } catch (Exception e){ // Throwable
            System.out.print("Izuzetak: ");
            System.out.println(e.getMessage());
        }
    }

    /**.
     * Returns a short description of the servlet     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
