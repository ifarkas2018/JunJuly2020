<%-- 
    Dokument  : upd_del_form
    Formiran  : 13-Mar-2019, 11:36:48
    Autor     : Ingrid Farkaš
    Projekat  : Ptica    
--%>

<!-- upd_del_form.jsp - dodaje formular veb stranici Ažuriranje knjige -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="miscellaneous.PticaMetodi"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="connection.ConnectionManager"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">        
        <script src="javascript/validationJS.js"></script>
        
        <style>            
            input:disabled, textarea:disabled, select:disabled {
                background-color: white !important;
            }
        </style>
        
        <script>
            
            NUM_FIELDS = 11; // maksimum broj polja na ovom i prethodnim formularima             
            START = 3; 
           
            // setCookie: kreira kolaċić inputI = vrednost u input polju ; (I - broj 3..11)
            function setCookie() {
                var i;
                var inp_names = new Array('title', 'author', 'isbn', 'price', 'pages', 'category', 'descr', 'publisher', 'yrpublished'); // names of the input fields
                // kolaċići sa imenima input0, input1, input2 sam kreirala u upd_del_title.jsp
                for (i = START; i <= NUM_FIELDS; i++) {
                    if (i === 6) { // kreiranje kolaċića koji sadrži cenu
                        strWithDot = document.getElementById(inp_names[i-3]).value; 
                        strWithDot = strWithDot.replace('.','!');
                        strWithDot = strWithDot.replace(',','.');
                        document.cookie = "input" + i + "=" + strWithDot + ";"; // kreiranje kolaċića
                    } else {
                        document.cookie = "input" + i + "=" + document.getElementById(inp_names[i-3]).value + ";"; // kreiranje kolaċića
                    }    
                } 
            }
            
            // setDefaults : postavlja vrednosti kolaċića ( sa imenima input0, input1, input2 ) na inicijalnu vrednost i
            // zapisuje sadržaj svakog input polja u kolaċić
            function setDefaults() {              
                var i;
                
                for (i = START; i <= NUM_FIELDS; i++) {
                    document.cookie = "input" + i + "= "; // postavljanje VREDNOSTI kolaċića na PRAZNO
                }
                setCookie(); // za svako input polje zapisuje vrednost sadržaja tog polja u kolaċić
            }
            
        </script>
        
        <%
            HttpSession hSession2 = PticaMetodi.returnSession(request);    
            String source = (String)hSession2.getAttribute("source_name"); // stranica na kojoj sam sada
        %>
        
        <title>Ptica - <%= source %> </title>
    </head>
    
    <body onload="setDefaults()">
        <%
            final String PAGE_NAME = "upd_del_page.jsp"; // stranica na kojoj sam sada
        %>
        <%                                  
            String input3 = ""; // vrednost koja je prethodno bila u input polju title da bi ponovo bila prikazana
            String input4 = "";
            String input5 = "";
            String input6 = "";
            String input7 = "";
            String input8 = "";
            String input9 = "";
            String input10 = "";
            String input11 = "";
            
            String title = ""; // za prikazivanje sloga koji se ažurira
            String au_name = "";
            String isbn = "";
            String price = "";
            String pages = "";
            String descr = "";
            String publ_name = ""; 
            String publ_year = "";
            String category = "";
            
            // IDEJA : fill_in je postavljena u SubscrServl.java - true ako su neke od varijabli sesije ( u input polju ) 
            // bile postavljene i one treba da se dodaju ovde obrazcu - ovo je taċno ako je korisnik PRE PRIKAZAO OVU STRANICU
            // i posle toga je uneo email u prijavi za Newsletter (u footer-u) i na sledećoj stranici je kliknuo na Zatvori
            if (PticaMetodi.sessVarExists(hSession2, "fill_in")) { 
                String fill_in = String.valueOf(hSession2.getAttribute("fill_in")); 
                
                // postavljanje vrednosti varijable sesije page_name. Ako je korisnik kliknuo na dugme Prijavite se i posle toga ako je na veb
                // stranici subscrres_content kliknuo na Zatvori dugme, onda se ova veb stranica ponovo prikazuje
                if (PticaMetodi.sessVarExists(hSession2, "page_name")) { 
                    String page_name = String.valueOf(hSession2.getAttribute("page_name"));
                    
                    // Ako je korisnik kliknuo na Zatvori dugme na veb stranici subscrres_content i ako je ova stranica bila prikazana 
                    // pre ( page_name ) i ako su neke vrednosti saċuvane u varijablama sesije input tada proċitaj varijablu sesije
                    // input3..input11 da bi se prikazala u input polju title ( i drugim poljima )
                    if ((page_name.equalsIgnoreCase(PAGE_NAME)) && (fill_in.equalsIgnoreCase("true"))) {
                        if (PticaMetodi.sessVarExists(hSession2, "input3")) {
                            input3 = String.valueOf(hSession2.getAttribute("input3")); // vrednost koja je bila u ovom polju
                        } 
                        if (PticaMetodi.sessVarExists(hSession2, "input4")) {
                            input4 = String.valueOf(hSession2.getAttribute("input4"));
                        } 
                        if (PticaMetodi.sessVarExists(hSession2, "input5")) {
                            input5 = String.valueOf(hSession2.getAttribute("input5"));
                        }
                        if (PticaMetodi.sessVarExists(hSession2, "input6")) {
                            input6 = String.valueOf(hSession2.getAttribute("input6")); // vrednost koja je bila u ovom polju
                        } 
                        if (PticaMetodi.sessVarExists(hSession2, "input7")) {
                            input7 = String.valueOf(hSession2.getAttribute("input7"));
                        } 
                        if (PticaMetodi.sessVarExists(hSession2, "input8")) {
                            input8 = String.valueOf(hSession2.getAttribute("input8"));
                        } 
                        if (PticaMetodi.sessVarExists(hSession2, "input9")) {
                            input9 = String.valueOf(hSession2.getAttribute("input9")); // vrednost koja je bila u ovom polju
                        } 
                        if (PticaMetodi.sessVarExists(hSession2, "input10")) {
                            input10 = String.valueOf(hSession2.getAttribute("input10"));
                        } 
                        if (PticaMetodi.sessVarExists(hSession2, "input11")) {
                            input11 = String.valueOf(hSession2.getAttribute("input11"));
                        } 
                        PticaMetodi.setToEmptyInput(hSession2); // setToEmptyInput: postavlja vrednosti varijabli sesije na "" za varijable input0, input1, ...
                    }
                }
                hSession2.setAttribute("fill_in", "false"); // input polja ne treba da budu popunjena
            }
            PticaMetodi.setToEmptyInput(hSession2); // setToEmptyInput: postavlja vrednosti varijabla sesije na "" za varijable input0, input1, ...
            hSession2.setAttribute("page_name", PAGE_NAME);
        %>
        
        <%
            hSession2.setAttribute("webpg_name", "upd_del_page.jsp");
            // ako je korisnik sada završio prijavu za Newsletter, obrazac na sledećoj veb stranici ne treba da prikaže prethdne vrednosti
            hSession2.setAttribute("subscribe", "false");
            
            Connection con = ConnectionManager.getConnection(); // povezivanje sa bazom 
            Statement stmt = con.createStatement();
            
            String sQuery = "select b.title, b.price, b.isbn, b.pages, b.publ_year, b.descr, b.category, a.au_name, p.publ_name from book b, author a, publisher p where b.au_id = a.au_id and b.publ_id = p.publ_id";
            // previous_title: da li naslov knjige već postiji u bazi
            String previous_title = (String)hSession2.getAttribute("prev_title"); // čitanje naslova iz varijable sesije (upd_del_title.jsp)
            // previous_auth: da li autor knjige već postiji u bazi
            String previous_auth = (String)hSession2.getAttribute("prev_auth"); // čitanje autora ( iz varijable sesije )
            // previous_isbn: da li isbn knjige već postiji u bazi
            String previous_isbn = (String)hSession2.getAttribute("prev_isbn"); // čitanje Isbn ( iz varijable sesije )
            
            if (!((previous_title.equalsIgnoreCase("")))) {
                sQuery += " and b.title='" + previous_title + "'";
            }
            
            if (!((previous_auth.equalsIgnoreCase("")))) {
                sQuery += " and a.au_name='" + previous_auth + "'";
            }
            
            if (!((previous_isbn.equalsIgnoreCase("")))) {
                sQuery += " and b.isbn='" + previous_isbn + "'";
            }
            
            sQuery += ";";
            
            // izvršavanje upita
            ResultSet rset = stmt.executeQuery(sQuery); 

             // ako sledeći slog postoji
            if (rset.next()) {
                title = rset.getString("title"); // pročitaj naslov iz rset-a
                if (title == null) {
                    title = "";
                }
                
                au_name = rset.getString("au_name"); // pročitaj au_name iz rset-a
                if (au_name == null) {
                    au_name = "";
                }
                
                isbn = rset.getString("isbn"); // pročitaj isbn iz rset-a
                if (isbn == null) {
                    isbn = "";
                }
                
                price = rset.getString("price"); // pročitaj price iz rset-a
                if (price == null) {
                    price = "";
                } else {
                    // u bazi cena je prikazana u obliku 99999.99; u formularu cena treba da bude prikazana u obliku 99.999,99
                    price = price.replace('.',','); // zameni . sa ,
                    price = PticaMetodi.dodajTacku(price); // dodajem tačku u cenu iza hiljadu dinara 
                }
                
                pages = rset.getString("pages"); // pročitaj pages iz rset-a
                if (pages == null) {
                    pages = "";
                }
                
                category = rset.getString("category"); // pročitaj category iz rset-a
                if (category == null) {
                    category = "";
                }
                
                descr = rset.getString("descr"); // pročitaj descr iz rset-a
                if (descr == null) {
                    descr = "";
                }
                
                publ_name = rset.getString("publ_name"); // pročitaj publ_name iz rset-a
                if (publ_name == null) {
                    publ_name = "";
                }
                
                publ_year = rset.getString("publ_year"); // pročitaj publ_year iz rset-a
                if (publ_year == null) {
                    publ_year = "";
                }
            }
        %>   
            
        <!-- dodavanje novog reda u Bootstrap grid: klasa whitebckgr postavlja pozadinu u belu boju -->
        <div class="whitebckgr">
            <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                <!-- Bootstrap kolona zauzima 6 kolona na velikim desktopovima i 6 kolona na desktopovima srednje veliċine -->
                <div class="col-lg-6 col-md-6"> 
                    <br /><br />
                    <div>
                        <!-- center-image postavlja sliku u sredinu ( horizontalno ), img-fluid je za responsivan image -->
                        <img src="images/books.png" class="img-fluid center-image" alt="slika sa knjigama" title="slika sa knjigama"> 
                    </div>
                    <br /><br />
                    <div> 
                        <!-- center-image postavlja sliku u sredinu ( horizontalno ), img-fluid je za responsivan image -->
                        <img src="images/books.png" class="img-fluid center-image" alt="slika sa knjigama" title="slika sa knjigama"> 
                    </div>
                </div>
                
                <!-- Bootstrap kolona zauzima 5 kolona na velikim desktopovima i 5 kolona na desktopovima srednje veliċine -->
                <div class="col-lg-5 col-md-5"> 
                    <div class="container"> <!-- dodavanje kontejnera u Bootstrap grid -->
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col">
                                &nbsp; &nbsp;
                                <br />
                               
                                <!-- Update -->
                                <% if (source.equals("Ažuriranje knjige")) {
                                %>
                                    <h3 class="text-info">Ažuriranje knjige</h3>
                                <%
                                   } else if (source.equals("Brisanje knjige")) {
                                %>
                                    <!-- Brisanje knjige -->
                                    <h3 class="text-info">Brisanje knjige</h3>
                                <%
                                   }
                                %>
                                
                                <br />
                             
                                <% if (source.equals("Ažuriranje knjige")) {
                                %>
                                    <!-- posle klika na dugme prikazuje se updateDB.jsp -->
                                    <form id="upd_del_book" name="upd_del_book" action="updateDB.jsp" onsubmit="return checkForm();" method="post">
                                <%
                                    } else if (source.equals("Brisanje knjige")) {
                                %>
                                     <!-- posle klika na dugme prikazuje se DelServlet -->
                                     <form id="upd_del_book" name="upd_del_book" action="DelServlet" onsubmit="return checkForm();" method="post">
                                <%
                                    }
                                %>
                                    <!-- input kontrola za naslov -->
                                    <div class="form-group">
                                        <label for="title">Naslov</label> 
                                        <% if (source.equals("Ažuriranje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input3.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control form-control-sm" name="title" id="title" maxlength="60" onchange="setCookie()" value="<%= input3 %>"> 
                                                <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" name="title" id="title" maxlength="60" onchange="setCookie()" value="<%= title %>"> 
                                            <% } 
                                            %>
                                        <%
                                           } else if (source.equals("Brisanje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input3.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="title" id="title" maxlength="60" onchange="setCookie()" value="<%= input3 %>"> 
                                                <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="title" id="title" maxlength="60" onchange="setCookie()" value="<%= title %>"> 
                                            <% } 
                                            %>
                                        <%
                                           }
                                        %>
                                    </div>
                                    
                                    <!-- input kontrola za autora -->
                                    <div class="form-group">
                                        <label for="author">Autor</label>
                                        <% if (source.equals("Ažuriranje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input4.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control form-control-sm" name="author" id="author" maxlength="70" onchange="setCookie()" onfocusout="valLetters(document.upd_del_book.author, author_message, 'fullname', false, 'false');" value="<%= input4 %>"> <!-- author input field -->
                                            <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" name="author" id="author" maxlength="70" onchange="setCookie()" onfocusout="valLetters(document.upd_del_book.author, author_message, 'fullname', false, 'false');" value="<%= au_name %>"> <!-- author input field -->
                                            <% }
                                            %>
                                        <%
                                           } else if (source.equals("Brisanje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input4.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="author" id="author" maxlength="70" value="<%= input4 %>"> <!-- author input field -->
                                            <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="author" id="author" maxlength="70" value="<%= au_name %>"> <!-- author input field -->
                                            <% }
                                            %>
                                        <% 
                                           } 
                                        %>
                                        <span id="author_message" class="text_size text-danger"></span>
                                    </div>
                
                                    <!-- input kontrola za Isbn -->
                                    <div class="form-group">
                                        <label for="isbn">Isbn</label> 
                                        <% if (source.equals("Ažuriranje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input5.equalsIgnoreCase("")) { %>
                                                <!-- isbn input kontrola : može se uneti do 13 karaktera -->
                                                <input type="text" class="form-control form-control-sm" maxlength="13" name="isbn" id="isbn" maxlength="13" onchange="setCookie()" onfocusout='isNumber("upd_del_book", "isbn", "is_isbn", "isbn_message", false, false)' value="<%= input5 %>"> 
                                            <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" maxlength="13" name="isbn" id="isbn" maxlength="13" onchange="setCookie()" onfocusout='isNumber("upd_del_book", "isbn", "is_isbn", "isbn_message", false, false)' value="<%= isbn %>"> 
                                            <% } %>
                                        <%
                                           } else if (source.equals("Brisanje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input5.equalsIgnoreCase("")) { %>
                                                <!-- isbn input kontrola : može se uneti do 13 karaktera -->
                                                <input type="text" class="form-control form-control-sm" disabled maxlength="13" name="isbn" id="isbn" maxlength="13" value="<%= input5 %>"> 
                                            <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" disabled maxlength="13" name="isbn" id="isbn" maxlength="13" value="<%= isbn %>"> 
                                            <% } %>
                                        <% 
                                           } 
                                        %>
                                        <span id="isbn_message" class="text_size text-danger"></span>
                                    </div>
                                        
                                    <!-- input kontrola za cenu -->
                                    <div class="form-group">
                                        <label for="price">Cena</label> 
                                        <% if (source.equals("Ažuriranje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input6.equalsIgnoreCase("")) {
                                                input6 = input6.replace('.', ','); // u kolačiću se umesto , pojavljuje .
                                                input6 = input6.replace('!','.');
                                            %>
                                                <input type="text" class="form-control form-control-sm" name="price" id="price" maxlength="9" onchange="setCookie()" onfocusout='daLiJeCena("upd_del_book", "price", "is_price", "price_message")' value="<%= input6 %>"> 
                                            <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" name="price" id="price" maxlength="9" onchange="setCookie()" onfocusout='daLiJeCena("upd_del_book", "price", "is_price", "price_message")' value="<%= price %>"> 
                                            <% } %>
                                        <%
                                           } else if (source.equals("Brisanje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input6.equalsIgnoreCase("")) { 
                                                input6 = input6.replace('.', ','); // u kolačiću se umesto , pojavljuje .
                                                input6 = input6.replace('!','.');
                                            %>
                                                <input type="text" class="form-control form-control-sm" disabled name="price" id="price" maxlength="9" value="<%= input6 %>"> 
                                            <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="price" id="price" maxlength="9" value="<%= price %>"> 
                                            <% } %>
                                        <% 
                                           } 
                                        %>
                                        <span id="price_message" class="text_size text-danger"></span>
                                    </div>
                                        
                                    <!-- input kontrola za broj strana -->
                                    <div class="form-group">
                                        <label for="pages">Broj strana</label>
                                        <% if (source.equals("Ažuriranje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input7.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control form-control-sm" name="pages" id="pages" maxlength="4" onchange="setCookie()" onfocusout='isNumber("upd_del_book", "pages", "is_pages", "pages_message", false, false)' value="<%= input7 %>"> 
                                            <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" name="pages" id="pages" maxlength="4" onchange="setCookie()" onfocusout='isNumber("upd_del_book", "pages", "is_pages", "pages_message", false, false)' value="<%= pages %>"> 
                                            <% } %>
                                        <%
                                           } else if (source.equals("Brisanje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input7.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control berform-control-sm" disabled name="pages" id="pages" maxlength="4" value="<%= input7 %>"> 
                                            <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="pages" id="pages" maxlength="4" value="<%= pages %>"> 
                                            <% } %>
                                        <% 
                                           } 
                                        %>
                                        <span id="pages_message" class="text_size text-danger"></span>
                                    </div>
                                        
                                    <!-- padajuća lista za žanrove -->
                                    <div class="form-group"> 
                                        <label for="category">Žanrovi</label> 
                                        <% if (source.equals("Ažuriranje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input8.equalsIgnoreCase("")) { %>
                                                <!-- kreiranje padajuće liste; form-control-sm se koristi za užu kontrolu -->
                                                <select  class="form-control form-control-sm" name="category" id="category" onchange="setCookie()">
                                                    <% if (input8.equalsIgnoreCase("all")) { %>
                                                        <option value="all" selected>Svi žanrovi</option> <!-- opcije prikazana u padajućoj listi -->
                                                    <% } else { %>
                                                        <option value="all">Svi žanrovi</option>
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("fict")) { %>
                                                        <option value="fict" selected>Romani</option> 
                                                    <% } else { %>
                                                        <option value="fict">Romani</option>   
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("bus")) { %>
                                                        <option value="bus" selected>Biznis i ekonomija</option> 
                                                    <% } else { %>
                                                        <option value="bus">Biznis i ekonomija</option>      
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("comp")) { %>
                                                        <option value="comp" selected>Internet i računari</option> 
                                                    <% } else { %>
                                                        <option value="comp">Internet i računari</option>  
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("edu")) { %>
                                                        <option value="edu" selected>Edukativni</option> 
                                                    <% } else { %>
                                                        <option value="edu">Edukativni</option>   
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("child")) { %>
                                                        <option value="child" selected>Knjige za decu</option> 
                                                    <% } else { %>
                                                        <option value="child">Knjige za decu</option>  
                                                    <% } %>
                                                </select>
                                            <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <!-- kreiranje padajuće liste; form-control-sm se koristi za užu kontrolu -->
                                                <select class="form-control form-control-sm" name="category" id="category" onchange="setCookie()">
                                                    <% if (category.equalsIgnoreCase("all")) { %>
                                                        <option value="all" selected>Svi žanrovi</option> <!-- opcije prikazana u padajućoj listi -->
                                                    <% } else { %>
                                                        <option value="all">Svi žanrovi</option>
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("fict")) { %>
                                                        <option value="fict" selected>Romani</option> 
                                                    <% } else { %>
                                                        <option value="fict">Romani</option>   
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("bus")) { %>
                                                        <option value="bus" selected>Biznis i ekonomija</option> 
                                                    <% } else { %>
                                                        <option value="bus">Biznis i ekonomija</option>      
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("comp")) { %>
                                                        <option value="comp" selected>Internet i računari</option> 
                                                    <% } else { %>
                                                        <option value="comp" >Internet i računari</option>  
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("edu")) { %>
                                                        <option value="edu" selected>Edukativni</option> 
                                                    <% } else { %>
                                                        <option value="edu">Edukativni</option>   
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("child")) { %>
                                                        <option value="child" selected>Knjige za decu</option> 
                                                    <% } else { %>
                                                        <option value="child">Knjige za decu</option>  
                                                    <% } %>
                                                </select>
                                            <% } %>
                                        <%
                                           } else if (source.equals("Brisanje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input8.equalsIgnoreCase("")) { %>
                                                <!-- kreiranje padajuće liste; form-control-sm se koristi za užu kontrolu -->
                                                <select  class="form-control form-control-sm" disabled name="category" id="category">
                                                    <% if (input8.equalsIgnoreCase("all")){ %>
                                                        <option value="all" selected>Svi žanrovi</option> <!-- opcije prikazana u padajućoj listi -->
                                                    <% } else { %>
                                                        <option value="all">Svi žanrovi</option>
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("fict")) { %>
                                                        <option value="fict" selected>Romani</option> 
                                                    <% } else { %>
                                                        <option value="fict">Romani</option>   
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("bus")) { %>
                                                        <option value="bus" selected>Biznis i ekonomija</option> 
                                                    <% } else { %>
                                                        <option value="bus">Biznis i ekonomija</option>      
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("comp")) { %>
                                                        <option value="comp" selected>Internet i računari</option> 
                                                    <% } else { %>
                                                        <option value="comp">Internet i računari</option>  
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("edu")) { %>
                                                        <option value="edu" selected>Edukativni</option> 
                                                    <% } else { %>
                                                        <option value="edu">Edukativni</option>   
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("child")) { %>
                                                        <option value="child" selected>Knjige za decu</option> 
                                                    <% } else { %>
                                                        <option value="child">Knjige za decu</option>  
                                                    <% } %>
                                                </select>
                                            <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <!-- kreiranje padajuće liste; form-control-sm se koristi za užu kontrolu -->
                                                <select class="form-control form-control-sm" disabled name="category" id="category">
                                                    <% if (category.equalsIgnoreCase("all")) { %>
                                                        <option value="all" selected>Svi žanrovi</option> <!-- opcije prikazana u padajućoj listi -->
                                                    <% } else { %>
                                                        <option value="all">Svi žanrovi</option>
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("fict")) { %>
                                                        <option value="fict" selected>Romani</option> 
                                                    <% } else { %>
                                                        <option value="fict">Romani</option>   
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("bus")) { %>
                                                        <option value="bus" selected>Biznis i ekonomija</option> 
                                                    <% } else { %>
                                                        <option value="bus">Biznis i ekonomija</option>      
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("comp")) { %>
                                                        <option value="comp" selected>Internet i računari</option> 
                                                    <% } else { %>
                                                        <option value="comp" >Internet i računari</option>  
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("edu")) { %>
                                                        <option value="edu" selected>Edukativni</option> 
                                                    <% } else { %>
                                                        <option value="edu">Edukativni</option>   
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("child")) { %>
                                                        <option value="child" selected>Knjige za decu</option> 
                                                    <% } else { %>
                                                        <option value="child">Knjige za decu</option>  
                                                    <% } %>
                                                </select>

                                            <% } %>
                                        <% 
                                           } 
                                        %>    
                                    </div>
                                        
                                    <!-- kreiranje oblasti za tekst za opis knjige -->
                                    <div class="form-group">
                                        <label for="descr">Opis</label>
                                        <% if (source.equals("Ažuriranje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input9.equalsIgnoreCase("")) { %>
                                                <textarea class="form-control" name="descr" id="descr" rows="4" onchange="setCookie()"><%= input9 %></textarea>
                                            <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <textarea class="form-control" name="descr" id="descr" rows="4" onchange="setCookie()"><%= descr %></textarea>
                                            <% } %>
                                        <%
                                           } else if (source.equals("Brisanje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input9.equalsIgnoreCase("")) { %>
                                                <textarea class="form-control" disabled name="descr" id="descr" rows="4"><%= input9 %></textarea>
                                            <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <textarea class="form-control" disabled name="descr" id="descr" rows="4"><%= descr %></textarea>
                                            <% } %>
                                        <% 
                                           } 
                                        %>
                                    </div>
                                        
                                    <!-- kreiranje input kontrole za izdavača -->
                                    <div class="form-group">
                                        <label for="publisher">Izdavač</label> 
                                        <% if (source.equals("Ažuriranje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input10.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control form-control-sm" name="publisher" id="publisher" maxlength="40" onchange="setCookie()" value="<%= input10 %>"> 
                                            <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" name="publisher" id="publisher" maxlength="40" onchange="setCookie()" value="<%= publ_name %>"> 
                                            <% } %>
                                        <%
                                           } else if (source.equals("Brisanje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input10.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="publisher" id="publisher" maxlength="40" value="<%= input10 %>"> 
                                            <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="publisher" id="publisher" maxlength="40" value="<%= publ_name %>"> 
                                            <% } %>
                                        
                                        <% 
                                           } 
                                        %>
                                    </div>
                                    
                                    <!-- kreiranje input kontrole za godinu izdavanja -->
                                    <div class="form-group">
                                        <label for="yrpublished">Godina izdavanja</label>
                                        <% if (source.equals("Ažuriranje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input11.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control form-control-sm" name="yrpublished" id="yrpublished" maxlength="4" onchange="setCookie()" onfocusout='isNumber("upd_del_book", "yrpublished", "is_yrpubl", "yrpubl_message", false, false)' value="<%= input11 %>"> 
                                            <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" name="yrpublished" id="yrpublished" maxlength="4" onchange="setCookie()" onfocusout='isNumber("upd_del_book", "yrpublished", "is_yrpubl", "yrpubl_message", false, false)' value="<%= publ_year %>"> 
                                            <% } %>
                                        <%
                                           } else if (source.equals("Brisanje knjige")) {
                                        %>
                                            <!-- ako se korisnik prijavio za Newsletter prikaži vrednosti sa forme pre prijavljivanja -->
                                            <% if (!input11.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="yrpublished" id="yrpublished" maxlength="4" value="<%= input11 %>"> 
                                            <!-- inače pročitaj slog iz baze i prikaži ga -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="yrpublished" id="yrpublished" maxlength="4" value="<%= publ_year %>"> 
                                            <% } %>
                                        <% 
                                           } 
                                        %>
                                        <span id="yrpubl_message" class="text_size text-danger"></span>
                                    </div> 
                                        
                                    <div class="container">
                                        <div class="row">
                                            <div class="col">
                                                &nbsp; &nbsp; <!-- dodavanje praznog prostora -->
                                            </div>
                                        </div>    
                                    </div>
                                    
                                    <% if (source.equals("Ažuriranje knjige")) {
                                    %>
                                        <!-- btn-sm se koristi za manju ( užu ) veličinu kontrole -->
                                        <button type="submit" id="btnSubmit" class="btn btn-info btn-sm">Ažuriranje knjige</button>
                                    <%
                                        } else if (source.equals("Brisanje knjige")) {
                                    %>
                                        <!-- btn-sm se koristi za manju ( užu ) veličinu kontrole -->
                                        <button type="submit" id="btnSubmit" class="btn btn-info btn-sm">Brisanje knjige</button>
                                    <%
                                        }
                                    %>
                                  
                                    <div class="container">
                                        <div class="row">
                                            <div class="col">
                                                &nbsp; &nbsp; <!-- dodavanje praznog prostora -->
                                            </div>
                                        </div>    
                                    </div> 
                                </form>  
                            </div> <!-- završetak class="col" -->
                        </div> <!-- završetak class="row" --> 
                    </div> <!-- završetak class="container" -->
                </div> <!-- završetak class="col-lg-5 col-md-5" -->
            </div> <!-- završetak class="row" -->
        </div> <!-- završetak class="whitebckgr" -->
            
        <!-- dodajem novi red u Bootstrap grid; klasa whitebckgr: za postavljanje pozadine u belu boju -->
        <div class="whitebckgr">
            <div class="col">
                &nbsp; &nbsp;
            </div>
        </div> 
        </div>   
    </body>
</html>