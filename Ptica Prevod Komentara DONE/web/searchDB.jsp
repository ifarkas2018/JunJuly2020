<%-- 
    Dokument  : searchDB.jsp se poziva iz search_form.jsp
    Formiran  : 18-Sep-2018, 00:54:05
    Autor     : Ingrid Farkaš
    Projekat  : Ptica
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="connection.ConnectionManager"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.lang.CharSequence"%>
<%@page import="miscellaneous.PticaMetodi"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/templatecss.css" type="text/css" rel="stylesheet"/>
        <title>Ptica - Pretraga knjiga</title>
        <%@ include file="header.jsp"%>
    </head>
    
    <body>
        <%!
            // cont_wildcard vraća true ako str sadrži jedan od znakova % ili _ ( džoker znakovi ). Inače vraća false.
            boolean cont_wildcard(String str) {
            CharSequence undersc = "_";
            CharSequence percentage = "%";
            // da li string sadrži _ ili %
            if ((str.contains(undersc)) || (str.contains(percentage)))
                return true;
            else
                return false;
            }
        %>
        <!-- dodavanje novog reda u Bootstrap grid: klasa whitebckgr postavlja pozadinu u belu boju -->
        <div class="whitebckgr">
            <div class="row"> 
                <div class="col-lg-6 col-md-6"> 
                    <br /><br />
                    <div> <!-- center-image postavlja sliku u sredinu ( horizontalno ), img-fluid je za responsivan image -->
                        <img src="images/books.png" class="img-fluid center-image" alt="slika sa knjigama" title="slika sa knjigama"> 
                    </div>
                </div>
                       
                <div class="col-lg-5 col-md-5"> 
                    <div class="container">
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col">
                                &nbsp; &nbsp;
                                <br/>
                                <h3 class="text-info">Pretraga knjiga</h3><br/>
                                
                                <%
                                    boolean booksReturned = false; // da li su pronađene knjige prilikom Pretrage knjiga 
                                    boolean subscr = false; // da li se neposredno prethodno korisnik prijavio na Newsletter
                                    HttpSession hSession = PticaMetodi.returnSession(request);
                                    // varijabla sessije je postavljena na true u subscrres_content.jsp ( ako se korisnik prijavio na Newsletter )
                                    if (PticaMetodi.sessVarExists(hSession, "subscribe")) {
                                        // ime veb stranice koja je prikazana pre ove stranice
                                        subscr = Boolean.valueOf(String.valueOf(hSession.getAttribute("subscribe")));
                                        hSession.setAttribute("subscribe", "false"); // postavljanje varijable sesije na inicijalnu vrednost
                                    } 
                                    hSession.setAttribute("webpg_name", "searchDB.jsp");
                                
                                    try { 
                                        String form_title = "";
                                        String form_auth = "";
                                        String form_isbn = "";
                                        String form_price = "";
                                        String form_sortby = "";
                                        String form_categ = "";
                                        String form_publyear = ""; 
                                
                                        // korisnik se neposredno prethodno prijavio na Newsletter - treba da pročitam vrednosti iz forme
                                        if (subscr) { 
                                            // pročitaj i resetuj varijable sesije
                                            form_title = PticaMetodi.readSetSessV(hSession, "input0"); // naslov 
                                            form_auth = PticaMetodi.readSetSessV(hSession, "input1"); // autor
                                            form_isbn = PticaMetodi.readSetSessV(hSession, "input2"); // isbn
                                            form_price = PticaMetodi.readSetSessV(hSession, "input3"); // cena
                                            form_sortby = PticaMetodi.readSetSessV(hSession, "input4"); // kriterijum za sortiranje
                                            form_categ = PticaMetodi.readSetSessV(hSession, "input5"); // žanr             
                                            form_publyear = PticaMetodi.readSetSessV(hSession, "input6"); // godina izdavanja

                                            // postavlja varijable sesije ( čija imena počinju sa input ) na ""
                                            PticaMetodi.setToEmptyInput(hSession);
                                        }
                                    
                                        if (!subscr) { // korisnik prikazuje ovu veb stranicu BEZ prijave na Newsletter
                                            form_title = request.getParameter("title"); // naslov koji je korisnik uneo
                                            form_auth = request.getParameter("author"); 
                                            form_isbn = request.getParameter("isbn"); 
                                            form_sortby = request.getParameter("sortby"); 
                                            form_categ = request.getParameter("categ"); // žanr
                                            form_price = request.getParameter("price_range"); // raspon cene
                                            form_publyear = request.getParameter("publ_year"); // godina izdavanja
                                    
                                            // postavlja varijable sesije ( čija imena počinju sa input ) na ""
                                            PticaMetodi.setToEmptyInput(hSession);
                                        }
                                    
                                        // deleteSpaces: uklanja prazan prostor sa početka i kraja stringa i zamenjuje 2 ili više prazna mesta ( unutar stringa )
                                        // sa jednim praznim mestom
                                        form_title = PticaMetodi.deleteSpaces(form_title);
                                        form_auth = PticaMetodi.deleteSpaces(form_auth);
                                        form_isbn = PticaMetodi.deleteSpaces(form_isbn);
                                        form_publyear = PticaMetodi.deleteSpaces(form_publyear);
                                    %>  
                                    <%
                                        Connection con = ConnectionManager.getConnection(); // povezivanje sa bazom  
                                        Statement stmt = con.createStatement();
                                    
                                        String sQuery = "select b.title, b.price, b.isbn, b.publ_year, b.descr, a.au_name from book b, author a where (b.au_id = a.au_id)";
                                    
                                        // ako je korisnik uneo naslov
                                        if (!(form_title.equalsIgnoreCase(""))) {
                                            // addBacksl : zamenjuje svaku pojavu \ sa \\\\ i svaku pojavu ' sa \\'
                                            form_title = PticaMetodi.addBacksl(form_title);
                                            // ako naslov sadrži ? ili _ tada dodajem Like 
                                            if (cont_wildcard(form_title)){
                                                sQuery += " AND (b.title LIKE '" + form_title + "')";
                                            } else 
                                                sQuery += " AND (b.title='" + form_title + "')";
                                        }     
                                    
                                        // ako je korisnik uneo ime autora
                                        if (!(form_auth.equalsIgnoreCase(""))) {
                                            // addBacksl : zamenjuje svaku pojavu \ sa \\\\ i svaku pojavu ' sa \\'
                                            form_auth = PticaMetodi.addBacksl(form_auth);
                                            // ako autor sadrži ? ili _ tada dodajem Like 
                                            if (cont_wildcard(form_auth))
                                                sQuery += " AND (a.au_name LIKE '" + form_auth + "')";
                                            else
                                                sQuery += " AND (a.au_name='" + form_auth + "')";
                                        }
                                    
                                        // ako je korisnik uneo isbn
                                        if (!(form_isbn.equalsIgnoreCase(""))) {
                                            // ako isbn sadrži ? ili _ tada dodajem Like 
                                            if (cont_wildcard(form_isbn))
                                                sQuery += " AND (b.isbn LIKE '" + form_isbn + "')";
                                            else
                                                sQuery += " AND (b.isbn='" + form_isbn + "')";
                                        }
                                    
                                        String tempStr; // koristi se za formiranje upita
                                        if (form_categ.equalsIgnoreCase("all"))
                                            tempStr="";
                                        else {
                                            tempStr = form_categ;
                                        }
                                    
                                        // dodaj upitu da li je žanr jednak tempStr
                                        if (!(tempStr.equalsIgnoreCase(""))) 
                                            sQuery += " AND (b.category='" + tempStr + "')";
                                    
                                        tempStr="";
                                        // da li je cena < 500 
                                        if (form_price.equalsIgnoreCase("less500"))
                                            tempStr = "< 500"; 
                                        // da li je cena između 500 i 1000 
                                        else if (form_price.equalsIgnoreCase("betw500-1000"))
                                            tempStr = "BETWEEN 500 AND 1000";
                                        // da li je cena između 1001 i 2000 
                                        else if (form_price.equalsIgnoreCase("betw1001-2000"))
                                            tempStr = "BETWEEN 1001 AND 2000";
                                        // da li je cena između 2001 i 5000 
                                        else if (form_price.equalsIgnoreCase("betw2001-5000"))
                                            tempStr = "BETWEEN 2001 AND 5000";
                                        // da li je cena > 500
                                        if (form_price.equalsIgnoreCase("above5000"))
                                            tempStr = "> 5000";
                                    
                                        // dodaj upitu da li je cena u odgovarajućem intervalu
                                        if (!(tempStr.equalsIgnoreCase(""))) 
                                            sQuery += " AND (b.price " + tempStr + " )";

                                        // da li je korisnik uneo godinu izdavanja
                                        if (!(form_publyear.equalsIgnoreCase(""))) {
                                            // ako godina izdavanja sadrži ? ili _ tada dodajem Like 
                                            if (cont_wildcard(form_publyear))
                                                sQuery += " AND (b.publ_year LIKE '" + form_publyear + "')";
                                            else
                                                sQuery += " AND (b.publ_year='" + form_publyear + "')";
                                        }
                                    
                                        // sortiraj slogove ( opadajuće ili rastuće ) zavisno od izbora korisnika
                                        sQuery += " ORDER BY b.price "; 

                                        if (form_sortby.equalsIgnoreCase("low")) 
                                            sQuery += "ASC";
                                        else
                                            sQuery += "DESC";
                                        sQuery += ";";
                                    
                                        // izvrši upit
                                        ResultSet rs = stmt.executeQuery(sQuery); 

                                        // posle klika na dugme se prikazuje search_page.jsp
                                        out.println("<form action=\"search_page.jsp\" method=\"post\">");
                                    
                                        if (!(rs.next())) { // nema pronađenih knjiga
                                            out.println("<br /><br /><br />");
                                            out.println("Za izabrane kriterijume <span class=\"text-warning\">nije pronađena nijedna knjiga!</span>");
                                            out.println("<br /><br /><br /><br /><br />");
                                        } else {
                                            booksReturned = true;
                                            out.println("Sledeće knjige ispunjavaju zadate kriterijume: ");
                                            out.println("<br /><br />");
                                            // prikaži rezultat pretrage u obliku neuređene liste
                                            out.print("<ul>");
                                            // ako rezultat pretrage sadrži sledeći red
                                            do {
                                                // pročitaj naslov
                                                String sTitle = rs.getString("title");
                                                // pročitaj ime autora
                                                String sAuthor = rs.getString("au_name");
                                                // pročitaj cenu
                                                String sPrice = rs.getString("price");
                                                // pročitaj ISBN
                                                String sISBN = rs.getString("isbn");
                                                // prikaži naslov, autor i cenu
                                                String descr = rs.getString("descr");
                                                out.print("<li><b>" + sTitle + "</b> (autor: " + sAuthor + ")" ); 
                                                // ako postoji cena : prikaži je
                                                if (sPrice != null) {
                                                    // u bazi cena je u obliku 99999.99; na obrazcu cena treba da bude u obliku 99.999,99
                                                    sPrice = sPrice.replace('.',','); // zameni decimalnu . sa ,
                                                    sPrice = PticaMetodi.dodajTacku(sPrice); // dodajem tačku u cenu iza hiljadu dinara 
                                                    out.print(" <b>cena: </b>" + sPrice + " RSD");
                                                }
                                                
                                                // ako postoji Isbn : prikaži ga
                                                if (sISBN != null) {
                                                    out.print("<br /><b>" + "Isbn: </b>" + sISBN );
                                                }
                                                
                                                // ako postoji opis : prikaži ga
                                                if (descr != null) {
                                                    out.print("<br /><b>" + "Opis: </b>" + descr );
                                                }
                                                
                                                out.print("</li>");
                                            } while(rs.next());

                                            out.print("</ul>");
                                        }
                                        out.print("<br />");
                                        // dodajem dugme obracu; btn-sm se koristi za manju ( užu ) veličinu kontrole -->
                                        out.print("<button type=\"submit\" class=\"btn btn-info btn-sm\">Pretraga knjiga</button>");
                                        out.println("</form>");
                                    } catch(Exception e) {
                                        String sMessage = "ERR_SEARCH"; // koristi se za prosleđivanje poruke
                                        String sTitle = "Greška"; // koristi se za prosleđivanje naslova
                                        hSession.setAttribute("source_name", "Pretraga knjiga"); // naziv veb strane na kojoj sam sada
                                        hSession.setAttribute("title", sTitle); 
                                        hSession.setAttribute("message", sMessage); 
                                        response.sendRedirect("error_succ.jsp"); // preusmeravanje na error_succ.jsp  
                                    }
                                %>

                            </div> <!-- završetak class="col" -->
                        </div> <!-- završetak class="row" --> 
                    </div> <!-- završetak class="container" -->
                </div> <!-- završetak class="col-lg-5 col-md-5" -->
            </div> <!-- završetak class="row" -->
        </div> <!-- završetak class="whitebckgr" -->
         
        <% if (booksReturned) { // ako postoje knjige koje su pronađene ( i prikazane ) kao rezultat upita
        %>
        
            <div class="whitebckgr">
                <div class="col">
                    &nbsp; &nbsp;
                </div>
            </div> 
    
        <%
           }
        %>
        
        <!-- dodajem novi red u Bootstrap grid; klasa whitebckgr: za postavljanje pozadine u belu boju -->
        <div class="whitebckgr">
            <div class="col">
                &nbsp; &nbsp;
            </div>
        </div> 
          
        <%@ include file="footer.jsp"%>
    </body>
</html>
