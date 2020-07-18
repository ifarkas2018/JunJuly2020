<%-- 
    Dokument   : home_1_book se poziva kada korisnik klikne na jednu od knjiga na starnici index_content
    Formiran   : 21-Sep-2019, 20:48:11
    Autor      : Ingrid Farkaš
    Projekat   : Ptica
--%>

<%@page import="java.sql.Connection"%>
<%@page import="connection.ConnectionManager"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="miscellaneous.PticaMetodi"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/templatecss.css" type="text/css" rel="stylesheet"/>
        <title>Ptica - Novi naslovi</title>
        <%@ include file="header.jsp"%>
        <script>
            function deleteCookie() {
                document.cookie = "book_index= ; expires=Thu, 01 Jan 1970 00:00:00 UTC;";
            }  
        </script>
    </head>
    
    <body onload="deleteCookie()">
        <%! 
            // retrieveBookDescr: čita naslov, ime autora, cenu, isbn, opis knjige
            // kada korisnik klikne na jednu od knjiga na starnici index_content sa indeksom index
            public static ResultSet retrieveBookDescr(int index) throws SQLException {
                Connection con = ConnectionManager.getConnection(); // povezivanje sa bazom 
                Statement stmt = con.createStatement();
                                    
                String sQuery = "SELECT h.title, a.au_name, h.price, h.isbn, h.descr from homepg_books h, author a where a.au_id = h.au_id and book_id='" + index + "';";
                                    
                // izvrši upit - rezultat će biti u rs
                ResultSet rs = stmt.executeQuery(sQuery);
                return rs;
            }
            
        %>
        <div class="whitebckgr">
            <div class="row"> 
                <div class="col-lg-6 col-md-6"> 
                    <br /><br />
                    <div> 
                        <!-- center-image postavlja sliku u sredinu ( horizontalno ), img-fluid je za responzivan image -->
                        <img src="images/books.png" class="img-fluid center-image" alt="picture of books" title="picture of books"> 
                    </div>
                </div>
                       
                <div class="col-lg-5 col-md-5"> 
                    <div class="container">
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col">
                                &nbsp; &nbsp;
                                <br/>
                                <h3 class="text-info">Novi naslovi</h3><br/>
                                <%
                                    HttpSession hSession = PticaMetodi.returnSession(request);
                                    hSession.setAttribute("webpg_name", "home_book.jsp");
                                    // postavljanje vrednosti varijabli sesije na inicijalnu vrednost: ako je korisnik završio prijavu na Newsletter,
                                    // obrazac na sledećoj veb stranici ne treba da prikaže prethdne vrednosti
                                    hSession.setAttribute("subscribe", "false");
                                    Integer index = 0;
                                    
                                    Object indexObj = hSession.getAttribute("book_index");
                                    index = Integer.parseInt(String.valueOf(indexObj));
                                    
                                    boolean sessionvarex = PticaMetodi.sessVarExists(hSession, "book_index");
                                    sessionvarex = !sessionvarex;
                                    try {                                      
                                %>  
                                    <%
                                         // čitanje podataka o knjizi i čuva ih u rs
                                        ResultSet rs = retrieveBookDescr(index);

                                        // posle klika na dugme prikazuje se index.jsp
                                        out.println("<form action=\"index.jsp\" method=\"post\">");
                                    
                                        if (!(rs.next())) { // nema podataka o knjizi
                                            out.println("<br /><br /><br />");
                                            out.println("<span class=\"text-warning\">Podaci o ovoj knjizi ne postoje!</span>");
                                            out.println("<br /><br /><br /><br /><br />");
                                        } else {
                                            // prikaži rezultat u neuređenoj listi
                                            out.print("<ul>");
                                            
                                            // čitanje naslova
                                            String sTitle = rs.getString("title");
                                            // čitanje imena autora
                                            String sAuthor = rs.getString("au_name");
                                            // čitanje cene
                                            String sPrice = rs.getString("price");
                                            // čitanje ISBN
                                            String sISBN = rs.getString("isbn");
                                            // prikaži naslov, autor i cenu
                                            String descr = rs.getString("descr");
                                            out.print("<li><b>" + sTitle + "</b> od (<b>autora</b>) " + sAuthor ); 
                                            
                                            // ako cena postoji prikaži je 
                                            if (sPrice != null && !sPrice.equalsIgnoreCase("")){
                                                // u bazi cena je u obliku 99999.99; na obrazcu cena se prikazuje u obliku 99.999,99
                                                sPrice = sPrice.replace('.',','); // zamenjujem decimalnu . sa ,
                                                sPrice = PticaMetodi.dodajTacku(sPrice); // dodajem tačku u cenu iza hiljadu dinara 
                                                out.print(" (<b>cena: </b>" + sPrice + " RSD)" + "<br/>");
                                            }
                                                
                                            // ako ISBN postoji: prikaži ga
                                            if (sISBN != null && !sISBN.equalsIgnoreCase("")) {
                                                out.print("<br /><b>" + "Isbn: </b>" + sISBN + "<br/>" );
                                            }
                                                
                                            // ako opis knjige postoji: prikaži ga
                                            if (descr != null && !descr.equalsIgnoreCase("")) {
                                                out.print("<br /><b>" + "Opis: </b>" + descr );
                                            }
                                                
                                            out.print("</li>");
                                            out.print("</ul>");
                                        }
                                        out.print("<br />");
                                        // btn-sm se koristi za manju ( užu ) veličinu kontrole
                                        out.print("<button type=\"submit\" class=\"btn btn-info btn-sm\">Ptica</button>");
                                        out.println("</form>");
                                    } catch(Exception e) {
                                        String sMessage = "ERR_DB";
                                        String sTitle = "Greška"; // koristi se za prosleđivanje naslova
                                        hSession.setAttribute("source_name", "Novi naslovi"); // naziv veb strane na kojoj sam sada
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
            
        <!-- dodavanje novog reda u Bootstrap grid; klasa whitebckgr: postavljanje pozadine u belu boju -->
        <div class="whitebckgr">
            <div class="col">
                &nbsp; &nbsp;
            </div>
        </div> 
        
        
        <!-- dodavanje novog reda u Bootstrap grid; klasa whitebckgr: postavljanje pozadine u belu boju -->
        <div class="whitebckgr">
            <div class="col">
                &nbsp; &nbsp;
            </div>
        </div>  
        <%@ include file="footer.jsp"%>
    </body>
</html>