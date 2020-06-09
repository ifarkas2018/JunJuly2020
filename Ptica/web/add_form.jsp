<%-- 
    Dokument   : add_form.jsp
    Formiran    : 08-Nov-2018, 13:02:11
    Autor      : Ingrid Farkaš
    Projekt    : Ptica
--%>

<!-- add_form.jsp - dodaje obrazac na stranicu Nova knjiga -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="miscellaneous.PticaMetodi"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ptica - Nova knjiga</title>
        
        <script src="javascript/validationJS.js"></script>
        
        <script>
            NUM_FIELDS = 9; // broj polja na obrazacu  
            INPUT_FIELDS = 11;
            
            // setCookie: kreira kolaċić inputI = vrednost u input polju ; ( I - broj 0..9 )
            function setCookie() {           
                var i;
                // niz sadrži imena input polja
                var inp_names = new Array('title', 'author', 'isbn', 'price', 'pages', 'category', 'descr', 'publisher', 'yrpublished'); 
                
                for (i = 0; i < NUM_FIELDS; i++) {
                    if (i === 3) { // kreiranje kolaċića koji sadrži cenu
                        strWithDot = document.getElementById(inp_names[i]).value; 
                        strWithDot = strWithDot.replace('.','!');
                        strWithDot = strWithDot.replace(',','.');
                        document.cookie = "input" + i + "=" + strWithDot + ";"; // kreiranje kolaċića
                    } else {
                        document.cookie = "input" + i + "=" + document.getElementById(inp_names[i]).value + ";"; // kreiranje kolaċića
                    }    
                } 
            }
            
            // setDefaults : postavlja vrednosti kolaċića ( sa imenima input0, input1,.., input12 ) na inicijalnu vrednost i
            // piše sadržaj svakog input polja u kolaċić
            function setDefaults() { 
                var i;
                for (i = 0; i < INPUT_FIELDS; i++) {
                    document.cookie = "input" + i + "= "; // postavljanje VREDNOSTI kolaċića na PRAZNO
                }
                setCookie(); // za svako input polje zapisuje vrednost sadržaja tog polja u kolaċić
            } 
            
        </script>
    </head>
    
    <body onload="setDefaults()">
        <%
            final String PAGE_NAME = "add_page.jsp"; // stranica koja se sada prikazuje
            HttpSession hSession = PticaMetodi.returnSession(request);
            hSession.setAttribute("webpg_name", "add_page.jsp"); 
            // postavljanje vrednosti varijabli sesije na inicijalnu vrednost: ako je korisnik završio prijavu na Newsletter,
            // obrazac na sledećoj veb stranici ne treba da prikaže prethdne vrednosti
            hSession.setAttribute("subscribe", "false");
        %>
        
        <!-- dodavanje novog reda u Bootstrap grid: klasa whitebckgr postavlja pozadinu u belo -->
        <div class="whitebckgr">
            <div class="row"> 
                <!-- Bootstrap kolona zauzima 6 kolona na velikim desktopovima i 6 kolona na desktopovima srednje veliċine -->
                <div class="col-lg-6 col-md-6"> 
                    <br /><br />
                    <div> 
                        <!-- center-image postavlja sliku u sredinu ( horizontalno ), img-fluid je za responsivan image -->
                        <img src="images/books.png" class="img-fluid center-image" alt="slika sa knjigama" title="slika sa knjigama"> 
                    </div>
                    <br /><br />
                    <div> 
                        <!-- center-image postavlja sliku u sredinu ( horizontalno ), img-fluid je za responzivan image -->
                        <img src="images/books.png" class="img-fluid center-image" alt="slika sa knjigama" title="slika sa knjigama"> 
                    </div>
                </div>
               
                <!-- Bootstrap kolona zauzima 5 kolona na velikim desktopovima i 5 kolona na desktopovima srednje veliċine -->
                <div class="col-lg-5 col-md-5"> 
                    <div class="container"> 
                        <div class="row"> 
                            <div class="col">
                                &nbsp; &nbsp;
                                <br/>
                                <h3 class="text-info">Nova knjiga</h3>
                                <br/> 
                                <%  
                                    HttpSession hSession2 = PticaMetodi.returnSession(request);
                                    
                                    String input0 = ""; // proċitaj vrednost koja je bila pre u input polju i ponovo je prikaži
                                    String input1 = ""; 
                                    String input2 = ""; 
                                    String input3 = "";
                                    String input4 = "";
                                    String input5 = "";
                                    String input6 = ""; // proċitaj vrednost koja je bila pre selektovana u listi i ponovo je prikaži
                                    String input7 = ""; // proċitaj vrednost koja je bila u polju za unos teksta i ponovo je prikaži
                                    String input8 = "";
                                                                        
                                    // IDEJA : fill_in je postavljena u SubscrServl.java - true ako su neke od varijabli sesije ( input ) bile postavljene,
                                    // i one treba da se dodaju ovde obrazcu - ovo je taċno ako je korisnik PRE PRIKAZAO OVU STRANICU i posle toga je uneo
                                    // email u prijavi za Newsletter ( u footer-u ) i na sledećoj stranici je kliknuo na Zatvori
                                    if (PticaMetodi.sessVarExists(hSession2, "fill_in")) { 
                                        String fill_in = String.valueOf(hSession2.getAttribute("fill_in")); 
                                        // Postavljanje vrednosti varijable sesije page_name. Ako je korisnik kliknuo dugme Prijavite se i posle toga ako je na veb
                                        // stranici subscrres_content kliknuo na Zatvori dugme, onda se ova veb stranica ponovo prikazuje
                                        if (PticaMetodi.sessVarExists(hSession2, "page_name")) { 
                                            String page_name = String.valueOf(hSession2.getAttribute("page_name"));
                                            // Ako je korisnik kliknuo na Zatvori dugme na veb stranici subscrres_content i ako je 
                                            // ova stranica bila prikazana pre ( page_name ) i ako su neke vrednosti saċuvane u varijablama 
                                            // sesije input tada proċitaj varijablu sesije input0 ( da bi se prikazala u prvom polju ) 
                                            if (( page_name.equalsIgnoreCase(PAGE_NAME)) && (fill_in.equalsIgnoreCase("true"))) {
                                                if (PticaMetodi.sessVarExists(hSession2, "input0")) {
                                                    input0 = String.valueOf(hSession2.getAttribute("input0")); // vrednost koja je bila u prvom polju
                                                } 
                                                if (PticaMetodi.sessVarExists(hSession2, "input1")) {
                                                    input1 = String.valueOf(hSession2.getAttribute("input1")); // vrednost koja je bila u drugom polju
                                                } 
                                                if (PticaMetodi.sessVarExists(hSession2, "input2")) {
                                                    input2 = String.valueOf(hSession2.getAttribute("input2")); // vrednost koja je bila u trećem polju
                                                } 
                                                if (PticaMetodi.sessVarExists(hSession2, "input3")) {
                                                    input3 = String.valueOf(hSession2.getAttribute("input3")); 
                                                } 
                                                if (PticaMetodi.sessVarExists(hSession2, "input4")) {
                                                    input4 = String.valueOf(hSession2.getAttribute("input4")); 
                                                } 
                                                if (PticaMetodi.sessVarExists(hSession2, "input5")) {
                                                    input5 = String.valueOf(hSession2.getAttribute("input5")); 
                                                } 
                                                if (PticaMetodi.sessVarExists(hSession2, "input6")) {
                                                    input6 = String.valueOf(hSession2.getAttribute("input6")); 
                                                } 
                                                if (PticaMetodi.sessVarExists(hSession2, "input7")) {
                                                    input7 = String.valueOf(hSession2.getAttribute("input7")); 
                                                } 
                                                if (PticaMetodi.sessVarExists(hSession2, "input8")) {
                                                    input8 = String.valueOf(hSession2.getAttribute("input8")); 
                                                } 
                                            } 
                                        }
                                        hSession2.setAttribute("fill_in", "false"); // input polja ne treba da budu ispunjena
                                    } 
                                    
                                    // saċuvaj ime stranice gde sam sada u sluċaju korisnik klikne na Prijavite se dugme u footer-u
                                    hSession2.setAttribute("page_name", PAGE_NAME);
                                    PticaMetodi.setToEmptyInput(hSession2); // setToEmpty: postavlja vrednosti varijabli sesije na "" za varijable input0, input1, ...
                                %>
                                
                                <!-- posle klika na dugme AddServlet se izvršava -->
                                <form id="add_book" name="add_book" action="AddServlet" method="post" onsubmit="return checkForm();">
                                    <!-- input kontrola za naslov -->
                                    <div class="form-group">
                                        <label for="title">Naslov <span class="text_size text-danger">*</span></label> 
                                        <!-- unošenje naslova je obavezno -->
                                        <input type="text" class="form-control form-control-sm" name="title" id="title" maxlength="60" onchange="setCookie()" onfocusout='setFocus("add_book", "title")' required value="<%= input0 %>"> 
                                    </div>
                                        
                                    <!-- input kontrola za ime autora -->
                                    <div class="form-group">
                                        <label for="author">Autor <span class="text_size text-danger">*</span></label> 
                                        <!-- unošenje naslova je obavezno -->
                                        <input type="text" class="form-control form-control-sm" name="author" id="author" maxlength="70" onchange="setCookie()" onfocusout="valLetters(document.add_book.author, author_message, 'fullname', false, 'true');" required value="<%= input1 %>"> 
                                    </div>
                
                                    <!-- input kontrola za Isbn -->
                                    <div class="form-group">
                                        <label for="isbn">Isbn</label> 
                                        <input type="text" class="form-control form-control-sm" name="isbn" id="isbn" maxlength="13" onchange="setCookie()" onfocusout='isNumber("add_book", "isbn", "is_isbn", "isbn_message", false, false)' value="<%= input2 %>"> 
                                        <span id="isbn_message" class="text_size text-danger"></span>
                                    </div>
                                        
                                    <!-- input kontrola za Isbn -->
                                    <div class="form-group">
                                        <% if (!input3.equalsIgnoreCase("")) {
                                            input3 = input3.replace('.', ','); // u kolaċiću umesto , se pojavljuje .
                                            input3 = input3.replace('!','.');
                                           }
                                        %>
                                        <label for="price">Cena</label> 
                                        <input type="text" class="form-control form-control-sm" name="price" id="price" maxlength="9" onchange="setCookie()" onfocusout='daLiJeCena("add_book", "price", "is_price", "price_message")' value="<%= input3 %>"> 
                                        <span id="price_message" class="text_size text-danger"></span>
                                    </div>
                                        
                                    <!-- input kontrola za broj stranica -->
                                    <div class="form-group">
                                        <label for="pages">Broj strana</label> 
                                        <input type="text" class="form-control form-control-sm" name="pages" id="pages" maxlength="4" onchange="setCookie()" onfocusout='isNumber("add_book", "pages", "is_pages", "pages_message", false, false)' value="<%= input4 %>"> 
                                        <span id="pages_message" class="text_size text-danger"></span>
                                    </div>
                                        
                                    <!-- padajuća lista za žanrove -->
                                    <div class="form-group"> 
                                        <label for="category">Žanrovi</label> 
                                        <!-- kreiranje padajuće liste; form-control-sm se koristi za užu kontrolu -->
                                        <select class="form-control form-control-sm" name="category" id="category" onchange="setCookie()">
                                            <% if (input5.equalsIgnoreCase("all")) { %>
                                                   <option value="all" selected>Svi žanrovi</option> <!-- opcija u padajućoj listi -->
                                            <% } else { %>
                                                   <option value="all">Svi žanrovi</option>
                                            <% } %>
                                            
                                            <% if (input5.equalsIgnoreCase("fict")) { %>
                                                   <option value="fict" selected>Romani</option> 
                                            <% } else { %>
                                                   <option value="fict">Romani</option>   
                                            <% } %>
                                            
                                            <% if (input5.equalsIgnoreCase("bus")) { %>
                                                   <option value="bus" selected>Biznis i ekonomija</option> 
                                            <% } else { %>
                                                   <option value="bus">Biznis i ekonomija</option>      
                                            <% } %>
                                            
                                            <% if (input5.equalsIgnoreCase("comp")) { %>
                                                   <option value="comp" selected>Internet i računari</option> 
                                            <% } else { %>
                                                   <option value="comp">Internet i računari</option>  
                                            <% } %>
                                            
                                            <% if (input5.equalsIgnoreCase("edu")) { %>
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
                                        
                                    <!-- kreiranje oblasti za tekst za opis knjige -->
                                    <div class="form-group">
                                        <label for="descr">Opis</label>
                                        <textarea class="form-control" name="descr" id="descr" rows="7" onchange="setCookie()"><%= input6 %></textarea>
                                    </div>
                                        
                                    <!-- input kontrola za izdavača -->
                                    <div class="form-group">
                                        <label for="publisher">Izdavač <span class="text_size text-danger">*</span></label> 
                                        <!-- ispunjavanje kontrole za izdavača je obavezno -->
                                        <input type="text" class="form-control form-control-sm" name="publisher" maxlength="40" id="publisher" onchange="setCookie()" onfocusout='setFocus("add_book", "publisher")' required value="<%= input7 %>"> 
                                    </div>
                                        
                                    <!-- input kontrola za godinu izdavanja -->
                                    <div class="form-group">
                                        <label for="yrpublished">Godina izdavanja</label> 
                                        <!-- ispunjavanje kontrole za godinu izadanja je obavezno -->
                                        <input type="text" class="form-control form-control-sm" name="yrpublished" id="yrpublished" maxlength="4" onchange="setCookie()" onfocusout='isNumber("add_book", "yrpublished", "is_yrpubl", "yrpubl_message", false, false)' value="<%= input8 %>"> 
                                        <span id="yrpubl_message" class="text_size text-danger"></span>
                                    </div>
                                        
                                    <div class="container">
                                        <div class="row">
                                            <div class="col">
                                                &nbsp; &nbsp; <!-- dodavanje praznog prostora -->
                                            </div>
                                        </div>    
                                    </div>
                                        
                                    <!-- btn-sm se koristi za manju ( užu ) veličinu kontrole -->
                                    <button type="submit" id="btnSubmit" class="btn btn-info btn-sm">Dodajte knjigu</button>
                                    <!-- dodavanje novog kontejnera -->
                                    <div class="container">
                                        <div class="row">
                                            <div class="col">
                                                &nbsp; &nbsp; <!-- dodavanje praznog prostora -->
                                            </div>
                                        </div>    
                                    </div>
                                </form>  
                            </div> <!-- završetak class = "col" -->
                        </div> <!-- završetak class = "row" --> 
                    </div> <!-- završetak class = "container" -->
                </div> <!-- završetak class = "col-lg-5 col-md-5" -->
            </div> <!-- završetak class = "row" -->
        </div> <!-- završetak class = "whitebckgr" -->
            
        <!-- dodavanje novog reda u Bootstrap grid; klasa whitebckgr: postavljanje pozadine u belo -->
        <div class="whitebckgr">
            <div class="col">
                &nbsp; &nbsp;
            </div>
        </div> 
    </body>
</html>