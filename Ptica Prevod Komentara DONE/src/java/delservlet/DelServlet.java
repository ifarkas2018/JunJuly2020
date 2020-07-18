/*
 * autor           : Ingrid Farkaš
 * projekat        : Ptica
 * DelServlet.java : koristi se za izvršavanje SQL upita ( koristi se u upd_del_title.jsp za Brisanje knjige )
 */
package delservlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Connection;
import connection.ConnectionManager;

import javax.servlet.http.HttpSession;
import miscellaneous.PticaMetodi;

@WebServlet(urlPatterns = {"/DelServlet"}) // ako je URL /DelServlet
public class DelServlet extends HttpServlet {

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
            out.println("<title>Servlet NewDelServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet NewDelServlet at " + request.getContextPath() + "</h1>");
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
    
    // delete: briše knjigu sa određenim naslovom, autorom, ISBN iz baze
    // returnStr: vraća se u doPost. Koristi se za postavljanje atributa u sesiji pre preusmeravanja na error_succ.jsp
    private String delete(HttpSession hSession) {
        String returnStr = "NO_ERR"; // da li je došlo do greške i kakve
        
        try {
            String prev_title = (String)hSession.getAttribute("prev_title");
            String prev_author = (String)hSession.getAttribute("prev_auth");
            String prev_isbn = (String)hSession.getAttribute("prev_isbn");
        
            // deleteSpaces: uklanja prazan prostor sa početka i kraja stringa i zamenjuje 2 ili više prazna mesta ( unutar stringa )
            // sa jednim praznim mestom
            prev_title = PticaMetodi.deleteSpaces(prev_title);
            prev_author = PticaMetodi.deleteSpaces(prev_author);
            prev_isbn = PticaMetodi.deleteSpaces(prev_isbn);
            
            Connection con = ConnectionManager.getConnection(); // povezivanje sa bazom 
            Statement stmt = con.createStatement();
            
            String query = ""; 
            String auid = ""; // broj autora ( kolona au_id, tabela author )
            boolean added_col = false; // da li je ime kolone dodato upitu 
            DetermineID idObject = new DetermineID(); // koristi se za pozivanje metoda determineAuthID( author, stmt ) 
            
            // DETERMINING the AUTHOR ID 
            if (!((prev_author.equalsIgnoreCase("")))) {
                // determineAuthID : formiranje i izvršavanje upita SELECT au_id FROM author WHERE au_name='...';
                auid = idObject.determineAuthID(prev_author, stmt); // određujem ID autora za tog autora 
                
                // ako autor sa tim imenom ne postoji dodaj tog autora tabeli
                if (auid.equals("")) { // autor ne postoji u bazi
                    returnStr = "ERR_NO_AUTHID";
                }
            }
            
            // upit: DELETE FROM book WHERE title='...' AND au_id='...' AND isbn='...'; 
            query = "DELETE FROM book WHERE ";
            if (!(prev_title.equalsIgnoreCase(""))) { // ako je korisnik naslov 
                query += "title = '" + prev_title + "' "; // dodaj upitu : title = '...'
                added_col = true; // upit sadrži kolonu
            }
            
            if (!(auid.equalsIgnoreCase(""))) { // ako ID autora postoji
                if (added_col == true ) // ako je ime jedne kolone dodate upitu dodaj AND
                    query += "AND "; 
                
                query += "au_id = '" + auid + "' "; // dodaj upitu auid = '...'
                added_col = true; // kolona je dodata upitu
            }
            
            // ako je korisnik uneo ISBN
            if (!(prev_isbn.equalsIgnoreCase(""))) {
                if (added_col == true) // ako je kolona dodata upitu
                    query += "AND "; // dodaj upitu AND
                
                query += "isbn = '" + prev_isbn + "' "; // dodaj upitu isbn = '...'
                added_col = true; // kolona je dodata upitu 
            }
            
            query += ";";
            
            PreparedStatement preparedStmt = con.prepareStatement(query);
            int rowcount = preparedStmt.executeUpdate(); // izvršavanje upita
                        
            hSession.setAttribute("source_name", "Brisanje knjige"); // veb stranica gde sam sada
            
            String sMessage; // koristi se za slanje poruke iz jednog JSP skripta u drugi
            if (rowcount > 0) { // vrsta je obrisana
                returnStr = "SUCC_DELETE";
            } else { 
                returnStr = "DEL_NO_BOOK";
            }
        } catch (Exception ex) {
            returnStr = "ERR_DELETE";
        }
        return returnStr;
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
        response.setContentType("text/html;charset=UTF-8");
        HttpSession hSession = PticaMetodi.returnSession(request); // hSession - koristi se za čuvanje informacije o tom korisniku
        String returnStr = delete(hSession);       
        
        String sTitle = "Greška"; // koristi se za prosleđivanje naslova od jednog JSP skripta do drugog 
       
        // zavisno od returnStr postavi varijable sesije  ( koristi se u error_succ.jsp )
        if (returnStr.equalsIgnoreCase("ERR_NO_AUTHID")) {
            String sMessage = "ERR_NO_AUTHID"; // koristi se za prosleđivanje poruka od jednog JSP skripta do drugog 
            hSession.setAttribute("source_name", "Brisanje knjige"); // veb stranica gde sam sada
            hSession.setAttribute("message", sMessage);   
        } else if (returnStr.equalsIgnoreCase("SUCC_DELETE")) { // koristi se za prosleđivanje poruka od jednog JSP skripta do drugog 
            String sMessage = "SUCC_DELETE";
            sTitle = "Brisanje knjige"; // koristi se za prosleđivanje naslova od jednog JSP skripta do drugog 
            hSession.setAttribute("message", sMessage); 
        } else if (returnStr.equalsIgnoreCase("DEL_NO_BOOK")) { // koristi se za prosleđivanje poruka od jednog JSP skripta do drugog 
            String sMessage = "DEL_NO_BOOK";
            hSession.setAttribute("message", sMessage); 
        } else { // returnStr is ERR_DELETE
            String sMessage = "ERR_DELETE"; // koristi se za prosleđivanje poruka od jednog JSP skripta do drugog
            hSession.setAttribute("source_name", "Brisanje knjige"); // veb stranica gde sam sada
            hSession.setAttribute("message", sMessage); 
        }
        hSession.setAttribute("title", sTitle); // koristi se za postavljanje atributa title na vrednost sTitle
        request.getRequestDispatcher("error_succ.jsp").forward(request,response); // preusmeravanje na error_succ.jsp
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
