<%-- 
    Dokument   : index_content
    Formiran   : 16-Apr-2019, 17:46:49
    Autor      : Ingrid Farkaš
    Projekat   : Ptica
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="miscellaneous.PticaMetodi"%>
<%@page import="java.sql.Connection"%>
<%@page import="connection.ConnectionManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.SQLException"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script  type="text/javascript">
            // createCookieIndex: kreira kolačić sa imenom book_index i sa vrednošću index 
            function createCookieIndex(index) {
                var cookie_str = "book_index=";
                cookie_str += index + ";";
                document.cookie = cookie_str; // kreiranje kolačića sa imenom book_index
            }
        
            // prilikom prikazvanja veb stranice prikaži modal ( id: centeredModal )
            $(window).on('load',function(){
                $('#centeredModal').modal('show');
            });
        </script>
        
        <style>
            /* stilovi za pretraživače manje od 350px; */
            /* ne prikazuje ( ili još uvek prikazuje ) tekst text pored slike zavisno od širine pretraživača */  
            @media screen and (max-width: 350px) {
                span.pic_text {
                    display: none;
                }
            }
            
            /* stilovi za pretraživače manje od 767px: ne prikazuju prostor levo od slike u levoj koloni */
            @media screen and (max-width: 767px) {
                div.book_L {
                    display: none;
                }
            }
             
            /* stilovi za pretraživače ( na mobilnim uređajima ) većim od 350px; (iPhone) */
            /* ne prikazuje ( ili još uvek prikazuje ) tekst ispod slike zavisno od širine pretraživača */
            @media screen and (min-width: 350px) {
                div.pic_text_below {
                    display: none;
                }
            }
                                   
        </style>
        
        <title>Ptica</title>
    </head>
    
    <body>    
        <%! String sTitle = "";
            String sAuthor = "";
            String sPrice = "";
            
            // retrieveBookInf: čita naslov, ime autora i cenu knjige
            // kada korisnik klikne na jednu od linkova na početnoj stranici za knjigu sa indeksom index
            public static ResultSet retrieveBookInf(int index) throws SQLException {
                Connection con = ConnectionManager.getConnection(); //povezivanje sa bazom 
                Statement stmt = con.createStatement();
                                    
                String sQuery = "SELECT h.title, a.au_name, h.price from homepg_books h, author a where a.au_id = h.au_id and book_id='" + index + "';";
                                    
                // izvrši upit - rezultat je u rs
                ResultSet rs = stmt.executeQuery(sQuery);
                return rs;
            }

            // bookInformation: čita iz rs naslov, ime autora, cenu, Isbn i opis knjige
            private void bookInformation(ResultSet rs) throws SQLException {
                sTitle = "";
                sAuthor = "";
                sPrice = "";
                
                try {
                    if (rs.next()) {
                        // čitaj naslov
                        sTitle = rs.getString("title");
                        // čitaj ime autora
                        sAuthor = rs.getString("au_name");
                        // čitaj cenu
                        sPrice = rs.getString("price");
                        // u bazi cena je u obliku 99999.99; na obrazcu cena treba da se prikaže u obliku 99.999,99
                        sPrice = sPrice.replace('.',','); // zamni decimalnu . sa ,
                        sPrice = PticaMetodi.dodajTacku(sPrice); // dodajem tačku u cenu iza hiljadu dinara
                    }
                } catch ( SQLException ex ) {
                    System.out.println("Izuzetak: " + ex.getMessage());
                }
            }
        %>  
        <%
            HttpSession hSession2 = PticaMetodi.returnSession(request);
            hSession2.setAttribute("webpg_name", "index.jsp");
            // postavljanje vrednosti varijabli sesije na inicijalnu vrednost: ako je korisnik sada završio prijavu na Newsletter,
            // obrazac na sledećoj veb stranici NE TREBA da prikaže prethdne vrednosti
            hSession2.setAttribute("subscribe", "false"); 
            hSession2.setAttribute("is_error", "false"); // nije došlo do greške
        %>
        <!-- dodavanje novog reda u Bootstrap grid: klasa whitebckgr postavlja pozadinu u belo -->
        <div class="whitebckgr minwidth">
            <div class="row"> 
                <!-- Bootstrap kolona zauzima 6 kolona na velikim desktopovima i 6 kolona na desktopovima srednje veliċine -->
                <div class="col-lg-6 col-md-6"> 
                    <div class="container"> 
                        <br />
                     
                        <%
                            try {    
                                // pročitaj podatke o knjizi i sačuvaj ih u result set-u rs
                                ResultSet rs = retrieveBookInf(1);
                                // čita naslov, ime autora, cenu, Isbn i opis knjige iz baze i čuva ih u varijablama
                                bookInformation(rs);
                            } catch (SQLException e) {
                                System.out.println("Izuzetak: " + e.getMessage());
                            }
                        %>
                        
                        <div class="row"> 
                            <div class="col-lg-1 col-md-1 col-sm-1 book_L">
                                &nbsp; 
                            </div>
                            <div class="col-lg-11 col-md-11 col-sm-11">
                                <!-- pull-left mr-2 se koristi za razmak između slike i teksta -->
                                <a href="ShowBook"><img src="images/book_1.jpg" class="img-fluid  float-left pull-left mr-2" onclick="createCookieIndex(1)" alt="slika sa knjigama" title="slika sa knjigama"></a>
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <span class="pic_text"><%= sAuthor%></span><br/> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) {
                                %>
                                    <span class="pic_text"><b><%= sTitle%></b></span><br/> <!-- naslov -->
                                <% } 
                                   if (!sPrice.equalsIgnoreCase("")) { 
                                %>
                                    <span class="pic_text"><%= sPrice %> RSD</span><br/> <!-- cena -->
                                <% } %>
                            </div>
                        </div> 
                        <div class="row"> 
                            <div class="col-lg-6 col-md-6 col-sm-6">
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <div class="pic_text_below"><%= sAuthor%></div> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) { 
                                %>
                                    <div class="pic_text_below"><b><%= sTitle%></b></div> <!-- naslov -->
                                <% } 
                                   if (!sPrice.equalsIgnoreCase("")) { 
                                %>
                                    <div class="pic_text_below"><%= sPrice %> RSD</div> <!-- cena -->
                                <% } %>
                            </div>
                        </div>
                        <br/>
                        
                        <%
                            try {    
                                // pročitaj podatke o knjizi i sačuvaj ih u result set-u rs
                                ResultSet rs = retrieveBookInf(2);
                                // čita naslov, ime autora, cenu, Isbn i opis knjige iz baze i čuva ih u varijablama
                                bookInformation(rs);
                            } catch (SQLException e) {
                                System.out.println("Izuzetak: " + e.getMessage());
                            }
                        %>
                        
                        &nbsp;
                        <div class="row"> <!-- dodavanje novog reda Bootstrap grid -->
                            <div class="col-lg-1 col-md-1 col-sm-1 book_L">
                                &nbsp;
                            </div>
                            
                            <div class="col-lg-11 col-md-11 col-sm-11">
                                <!-- pull-left mr-2 se koristi za razmak između slike i teksta -->
                                <a href="ShowBook"><img src="images/bk_2.jpg" class="img-fluid  float-left pull-left mr-2" onclick="createCookieIndex(2)" alt="slika sa knjigama" title="slika sa knjigama"></a>
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <span class="pic_text"><%= sAuthor%></span><br/> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) {
                                %>
                                    <span class="pic_text"><b><%= sTitle%></b></span><br/> <!-- naslov -->
                                <% } 
                                   if (!sPrice.equalsIgnoreCase("")) {
                                %>
                                    <span class="pic_text"><%= sPrice %> RSD</span><br/> <!-- cena -->
                                <% } %>
                            </div>
                        </div> 
                            
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col-lg-6 col-md-6 col-sm-6">
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <div class="pic_text_below"><%= sAuthor%></div> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) { 
                                %>
                                    <div class="pic_text_below"><b><%= sTitle%></b></div> <!-- naslov -->
                                <% } 
                                   if (!sPrice.equalsIgnoreCase("")) { 
                                %>
                                    <div class="pic_text_below"><%= sPrice %> RSD</div> <!-- cena -->
                                <% } %>
                            </div>
                        </div>
                        <br/>

                        <%
                            try {    
                                // pročitaj podatke o knjizi i sačuvaj ih u result set-u rs
                                ResultSet rs = retrieveBookInf(3);
                                // čita naslov, ime autora, cenu, Isbn i opis knjige iz baze i čuva ih u varijablama
                                bookInformation(rs);
                            } catch (SQLException e) {
                                System.out.println("Izuzetak: " + e.getMessage());
                            }
                        %>
                        
                        &nbsp;
                        <div class="row"> <!-- adding a new row to the Bootstrap grid -->
                            <div class="col-lg-1 col-md-1 col-sm-1 book_L">
                                &nbsp;
                            </div>
                            <div class="col-lg-11 col-md-11 col-sm-11">
                                <!-- pull-left mr-2 se koristi za razmak između slike i teksta -->
                                <a href="ShowBook"><img src="images/book_3.jpg" class="img-fluid  float-left pull-left mr-2" onclick="createCookieIndex(3)" alt="slika sa knjigama" title="slika sa knjigama"></a>
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <span class="pic_text"><%= sAuthor%></span><br/> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) {
                                %>
                                    <span class="pic_text"><b><%= sTitle%></b></span><br/> <!-- naslov -->
                                <% } 
                                   if (!sPrice.equalsIgnoreCase("")) { 
                                %>
                                    <span class="pic_text"><%= sPrice %> RSD</span><br/> <!-- cena -->
                                <% } %>
                            </div>
                        </div> 
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col-lg-6 col-md-6 col-sm-6">
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <div class="pic_text_below"><%= sAuthor%></div> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) { 
                                %>
                                    <div class="pic_text_below"><b><%= sTitle%></b></div> <!-- naslov -->
                                <% } 
                                   if (!sPrice.equalsIgnoreCase("")) {  
                                %>
                                    <div class="pic_text_below"><%= sPrice %> RSD</div> <!-- cena -->
                                <% } %>
                            </div>
                        </div>
                        <br/>
                        
                        <%
                            try {    
                                // pročitaj podatke o knjizi i sačuvaj ih u result set-u rs
                                ResultSet rs = retrieveBookInf(4);
                                // čita naslov, ime autora, cenu, Isbn i opis knjige iz baze i čuva ih u varijablama
                                bookInformation(rs);
                            } catch (SQLException e) {
                                System.out.println("Izuzetak: " + e.getMessage());
                            }
                        %>
                        
                        &nbsp;
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col-lg-1 col-md-1 col-sm-1 book_L">
                                &nbsp;
                            </div>
                            <div class="col-lg-11 col-md-11 col-sm-11">
                                <!-- pull-left mr-2 se koristi za razmak između slike i teksta -->
                                <a href="ShowBook"><img src="images/book_4.jpg" class="img-fluid  float-left pull-left mr-2" onclick="createCookieIndex(4)" alt="slika sa knjigama" title="slika sa knjigama"></a>
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <span class="pic_text"><%= sAuthor%></span><br/> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) {
                                %>
                                    <span class="pic_text"><b><%= sTitle%></b></span><br/> <!-- naslov -->
                                <% } 
                                   if (!sPrice.equalsIgnoreCase("")) {
                                %>
                                    <span class="pic_text"><%= sPrice %> RSD</span><br/> <!-- cena -->
                                <% } %>
                            </div>
                        </div> 
                            
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col-lg-6 col-md-6 col-sm-6">
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <div class="pic_text_below"><%= sAuthor%></div> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) { 
                                %>
                                    <div class="pic_text_below"><b><%= sTitle%></b></div> <!-- naslov -->
                                <% } 
                                   if (!sPrice.equalsIgnoreCase("")) { 
                                %>
                                    <div class="pic_text_below"><%= sPrice %> RSD</div> <!-- cena -->
                                <% } %>
                            </div>
                        </div>
                        <br/>
                        
                        <%
                            try {    
                                // pročitaj podatke o knjizi i sačuvaj ih u result set-u rs
                                ResultSet rs = retrieveBookInf(5);
                                // čita naslov, ime autora, cenu, Isbn i opis knjige iz baze i čuva ih u varijablama
                                bookInformation(rs);
                            } catch (SQLException e) {
                                System.out.println("Izuzetak: " + e.getMessage());
                            }
                        %>
                        
                        &nbsp;
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col-lg-1 col-md-1 col-sm-1 book_L">
                                &nbsp;
                            </div>
                            <div class="col-lg-11 col-md-11 col-sm-11">
                                <!-- pull-left mr-2 se koristi za razmak između slike i teksta -->
                                <a href="ShowBook"><img src="images/book_5.jpg" class="img-fluid  float-left pull-left mr-2" onclick="createCookieIndex(5)" alt="slika sa knjigama" title="slika sa knjigama"></a>
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <span class="pic_text"><%= sAuthor%></span><br/> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) {
                                %>
                                    <span class="pic_text"><b><%= sTitle%></b></span><br/> <!-- naslov -->
                                <% } 
                                   if (!sPrice.equalsIgnoreCase("")) {
                                %>
                                    <span class="pic_text"><%= sPrice %> RSD</span><br/> <!-- cena -->
                                <% } %>
                            </div>
                        </div> 
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col-lg-6 col-md-6 col-sm-6">
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <div class="pic_text_below"><%= sAuthor%></div> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) { 
                                %>
                                    <div class="pic_text_below"><b><%= sTitle%></b></div> <!-- naslov -->
                                <% } 
                                   if (!sPrice.equalsIgnoreCase("")) {  
                                %>
                                    <div class="pic_text_below"><%= sPrice %> RSD</div> <!-- cena -->
                                <% } %>
                            </div>
                        </div>
                        <br/>
                    </div>
                </div>
                
                <!-- the Bootstrap kolona zauzima 5 kolona na velikim desktopovima i 5 kolona na desktopovima srednje veličine -->
                <div class="col-lg-6 col-md-6"> 
                    <div class="container"> <!-- dodavanje kontejnera u Bootstrap grid -->
                        <br/>
                        <%
                            try {    
                                // pročitaj podatke o knjizi i sačuvaj ih u result set-u rs
                                ResultSet rs = retrieveBookInf(6);
                                // čita naslov, ime autora, cenu, Isbn i opis knjige iz baze i čuva ih u varijablama
                                bookInformation(rs);
                            } catch (SQLException e) {
                                System.out.println("Izuzetak: " + e.getMessage());
                            }
                        %>
                        
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col-lg-11 col-md-11 col-sm-11">
                                <!-- pull-left mr-2 se koristi za razmak između slike i teksta -->
                                <a href="ShowBook"><img src="images/book_6.jpg" class="img-fluid  float-left pull-left mr-2" onclick="createCookieIndex(6)" alt="slika sa knjigama" title="slika sa knjigama"></a>
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <span class="pic_text"><%= sAuthor%></span><br/> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) {
                                %>
                                    <span class="pic_text"><b><%= sTitle %></b></span><br/> <!-- naslov -->
                                <% } 
                                   if (!sPrice.equalsIgnoreCase("")) {
                                %>
                                    <span class="pic_text"><%= sPrice %> RSD</span><br/> <!-- cena -->
                                <% } %>
                            </div>
                            <div class="col-lg-1 col-md-1 col-sm-1 book_L">
                                &nbsp; 
                            </div>
                        </div>            
                        
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col-lg-6 col-md-6 col-sm-6">
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <div class="pic_text_below"><%= sAuthor%></div> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) { 
                                %>
                                    <div class="pic_text_below"><b><%= sTitle%></b></div> <!-- naslov -->
                                <% } 
                                   if (!sPrice.equalsIgnoreCase("")) { 
                                %>
                                    <div class="pic_text_below"><%= sPrice %> RSD</div> <!-- cena -->
                                <% } %>
                            </div>
                        </div>
                        <br/>
                            
                        <%
                            try {    
                                // pročitaj podatke o knjizi i sačuvaj ih u result set-u rs
                                ResultSet rs = retrieveBookInf(7);
                                // čita naslov, ime autora, cenu, Isbn i opis knjige iz baze i čuva ih u varijablama
                                bookInformation(rs);
                            } catch (SQLException e) {
                                System.out.println("Izuzetak: " + e.getMessage());
                            }
                        %>
                        
                        &nbsp;
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col-lg-11 col-md-11 col-sm-11">
                                <!-- pull-left mr-2 se koristi za razmak između slike i teksta -->
                                <a href="ShowBook"><img src="images/book_7.jpg" class="img-fluid  float-left pull-left mr-2" alt="slika sa knjigama" onclick="createCookieIndex(7)" title="slika sa knjigama"></a>
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <span class="pic_text"><%= sAuthor%></span><br/> <!-- autor -->
                                <% }
                                   if (!sTitle.equalsIgnoreCase("")) {
                                %>
                                    <span class="pic_text"><b><%= sTitle%></b></span><br/> <!-- naslov -->
                                <% } 
                                   if (!sPrice.equalsIgnoreCase("")) {
                                %>
                                    <span class="pic_text"><%= sPrice %> RSD</span><br/> <!-- cena -->
                                <% } %>
                            </div>
                            <div class="col-lg-1 col-md-1 col-sm-1 book_L">
                                &nbsp; 
                            </div>
                        </div> 
                       
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col-lg-6 col-md-6 col-sm-6">
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <div class="pic_text_below"><%= sAuthor%></div> <!-- autor -->
                                <% }
                                   if (!sTitle.equalsIgnoreCase("")) {
                                %>
                                    <div class="pic_text_below"><b><%= sTitle%></b></div> <!-- naslov -->
                                <% }
                                   if (!sPrice.equalsIgnoreCase("")) {
                                %>
                                    <div class="pic_text_below"><%= sPrice %> RSD</div> <!-- cena -->
                                <% } %> 
                            </div>
                        </div>
                        <br/>
                        
                        <%
                            try {    
                                // pročitaj podatke o knjizi i sačuvaj ih u result set-u rs
                                ResultSet rs = retrieveBookInf(8);
                                // čita naslov, ime autora, cenu, Isbn i opis knjige iz baze i čuva ih u varijablama
                                bookInformation(rs);
                            } catch (SQLException e) {
                                System.out.println("Izuzetak: " + e.getMessage());
                            }
                        %>
                        
                        &nbsp;
                        <div class="row"> <!-- adding a new row to the Bootstrap grid -->
                            <div class="col-lg-11 col-md-11 col-sm-11">
                                <!-- pull-left mr-2 se koristi za razmak između slike i teksta -->
                                <a href="ShowBook"><img src="images/book_8.jpg" class="img-fluid  float-left pull-left mr-2" alt="slika sa knjigama" onclick="createCookieIndex(8)" title="slika sa knjigama"></a>
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <span class="pic_text"><%= sAuthor%></span><br/> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) {
                                %>
                                    <span class="pic_text"><b><%= sTitle%></b></span><br/> <!-- naslov -->
                                <% } 
                                   if (!sPrice.equalsIgnoreCase("")) { 
                                %>
                                    <span class="pic_text"><%= sPrice %> RSD</span><br/> <!-- cena -->
                                <% } %>
                            </div>
                            <div class="col-lg-1 col-md-1 col-sm-1 book_L">
                                &nbsp; 
                            </div>
                        </div> 
                            
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col-lg-6 col-md-6 col-sm-6">
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <div class="pic_text_below"><%= sAuthor%></div> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) { 
                                %>
                                    <div class="pic_text_below"><b><%= sTitle%></b></div> <!-- naslov -->
                                <% } 
                                   if (!sPrice.equalsIgnoreCase("")) { 
                                %>
                                    <div class="pic_text_below"><%= sPrice %> RSD</div> <!-- cena -->
                                <% } %>    
                            </div>
                        </div>
                        <br/>
                        
                        <%
                            try {    
                                // pročitaj podatke o knjizi i sačuvaj ih u result set-u rs
                                ResultSet rs = retrieveBookInf(9);
                                // čita naslov, ime autora, cenu, Isbn i opis knjige iz baze i čuva ih u varijablama
                                bookInformation(rs);
                            } catch (SQLException e) {
                                System.out.println("Izuzetak: " + e.getMessage());
                            }
                        %>
                        
                        &nbsp;
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col-lg-11 col-md-11 col-sm-11">
                                <!-- pull-left mr-2 se koristi za razmak između slike i teksta -->
                                <a href="ShowBook"><img src="images/book_9.jpg" class="img-fluid  float-left pull-left mr-2" alt="slika sa knjigama" onclick="createCookieIndex(9)" title="slika sa knjigama"></a>
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <span class="pic_text"><%= sAuthor%></span><br/> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) { 
                                %>
                                    <span class="pic_text"><b><%= sTitle%></b></span><br/> <!-- naslov -->
                                <% } 
                                   if (!sPrice.equalsIgnoreCase("")) {
                                %>
                                    <span class="pic_text"><%= sPrice %> RSD</span><br/> <!-- cena -->
                                <% } %>
                            </div>
                            <div class="col-lg-1 col-md-1 col-sm-1 book_L">
                                &nbsp; 
                            </div>
                        </div>  
                        
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col-lg-6 col-md-6 col-sm-6">
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <div class="pic_text_below"><%= sAuthor%></div> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) { 
                                %>
                                    <div class="pic_text_below"><b><%= sTitle%></b></div> <!-- naslov -->
                                <% }
                                   if (!sPrice.equalsIgnoreCase("")) {
                                %>
                                    <div class="pic_text_below"><%= sPrice %> RSD</div> <!-- cena -->
                                <% } %>
                            </div>
                        </div>
                        <br/>
                        
                        <%
                            try {    
                                // pročitaj podatke o knjizi i sačuvaj ih u result set-u rs
                                ResultSet rs = retrieveBookInf(10);
                                // čita naslov, ime autora, cenu, Isbn i opis knjige iz baze i čuva ih u varijablama
                                bookInformation(rs);
                            } catch (SQLException e) {
                                System.out.println("Izuzetak: " + e.getMessage());
                            }
                        %>
                        &nbsp;
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col-lg-11 col-md-11 col-sm-11">
                                <!-- pull-left mr-2 se koristi za razmak između slike i teksta -->
                                <a href="ShowBook"><img src="images/book_10.jpg" class="img-fluid  float-left pull-left mr-2" alt="slika sa knjigama" onclick="createCookieIndex(10)" title="slika sa knjigama"></a>
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <span class="pic_text"><%= sAuthor%></span><br/> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) {
                                %>
                                    <span class="pic_text"><b><%= sTitle%></b></span><br/> <!-- naslov -->
                                <% }
                                   if (!sPrice.equalsIgnoreCase("")) {
                                %>
                                    <span class="pic_text"><%= sPrice %> RSD</span><br/> <!-- cena -->
                                <% } %>
                            </div>
                            <div class="col-lg-1 col-md-1 col-sm-1 book_L">
                                &nbsp; 
                            </div>
                        </div>
                            
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col-lg-6 col-md-6 col-sm-6">
                                <% if (!sAuthor.equalsIgnoreCase("")) { %>
                                    <div class="pic_text_below"><%= sAuthor%></div> <!-- autor -->
                                <% } 
                                   if (!sTitle.equalsIgnoreCase("")) {
                                %>
                                    <div class="pic_text_below"><b><%= sTitle%></b></div> <!-- naslov -->
                                <% }
                                   if (!sPrice.equalsIgnoreCase("")) {
                                %>
                                    <div class="pic_text_below"><%= sPrice %> RSD</div> <!-- cena -->
                                <% } %>
                            </div>
                        </div>
                        <br/>
                        
                        
                    </div> <!-- završetak class="container" -->
                </div> <!-- završetak class="col-lg-5 col-md-5" -->
            </div> <!-- završetak class="row" -->
        </div> <!-- završetak class="whitebckgr" -->
            
        <!-- dodavanje novog reda; klasa whitebckgr je za potavljanje pozadine u belu boju -->
        <div class="whitebckgr">
            <div class="col">
                &nbsp; &nbsp;
            </div>
        </div> 
        
        <%
            // ako emp_adm varijabla sesije postoji pročitaj je
            if (PticaMetodi.sessVarExists( hSession2, "emp_adm")) {
                String empadmS = (String)(hSession2.getAttribute("emp_adm"));
                Boolean emp = Boolean.valueOf(empadmS); 
                if (emp != true) { // prikaži modal ako korisnik prikazuje web sajtu za običnog kupca
        %>
                    <!-- bootstrap modal -->
                    <div class="modal fade" id="centeredModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="exampleModalCenterTitle">Ptica</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    ********************/ptica/zaposleni je veb sajta za zaposlene i administratore.
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-info" data-dismiss="modal">Zatvori</button>
                                </div>
                            </div>
                        </div>
                    </div>
        <%
                }
            }
        %>
    </body>
</html>