<%-- 
    Dokument   : upd_del_title koji se poziva iz update_prev.jsp, delete_title.jsp
    Formiran   : 14-Mar-2019, 04:27:45
    Autor      : Ingrid Farkaš
    Projekat   : Ptica
--%>

<!-- upd_del_title.jsp - prikazuje obrazac za unošenje naslova, autora, Isbn-a knjige čiji se podaci ažuriraju ( ili brišu ) -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="miscellaneous.PticaMetodi"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="javascript/validationJS.js"></script>
        
        <script>
            NUM_FIELDS = 3; // broj polja na obrazacu 
            NAME_VALIDATION  = 'true'; // da li polje Autor sadrži samo slova ( i apostrof )
            NUM_VALIDATION  = 'true'; // da li polje Isbn sadrži samo cifre
            
            // setCookie: kreira kolaċić inputI = vrednost u input polju ; (I - broj 0..2)
            function setCookie() {           
                var i;
                var inp_names = new Array('prev_title', 'prev_author', 'prev_isbn'); // names of the input fields
                
                for ( i = 0; i < NUM_FIELDS; i++ ) {
                    document.cookie = "input" + i + "=" + document.getElementById(inp_names[i]).value + ";"; // kreiranje kolaċića
                } 
            }
            
            // setDefaults : postavlja vrednosti kolaċića ( sa imenima input0, input1, input2 ) na inicijalnu vrednost i
            // piše sadržaj svakog input polja u kolaċić
            function setDefaults() {
                var i;
                for (i = 0; i < NUM_FIELDS; i++) {
                    document.cookie = "input" + i + "= "; // postavljanje VREDNOSTI kolaċića na PRAZNO
                }
                setCookie(); // za svako input polje zapisuje vrednost sadržaja tog polja u kolaċić
            } 
        </script>
        
        <%
            HttpSession hSession2 = PticaMetodi.returnSession(request);            
            String source = (String)hSession2.getAttribute("source_name"); // stranica na kojoj sam sada
        %>
        
        <title>Ptica - <%= source %></title>
    </head>
  
    <body onload="setDefaults()">
        <%
            final String PAGE_NAME = "update_prev.jsp"; // stranica na kojoj sam sada
            // webpg_name: ime stranice kojoj se treba vratiti ako je korisnik uneo email ( Newsletter ) 
            if (source.equals("Ažuriraj knjigu")) {
                hSession2.setAttribute("webpg_name", "update_prev.jsp");
            } else if (source.equals("Brisanje knjige")) {
                hSession2.setAttribute("webpg_name", "delete_title.jsp");
            }
            // ako je korisnik sada završio prijavu na Newsletter, obrazac na sledećoj veb stranici NE TREBA da prikaže prethdne vrednosti
            hSession2.setAttribute("subscribe", "false");
        %>
        
        <!-- dodavanje novog reda u Bootstrap grid: klasa whitebckgr postavlja pozadinu u belo -->
        <div class="whitebckgr">
            <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                <!-- Bootstrap kolona zauzima 6 kolona na velikim desktopovima i 6 kolona na desktopovima srednje veliċine -->
                <div class="col-lg-6 col-md-6"> 
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
                                <br/>
                                <% 
                                    out.print("<h3 class=\"text-info\">" + source + "</h3>"); // source je Ažuriraj knjigu ( za Ažuriranje ), ili Brisanje knjige ( za Brisanje )                                  
                                %>
                               
                                <br />
                                
                                <form id="upd_del_book" name="upd_del_book" action="upd_del_page.jsp" onsubmit="return checkForm();" method="post">
                                    <%           
                                        String input0 = ""; // pročitaj vrednost koja je prethodno bila u input polju prev_title da bi ponovo bila prikazana
                                        String input1 = ""; // pročitaj vrednost koja je prethodno bila u input polju prev_author da bi ponovo bila prikazana
                                        String input2 = ""; // pročitaj vrednost koja je prethodno bila u input polju prev_isbn da bi ponovo bila prikazana      
                                        
                                        // IDEJA : fill_in je postavljena u SubscrServl.java - true ako su neke od varijabli sesije ( u input polju ) 
                                        // bile postavljene i one treba da se dodaju ovde obrazcu - ovo je taċno ako je korisnik PRE PRIKAZAO OVU STRANICU
                                        //  i posle toga je uneo email u prijavi za Newsletter (u footer-u) i na sledećoj stranici je kliknuo na Zatvori
                                        if (PticaMetodi.sessVarExists(hSession2, "fill_in")) { 
                                            String fill_in = String.valueOf(hSession2.getAttribute("fill_in")); 
                                            // Postavljanje vrednosti varijable sesije page_name. Ako je korisnik kliknuo dugme Prijavite se i posle toga ako je na veb
                                            // stranici subscrres_content kliknuo na Zatvori dugme, onda se ova veb stranica ponovo prikazuje
                                            if (PticaMetodi.sessVarExists(hSession2, "page_name")) { 
                                                String page_name = String.valueOf(hSession2.getAttribute("page_name"));
                                                // Ako je korisnik kliknuo na Zatvori dugme na veb stranici subscrres_content i ako je ova stranica bila prikazana 
                                                // pre ( page_name ) i ako su neke vrednosti saċuvane u varijablama sesije input tada proċitaj varijablu sesije 
                                                // input0 ( da bi se prikazala u prvom polju ) 
                                                if ((page_name.equalsIgnoreCase(PAGE_NAME)) && (fill_in.equalsIgnoreCase("true"))) {
                                                    if (PticaMetodi.sessVarExists(hSession2, "input0")) {
                                                        input0 = String.valueOf(hSession2.getAttribute("input0")); // vrednost koja je bila u PRVOM polju
                                                    } 
                                                    if (PticaMetodi.sessVarExists(hSession2, "input1")) {
                                                        input1 = String.valueOf(hSession2.getAttribute("input1")); // vrednost koja je bila u DRUGOM polju
                                                    } 
                                                    if (PticaMetodi.sessVarExists(hSession2, "input2")) {
                                                        input2 = String.valueOf(hSession2.getAttribute("input2")); // vrednost koja je bila u TREĆEM polju
                                                    } 
                                                } 
                                            }
                                            hSession2.setAttribute("fill_in", "false"); // input polja ne treba da budu ispunjena
                                        } 

                                        // saċuvaj ime stranice gde sam sada u sluċaju da korisnik klikne na Prijavite se dugme u footer-u
                                        hSession2.setAttribute("page_name", PAGE_NAME);
                                        PticaMetodi.setToEmptyInput(hSession2); // setToEmptyInput: postavlja vrednosti varijabla sesije na "" za varijable input0, input1, ...
                                    %>


                                    <!-- input kontrola za naslov -->
                                    <div class="form-group">
                                        <label for="prev_title">Naslov  <span class="text_size text-danger">*</span></label> <!-- title label -->
                                        <!-- unošenje naslova je obavezno -->
                                        <input type="text" class="form-control form-control-sm" name="prev_title" id="prev_title" maxlength="60" onchange="setCookie()" onfocusout='setFocus("upd_del_book", "prev_title")' required value="<%= input0 %>" > 
                                    </div>

                                    <!-- input kontrola za autora -->
                                    <div class="form-group">
                                        <label for="prev_author">Autor</label> 
                                        <input type="text" class="form-control form-control-sm" name="prev_author" id="prev_author" maxlength="70" onfocusout="setCookie();valLetters(document.upd_del_book.prev_author, author_message, 'fullname', false, 'false');" value="<%= input1 %>" >  
                                        <span id="author_message" class="text_size text-danger"></span>
                                    </div>

                                    <!-- input kontrola za Isbn -->
                                    <div class="form-group"> 
                                        <label for="prev_isbn">Isbn</label> 
                                        <input type="text" class="form-control form-control-sm" maxlength="13" name="prev_isbn" id="prev_isbn" onchange="setCookie()" onfocusout='isNumber("upd_del_book", "prev_isbn", "is_isbn", "isbn_message", false, false)' value="<%= input2 %>" > 
                                        <span id="isbn_message" class="text_size text-danger"></span>
                                    </div>    

                                    <!-- dodavanje novog kontejnera -->
                                    <div class="container">
                                        <div class="row">
                                            <div class="col">
                                                &nbsp; &nbsp; <!-- dodavanje praznog prostora -->
                                            </div>
                                        </div>    
                                    </div>

                                    <button type="submit" id="btnSubmit" class="btn btn-info btn-sm">Pošalji</button>

                                    <!-- dodavanje novog kontejnera -->
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
            
        <!-- dodavanje novog reda u Bootstrap grid; klasa whitebckgr: postavljanje pozadine u belu boju -->
        <div class="whitebckgr">
            <div class="col">
                &nbsp; &nbsp;
            </div>
        </div>    
    </body>
</html>