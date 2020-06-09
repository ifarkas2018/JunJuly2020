<%-- 
    Dokument   : signup_form ( ukljuċen u signup_page.jsp )
    Formiran   : 06-Apr-2019, 00:14:14
    Autor      : Ingrid Farkaš
    Project    : Ptica
--%>

<!-- signup_form.jsp - prikazuje obrazac za unos korisničkog imena, lozinke, imena, prezimena, da li je korisnik administrator  -->
<!--                 - ukljuċen u signup_page.jsp -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="miscellaneous.PticaMetodi"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">        
        <script src="javascript/validationJS.js"></script> 
        
        <script>
            NUM_FIELDS = 5; // broj polja na obrazacu   
            INPUT_FIELDS = 12; // max broj polja na svim obrazcima  
            EQUAL_PASSW = 'true'; // da li se unesene lozinke poklapaju 
           
            // matchPass:  upoređuje dve unesene lozinke i postavlja vrednost varijable EQUAL_PASSW ( da li se lozinke poklapaju )
            function matchPass(){  
                var passwd1 = document.signup.passw1.value;  
                var passwd2 = document.signup.passw2.value;   

                if (passwd1 == passwd2) {  
                    EQUAL_PASSW= 'true';
                    // obtiši poruke ispod input kontrola za lozinke
                    passw1_message.innerHTML = " ";
                    passw2_message.innerHTML = " ";
                }  else {  
                    EQUAL_PASSW = 'false'; 
                    // prikaži poruku ispod input polja za lozinke
                    passw1_message.innerHTML = "Lozinke se ne poklapaju.";
                    passw2_message.innerHTML = "Lozinke se ne poklapaju.";
                }  
            }  
           
            // setCookie: kreira kolaċić inputI = vrednost u input polju ; ( I - broj 0..5 )
            function setCookie() {           
                var i;
                // niz sadrži imena input polja
                var inp_names = new Array('username', 'first_name', 'last_name', 'adm_yes', 'adm_no'); 
                
                // za radio dugmad postavi kolaċić na inicijalnu vrednost
                document.cookie = "input3" + "=;";
                document.cookie = "input4" + "=;";
                for (i = 0; i < NUM_FIELDS; i++) {
                    if ((i==0) || (i==1) || (i==2)) {
                        document.cookie = "input" + i + "=" + document.getElementById(inp_names[i]).value + ";"; // kreiranje kolaċića
                    } else if ((i==3) || (i==4)) {
                        if (document.getElementById(inp_names[i]).checked){ // ako je radio dugme uključeno
                            document.cookie = "input" + i + "=" + document.getElementById(inp_names[i]).value + ";"; // kreiranje kolaċića
                        }
                    }
                }
            }
            
            // getCookie: vraća vrednost kolaċića sa imenom cname
            function getCookie(cname) {
                var name = cname + "=";
                var decodedCookie = decodeURIComponent(document.cookie);
                var cookieArr = decodedCookie.split(';'); // podela kolaċića na "cookie_name = cookie_value;"
                for( var i = 0; i < cookieArr.length; i++ ) {
                  var c = cookieArr[i];
                  while (c.charAt(0) == ' ') {
                    c = c.substring(1);
                  }
                  if (c.indexOf(name) == 0) { // ako kolaċić poċinje sa cname + "=" 
                    return c.substring(name.length, c.length); // vraća vrednost kolaċića 
                  }
                }
                return "";
            }
            
            // setDefaults : postavlja vrednosti kolaċića ( sa imenima input0, input1,.., input12 ) na inicijalnu vrednost i
            // piše sadržaj svakog input polja u kolaċić
            function setDefaults() {   
                var i;
                for (i = 0; i < INPUT_FIELDS; i++) {
                    cValue = getCookie("fill_in");
                    // ako se obrazac ne puni sa prethodnim vrednostima tada se radio dugmad postavlja na inicijalnu vrednost
                    if ((i===0) && (cValue==="false" )){ 
                        document.getElementById("adm_yes").checked = true; // inicijalno je postavljeno radio dugme Da 
                    }
                    document.cookie = "input" + i + "= "; // postavljanje VREDNOSTI kolaċića na PRAZNO
                }
                document.cookie = "fill_in=false;"; // postavljanje fill_in na inicijalnu vrednost
                setCookie(); // za svako input polje zapisuje vrednost sadržaja tog polja u kolaċić
            } 
          
        </script>
    </head>
    
    <title>Ptica - Novi nalog</title>
    <body onload="setDefaults()">
        <%
            final String PAGE_NAME = "signup_page.jsp"; // stranica koja se sada prikazuje
            HttpSession hSession = PticaMetodi.returnSession(request);
            hSession.setAttribute("webpg_name", "signup_page.jsp");
            // postavljanje vrednosti varijabli sesije na inicijalnu vrednost: ako je korisnik sada završio prijavu na Newsletter,
            // obrazac na sledećoj veb stranici ne treba da prikaže prethdne vrednosti
            hSession.setAttribute("subscribe", "false");
        %>
        
        <!-- dodavanje novog reda u Bootstrap grid: klasa whitebckgr postavlja pozadinu u belu boju -->
        <div class="whitebckgr">
            <div class="row"> <!-- dodavanje nove vrste u Bootstrap grid -->
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
                                <h3 class="text-info">Novi nalog</h3> 
                                <br/> 
                                <%  
                                    HttpSession hSession2 = PticaMetodi.returnSession(request);
                                    
                                    String input0 = ""; // proċitaj vrednost koja je bila pre u prvom input polju i ponovo je prikaži
                                    String input1 = ""; 
                                    String input2 = "";     
                                    String input3 = ""; // da li je Da radio dugme izabrano 
                                    String input4 = ""; // da li je Ne radio dugme izabrano 
                                    
                                    // IDEJA : fill_in je postavljena u SubscrServl.java - true ako su neke od varijabli sesije ( input ) bile postavljene,
                                    // i one treba da se dodaju ovde obrazcu - ovo je taċno ako je korisnik PRE PRIKAZAO OVU STRANICU i posle toga je uneo
                                    // email u prijavi za Newsletter ( u footer-u ) i na sledećoj stranici je kliknuo na Zatvori
                                    if (PticaMetodi.sessVarExists(hSession2, "fill_in")) { 
                                        String fill_in = String.valueOf(hSession2.getAttribute("fill_in")); 
                                        // Postavljanje vrednosti varijable sesije page_name. Ako je korisnik kliknuo dugme Prijavite se i posle toga ako je
                                        // na veb stranici subscrres_content kliknuo na Zatvori dugme, onda se ova veb stranica ponovo prikazuje
                                        if (PticaMetodi.sessVarExists(hSession2, "page_name")) { 
                                            String page_name = String.valueOf(hSession2.getAttribute("page_name"));
                                            // Ako je korisnik kliknuo na Zatvori dugme na veb stranici subscrres_content i ako je 
                                            // ova stranica bila prikazana pre ( page_name ) i ako su neke vrednosti saċuvane u varijablama 
                                            // sesije input tada proċitaj varijablu sesije input0 ( da bi se prikazala u prvom polju ) 
                                            if ((page_name.equalsIgnoreCase(PAGE_NAME)) && (fill_in.equalsIgnoreCase("true"))) {
                                                if (PticaMetodi.sessVarExists(hSession2, "input0")) {
                                                    input0 = String.valueOf(hSession2.getAttribute("input0")); // vrednost koja je bila u prvom polju
                                                } 
                                                if (PticaMetodi.sessVarExists(hSession2, "input1")) {
                                                    input1 = String.valueOf(hSession2.getAttribute("input1")); // vrednost koja je bila u drugom polju
                                                } 
                                                if (PticaMetodi.sessVarExists(hSession2, "input2")) {
                                                    input2 = String.valueOf(hSession2.getAttribute("input2")); 
                                                }   
                                                if (PticaMetodi.sessVarExists(hSession2, "input3")) {
                                                    input3 = String.valueOf(hSession2.getAttribute("input3")); // da li je Da radio dugme izabrano
                                                }   
                                                if (PticaMetodi.sessVarExists(hSession2, "input4")) {
                                                    input4 = String.valueOf(hSession2.getAttribute("input4")); // da li je Ne radio dugme izabrano
                                                }   
                                            } 
                                        }
                                        hSession2.setAttribute("fill_in", "false"); // input polja ne treba da budu ispunjena
                                    }                                    
                                    hSession2.setAttribute("page_name", PAGE_NAME);
                                    PticaMetodi.setToEmptyInput(hSession2); // setToEmpty: postavlja vrednosti varijabli sesije na "" za varijable input0, input1, ...
                                %>

                                <form name="signup" id="signup" action="SignUpServlet" onsubmit="return checkForm();" method="post">                                   
                                    <!-- input kontrola za ime -->
                                    <div class="form-group">
                                        <label for="first_name">Ime</label> 
                                        <input type="text" class="form-control form-control-sm" name="first_name" id="first_name" maxlength="20" onfocusout="setCookie();valLetters(document.signup.first_name, fname_message, 'firstname', false, 'false');" value="<%= input1 %>"> 
                                        <span id="fname_message" class="text_size text-danger"></span>
                                    </div>

                                    <!-- input kontrola za prezime -->
                                    <div class="form-group">
                                        <label for="last_name">Prezime</label> 
                                        <input type="text" class="form-control form-control-sm" name="last_name" id="last_name"  maxlength="20" onfocusout="setCookie();valLetters(document.signup.last_name, lname_message, 'lastname', false, 'false');" value="<%= input2 %>"> 
                                        <span id="lname_message" class="text_size text-danger"></span>
                                    </div>
                                        
                                    <!-- input kontrola za korisničko ime -->
                                    <div class="form-group">
                                        <label for="username">Korisničko ime <span class="text_size text-danger">*</span></label> 
                                        <!-- ispunjavanje kontrole za korisničko ime je obavezno -->
                                        <input type="text" class="form-control form-control-sm" name="username" id="username" maxlength="20" onchange="setCookie()" onfocusout='setFocus("signup", "username")'  required value="<%= input0 %>"> 
                                    </div>
                                        
                                    <!-- input kontrola za lozinku -->
                                    <div class="form-group">
                                        <label for="passw1">Lozinka <span class="text_size text-danger">*</span></label> 
                                        <!-- ispunjavanje kontrole za lozinku je obavezno -->
                                        <input type="password" class="form-control form-control-sm" name="passw1" id="passw1" maxlength="17" 
                                               pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" title="Lozinka mora da sadrži najmanje 8 karaktera. Najmanje jedan broj, jedno veliko i jedno malo slovo." 
                                               onfocusout='matchPass()' required> 
                                        <span id="passw1_message" class="text_size text-danger"></span>
                                    </div>
                                    
                                    <!-- input kontrola za ponovo unošenje lozinke -->
                                    <div class="form-group">
                                        <label for="passw2">Ponovite lozinku <span class="text_size text-danger">*</span></label> 
                                        <input type="password" class="form-control form-control-sm" name="passw2" id="passw2" maxlength="17" 
                                               pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" title="Lozinka mora da sadrži najmanje 8 karaktera. Najmanje jedan broj, jedno veliko i jedno malo slovo." 
                                               onfocusout='matchPass()' required>
                                        <span id="passw2_message" class="text_size text-danger"></span>
                                    </div>
                                    
                                    <!-- radio dugmad - administrator -->
                                    <div class="form-group">
                                        <label for="admin">Administrator</label> 
                                        <div class="form-check">
                                            <!-- radio dugme Da -->
                                            <% if (input3.equalsIgnoreCase("adm_yes")){ %>
                                                <input class="form-check-input" type="radio" name="admin" id="adm_yes" value="adm_yes" onchange="setCookie()" checked>
                                            <% } else { %>
                                                <input class="form-check-input" type="radio" name="admin" id="adm_yes" value="adm_yes" onchange="setCookie()">
                                            <% } %> 
                                            <label class="form-check-label" for="admin_yes">
                                                Da
                                            </label>
                                        </div>
                                        <div class="form-check">
                                            <!-- radio dugme Ne -->
                                            <% if (input4.equalsIgnoreCase("adm_no")){ %>
                                                <input class="form-check-input" type="radio" name="admin" id="adm_no" value="adm_no" onclick="setCookie()" checked>
                                            <% } else { %>
                                                <input class="form-check-input" type="radio" name="admin" id="adm_no" value="adm_no" onclick="setCookie()">
                                            <% } %> 
                                            <label class="form-check-label" for="admin_no">
                                                Ne
                                            </label>
                                        </div>
                                    </div>
                                    <div class="container">
                                        <div class="row">
                                            <div class="col">
                                                &nbsp; &nbsp; <!-- dodavanje praznog prostora -->
                                            </div>
                                        </div>    
                                    </div>
                                        
                                    <!-- btn-sm se koristi za manju ( užu ) veličinu kontrole -->
                                    <button type="submit" id="btnSubmit" class="btn btn-info btn-sm">Pošaljite</button>
                                    
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
    </body>
</html>

