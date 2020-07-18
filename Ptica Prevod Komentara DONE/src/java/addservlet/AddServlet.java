/*
 * autor   : Ingrid Farkaš
 * projekat: Ptica
 * AddServlet.java : kada korisnik klikne na dugme Dodaj knjigu ( add_form.jsp ) tada se ovaj servlet poziva
 */
package addservlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import miscellaneous.PticaMetodi;

public class AddServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */ 
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddServlet at " + request.getContextPath() + "</h1>");
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sTitle = "Nova knjiga"; // koristi se za prosleđivanje naslova u error_succ.jsp
        HttpSession hSession = request.getSession();
        
        String form_publ = request.getParameter("publisher"); // tekst unet u formi za izdavača
        String form_auth = request.getParameter("author"); // tekst unet u formi za autora
        String form_title = request.getParameter("title"); // tekst unet u formi za naslov
        String form_isbn = request.getParameter("isbn"); // isbn 
        String form_price = request.getParameter("price"); // cena
        String form_pages = request.getParameter("pages"); // broj strana
        String form_categ = request.getParameter("category"); // žanr
        String form_descr = request.getParameter("descr"); // opis knjige
        String form_yrpublished = request.getParameter("yrpublished"); // godina izdavanja 
        
        form_price = form_price.replace(".", "");
        form_price = form_price.replace(",", "."); // tip podataka za cenu u bazi je float
        
        // deleteSpaces: uklanja prazni prostor sa početka i kraja stringa i zamenjuje 2 ili više praznih mesta sa jednim praznim mestom
        // unutar stringa
        form_title = PticaMetodi.deleteSpaces(form_title);
        form_auth = PticaMetodi.deleteSpaces(form_auth);
        form_isbn = PticaMetodi.deleteSpaces(form_isbn);
        form_price = PticaMetodi.deleteSpaces(form_price);
        form_pages = PticaMetodi.deleteSpaces(form_pages);
        form_descr = PticaMetodi.deleteSpaces(form_descr);
        form_publ = PticaMetodi.deleteSpaces(form_publ);
        form_yrpublished = PticaMetodi.deleteSpaces(form_yrpublished);
        
        // addBacksl: zamenjuje svaku pojavu \ sa \\\\ i zamenjuje svaku pojavu ' sa \\'
        form_title = PticaMetodi.addBacksl(form_title);
        form_auth = PticaMetodi.addBacksl(form_auth);
        form_descr = PticaMetodi.addBacksl(form_descr);
        form_publ = PticaMetodi.addBacksl(form_publ);
        
        // metod addNewBook dodaje novu knjigu u tabelu knjiga ( vraća String zavisno od poruke koju će error_succ.jsp prikazati )
        String sMessage = AddDAO.addNewBook(hSession, form_title, form_auth, form_publ, form_isbn, form_price, form_pages, form_categ, form_descr, form_yrpublished);
        
        // zavisno od vrednosti koju je vratio metod addNewBook određujem sTitle
        if ((sMessage.equals("ERR_ADD")) || (sMessage.equals("ERR_ADD_EXISTS"))) {
            sTitle = "Greška"; // koristi se za prosleđivanje naslova u JSP
        } else if (sMessage.equals("SUCC_ADD")) {
            sTitle = "Nova knjiga"; // koristi se za prosleđivanje naslova u JSP
        }
        
        // postavljanje vrednosti varijabli sesije
        hSession.setAttribute("source_name", "Nova knjiga"); // naziv veb strane na kojoj sam sada
        hSession.setAttribute("message", sMessage); 
        hSession.setAttribute("title", sTitle); 
        response.sendRedirect("error_succ.jsp"); // preusmeravanje na error_succ.jsp                        
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
