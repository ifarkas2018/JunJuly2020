<%-- 
    Dokument  : search_form.jsp
    Formiran  : 18-Sep-2018, 01:33:11
    Autor     : Ingrid Farkaš
    Projekat  : Ptica
--%>

<!-- search_form.jsp - obrazac na veb stranici Pretraga knjiga -->

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="miscellaneous.PticaMetodi"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ptica - Pretraga knjiga</title>
        
        <script src="javascript/validationJS.js"></script>
        
        <script>
            NUM_FIELDS = 7; // broj input kontrola na obrazcu
            INPUT_FIELDS = 12;  
        
            // setCookie:  kreira kolaċić inputI = vrednost u input polju ; (I - broj 0..6)
            function setCookie() {           
                var i;
                var inp_names = new Array('title', 'author', 'isbn', 'price_range', 'sortby', 'categ', 'publ_year'); // imena input kontrola
                
                for (i = 0; i < NUM_FIELDS; i++) {
                    document.cookie = "input" + i + "=" + document.getElementById(inp_names[i]).value + ";"; // kreiranje kolaċića
                } 
            }
            
            // setDefaults : postavlja vrednosti kolaċića ( sa imenima input0, input1,.. input11 ) na inicijalnu vrednost i zapisuje 
            // sadržaj svakog input polja u kolaċić
            function setDefaults() {   
                var i;
                for (i = 0; i < INPUT_FIELDS; i++) {
                    document.cookie = "input" + i + "= "; // postavljanje VREDNOSTI kolaċića na PRAZNO
                }
                setCookie(); // za svako input polje zapisuje vrednost sadržaja tog polja u kolaċić
            } 
            
            // prilikom prikazivanja veb stranice prikaži modal ( id: centeredModal )
            $(window).on('load',function(){
                $('#centeredModal').modal('show');
            });
        </script>    
    </head>
    
    <body onload="setDefaults()">
        
        <%
            final String PAGE_NAME = "search_page.jsp"; // stranica koja je prikazana
            HttpSession hSession = PticaMetodi.returnSession(request);
            hSession.setAttribute("webpg_name", "search_page.jsp");
            // ako je korisnik sada završio prijavu za Newsletter, obrazac na sledećoj veb stranici ne treba da prikaže prethdne vrednosti
            hSession.setAttribute("subscribe", "false");
        %>
        
        <!-- dodavanje novog reda u Bootstrap grid: klasa whitebckgr postavlja pozadinu u belo -->
        <div class="whitebckgr">
            <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                <!-- Bootstrap kolona zauzima 6 kolona na velikim desktopovima i 6 kolona na desktopovima srednje veliċine -->
                <div class="col-lg-6 col-md-6"> 
                    <br /><br />
                    <div> <!-- center-image postavlja sliku u sredinu ( horizontalno ), img-fluid je za responsivan image -->
                        <img src="images/books.png" class="img-fluid center-image" alt="slika sa knjigama" title="slika sa knjigama"> 
                    </div>
                    <br /><br />
                    <div> <!-- center-image postavlja sliku u sredinu ( horizontalno ), img-fluid je za responsivan image -->
                        <img src="images/books.png" class="img-fluid center-image" alt="slika sa knjigam" title="slika sa knjigama"> 
                    </div>
                </div>
                      
                <!-- Bootstrap kolona zauzima 5 kolona na velikim desktopovima i 5 kolona na desktopovima srednje veliċine -->
                <div class="col-lg-5 col-md-5"> 
                    <div class="container"> <!-- dodavanje kontejnera u Bootstrap grid -->
                        <div class="row">  <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col">  <!-- dodavanje nove kolone u Bootstrap grid -->
                                &nbsp; &nbsp;
                                <br/>
                                <h3 class="text-info">Pretraga knjiga</h3>
                                <br/> 
                                Džoker znakovi  
                                <!-- neuređena lista sa dve stavke -->
                                <ul>
                                    <li>_ - zamenjuje jedan znak</li>
                                    <li>% - zamenjuje nijedan, jedan ili više znakova
                                </ul>
                                
                                <%  
                                    HttpSession hSession2 = PticaMetodi.returnSession(request);
                                    String input0 = ""; // sačuvaj vrednost koja je prethodno bila u input polju title da bi ponovo bila prikazana
                                    String input1 = ""; 
                                    String input2 = "";       
                                    String input3 = "";         
                                    String input4 = "";         
                                    String input5 = "";         
                                    String input6 = "";       
                                    
                                    // IDEJA : fill_in je postavljena u SubscrServl.java - true ako su neke od varijabli sesije ( unos u input polju ) 
                                    // bile postavljene i one treba da se dodaju ovde obrazcu - ovo je taċno ako je korisnik PRE PRIKAZAO OVU STRANICU
                                    // i posle toga je uneo email u prijavi za Newsletter (u footer-u) i na sledećoj stranici je kliknuo na Zatvori
                                    if (PticaMetodi.sessVarExists(hSession2, "fill_in")) { 
                                        String fill_in = String.valueOf(hSession2.getAttribute("fill_in")); 
                                        
                                        // postavljanje vrednosti varijable sesije page_name. Ako je korisnik kliknuo dugme Prijavite se i posle toga 
                                        // ako je na veb stranici subscrres_content kliknuo na Zatvori dugme, onda se ova veb stranica ponovo prikazuje
                                        if (PticaMetodi.sessVarExists(hSession2, "page_name")) { 
                                            String page_name = String.valueOf(hSession2.getAttribute("page_name"));
       
                                            // Ako je korisnik kliknuo na Zatvori dugme na veb stranici subscrres_content i ako je ova  
                                            // stranica bila  pre prikazana ( page_name ) i ako su neke vrednosti saċuvane u varijablama
                                            // sesije input tada proċitaj varijablu sesije input0 da bi se prikazala u prvoj input kontroli
                                            if ((page_name.equalsIgnoreCase(PAGE_NAME)) && (fill_in.equalsIgnoreCase("true"))) {
                                                if (PticaMetodi.sessVarExists(hSession2, "input0")) {
                                                    input0 = String.valueOf(hSession2.getAttribute("input0")); // vrednost koja je bila u ovom polju
                                                } 
                                                if (PticaMetodi.sessVarExists(hSession2, "input1")) {
                                                    input1 = String.valueOf(hSession2.getAttribute("input1")); 
                                                } 
                                                if (PticaMetodi.sessVarExists(hSession2, "input2")) {
                                                    input2 = String.valueOf(hSession2.getAttribute("input2")); 
                                                } 
                                                if (PticaMetodi.sessVarExists(hSession2, "input3")) {
                                                    input3 = String.valueOf(hSession2.getAttribute("input3")); // vrednost koja je bila selektovana u ovoj padajućoj listi
                                                } 
                                                if (PticaMetodi.sessVarExists(hSession2, "input4")) {
                                                    input4 = String.valueOf(hSession2.getAttribute("input4")); // vrednost koja je bila selektovana u ovoj padajućoj listi
                                                } 
                                                if (PticaMetodi.sessVarExists(hSession2, "input5")) {
                                                    input5 = String.valueOf(hSession2.getAttribute("input5")); // vrednost koja je bila selektovana u ovoj padajućoj listi
                                                } 
                                                if (PticaMetodi.sessVarExists(hSession2, "input6")) {
                                                    input6 = String.valueOf(hSession2.getAttribute("input6")); // vrednost koja je bila selektovana u ovoj padajućoj listi
                                                } 
                                            } 
                                        }
                                        hSession2.setAttribute("fill_in", "false"); // input polja ne treba da budu ispunjena
                                    } 
                                    
                                    // sačuvaj ime veb stranice na kojoj sam sada u slučaju da korisnik klikne na Prijavite se dugme u footer-u  
                                    hSession2.setAttribute("page_name", PAGE_NAME);
                                    // setToEmptyInput: postavlja vrednosti varijabla sesije na "" za varijable input0, input1, ...
                                    PticaMetodi.setToEmptyInput(hSession2 ); 
                                %>
                                
                                <form action="searchDB.jsp" name="search_book" id="search_book" method="post" onsubmit="return checkForm();">
                                    <div class="form-group"> 
                                        <label for="title">Naslov <span class="text_size text-danger">*</span></label> 
                                        <!-- ispunjavanje naslova je obavezno  -->
                                        <input type="text" class="form-control form-control-sm" name="title" id="title" maxlength="60" onchange="setCookie()" onfocusout='setFocus("search_book", "title")' required value="<%= input0 %>"> 
                                    </div>
                                    
                                    <div class="form-group"> 
                                        <label for="author">Autor</label> 
                                        <input type="text" class="form-control form-control-sm" name="author" id="author" maxlength="70" onchange="setCookie()" onfocusout="valLetters(document.search_book.author, author_message, 'fullname', true, 'false');" value="<%= input1 %>"> 
                                        <span id="author_message" class="text_size text-danger"></span>
                                    </div>
                
                                    <div class="form-group">
                                        <label for="isbn">Isbn</label> 
                                        <input type="text" class="form-control form-control-sm" name="isbn" id="isbn" maxlength="13" onchange="setCookie();" onfocusout='isNumber("search_book", "isbn", "is_isbn", "isbn_message", true, false)' value="<%= input2 %>"> 
                                        <span id="isbn_message" class="text_size text-danger"></span>
                                    </div>
                
                                    <div class="form-group">
                                        <label for="price_range">Cena</label> 
                                        <!-- kreiranje padajuće liste; form-control-sm se koristi za užu kontrolu -->
                                        <select class="form-control form-control-sm" name="price_range" id="price_range" onchange="setCookie()"> 
                                            <% if (input3.equalsIgnoreCase("all")){ %>
                                                <option value="all" selected>Sve cene</option> <!-- opcija prikazana u padajućoj listi -->
                                            <% } else { %>
                                                <option value="all">Sve cene</option>
                                            <% } %>
                                            
                                            <% if (input3.equalsIgnoreCase("less500")){ %>
                                                <option value="less500" selected>Cena manja od 500 RSD</option> 
                                            <% } else { %>
                                                <option value="less500">Cena manja od 500 RSD</option>
                                            <% } %>
                                            
                                            <% if (input3.equalsIgnoreCase("betw500-1000")){ %>
                                                <option value="betw500-1000" selected>Od 500 do 1000 RSD</option> <!-- opcija prikazana u padajućoj listi -->
                                            <% } else { %>
                                                <option value="betw500-1000">Od 500 do 1000 RSD</option>
                                            <% } %>
                                            
                                            <% if (input3.equalsIgnoreCase("betw1001-2000")){ %>
                                                <option value="betw1001-2000" selected>Od 1001 do 2000 RSD</option> 
                                            <% } else { %>
                                                <option value="betw1001-2000">Od 1001 do 2000 RSD</option>
                                            <% } %>
                                            
                                            <% if (input3.equalsIgnoreCase("betw2001-5000")){ %>
                                                <option value="betw2001-5000" selected>Od 2001 do 5000 RSD</option> 
                                            <% } else { %>
                                                <option value="betw2001-5000">Od 2001 do 5000 RSDD</option>
                                            <% } %>
                                            
                                            <% if (input3.equalsIgnoreCase("above5000")){ %>
                                                <option value="above5000" selected>Cena veća od 5000 RSD</option> <!-- opcija prikazana u padajućoj listi -->
                                            <% } else { %>
                                                <option value="above5000">Cena veća od 5000 RSD</option>
                                            <% } %>
                                        </select>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="sortby">Sortiraj</label>
                                        <!-- kreiranje padajuće liste; form-control-sm se koristi za užu kontrolu -->
                                        <select class="form-control form-control-sm" name="sortby" id="sortby" onchange="setCookie()"> 
                                            <% if (input4.equalsIgnoreCase("low")){ %>
                                                 <option value="low" selected>Po ceni - rastuća</option> <!-- opcija prikazana u padajućoj listi -->
                                            <% } else { %>
                                                 <option value="low">Po ceni - rastuća</option>
                                            <% } %>
                                            
                                            <% if (input4.equalsIgnoreCase("high")){ %>
                                                 <option value="high" selected>Po ceni - opadajuća</option> 
                                            <% } else { %>
                                                 <option value="high">Po ceni - opadajuća</option>
                                            <% } %>
                                        </select>
                                    </div>
                
                                    <div class="form-group"> 
                                        <label for="categ">Žanrovi</label> 
                                        <!-- kreiranje padajuće liste; form-control-sm se koristi za užu kontrolu -->
                                        <select class="form-control form-control-sm" name="categ" id="categ" onchange="setCookie()">
                                            <% if (input5.equalsIgnoreCase("all")){ %>
                                                 <option value="all" selected>Svi žanrovi</option> <!-- opcija prikazana u padajućoj listi -->
                                            <% } else { %>
                                                 <option value="all">Svi žanrovi</option>
                                            <% } %>
                                            
                                            <% if (input5.equalsIgnoreCase("fict")){ %>
                                                 <option value="fict" selected>Romani</option> 
                                            <% } else { %>
                                                 <option value="fict">Romani</option>   
                                            <% } %>
                                            
                                            <% if (input5.equalsIgnoreCase("bus")){ %>
                                                 <option value="bus" selected>Biznis i ekonomija</option> 
                                            <% } else { %>
                                                 <option value="bus">Biznis i ekonomija</option>      
                                            <% } %>
                                            
                                            <% if (input5.equalsIgnoreCase("comp")){ %>
                                                 <option value="comp" selected>Internet i računari</option> <!-- opcija prikazana u padajućoj listi -->
                                            <% } else { %>
                                                 <option value="comp">Internet i računari</option>  
                                            <% } %>
                                            
                                            <% if (input5.equalsIgnoreCase("edu")){ %>
                                                 <option value="edu" selected>Edukativni</option> 
                                            <% } else { %>
                                                 <option value="edu">Edukativni</option>   
                                            <% } %>
                                            
                                            <% if (input5.equalsIgnoreCase("child")){ %>
                                                 <option value="child" selected>Knjige za decu</option> 
                                            <% } else { %>
                                                 <option value="child">Knjige za decu</option>  
                                            <% } %>
                                        </select>
                                    </div>
                                        
                                    <div class="form-group">
                                        <label for="publ_year">Godina izdavanja</label> 
                                        <input type="text" class="form-control form-control-sm" id="publ_year" name="publ_year" maxlength="4" onchange="setCookie()" onfocusout='isNumber("search_book", "publ_year", "is_yrpubl", "year_message", true, false)' value="<%= input6 %>"> 
                                        <span id="year_message" class="text_size text-danger"></span>
                                    </div>

                                    <div class="container">
                                        <div class="row">
                                            <div class="col">
                                                &nbsp; &nbsp; <!-- dodavanje praznog prostora -->
                                            </div>
                                        </div>    
                                    </div>

                                    <!-- dodavanje dugmets formularu; btn-sm se koristi za manju ( užu ) veličinu kontrole -->
                                    <button type="submit" class="btn btn-info btn-sm">Pretraga knjiga</button>

                                    <!-- adding a new container -->
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
        
        <%
            // ako emp_adm verijabla sesije postoji prikaži je
            if (PticaMetodi.sessVarExists( hSession2, "emp_adm")) {
                String empadmS = (String)(hSession2.getAttribute("emp_adm"));
                Boolean emp = Boolean.valueOf(empadmS); 
                if (emp != true) { // prikaži modal ako korisnik koristi veb sajtu bez prijavljivanja
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
                                    ********************/ptica/zaposleni je veb sajta za zaposlene i administratore
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-info" data-dismiss="modal">Close</button>
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
