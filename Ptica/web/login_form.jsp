<%-- 
    Dokumenat   : login_page.jsp
    Formiran    : 31-Mar-2019, 21:19:51
    Autor       : Ingrid Farkaš
    Projekat    : Ptica
--%>

<%@page import="java.util.Enumeration"%>
<%@page import="miscellaneous.PticaMetodi"%>

<!-- login_form.jsp - prikazuje obrazac za unos korisničkog imena i lozinku -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
        
        <script>
            NUM_FIELDS = 3; // broj polja na obrazacu  
            
            // setCookie: kreira kolaċić input0 = vrednost u input polju ; 
            function setCookie() {           
                var i;
                document.cookie = "input0=" + document.getElementById("username").value + ";"; // kreiranje kolaċića
            }
            
            // setDefaults : postavlja vrednosti kolaċića (sa imenom input0, input1,.., input12) na inicijalnu vrednost i
            // piše sadržaj svakog input polja u kolaċić
            function setDefaults() {
                var i;
                for (i = 0; i < NUM_FIELDS; i++) {
                    document.cookie = "input" + i + "= "; // postavljanje VREDNOSTI kolaċića na PRAZNO
                }
                setCookie(); // zapisuje vrednost sadržaja polja sa korisničkim imenom u kolaċić
            } 
        </script>    
    </head>
    
    <title>Ptica - Prijava</title>
    <body onload="setDefaults()">
        
        <%
            final String PAGE_NAME = "login_page.jsp"; // stranica na kojoj sam sada
            HttpSession hSession = PticaMetodi.returnSession(request);
            // ime veb stranice koja treba da se prikaže ako korisnik unese email ( Newsletter - prijava ) 
            hSession.setAttribute("webpg_name", "login_page.jsp");
            // postavljanje vrednosti varijabli sesije na inicijalnu vrednost: ako je korisnik sada završio prijavu na Newsletter,
            // obrazac na sledećoj veb stranici ne treba da prikaže prethdne vrednosti
            hSession.setAttribute("subscribe", "false");
        %>
        
        <!-- dodavanje novog reda u Bootstrap grid: klasa whitebckgr postavlja pozadinu u belu boju -->
        <div class="whitebckgr">
            <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                <!-- Bootstrap kolona zauzima 6 kolona na velikim desktopovima i 6 kolona na desktopovima srednje veliċine -->
                <div class="col-lg-6 col-md-6"> 
                    <br /><br />
                    <div> 
                        <!-- center-image postavlja sliku u sredinu ( horizontalno ), img-fluid je za responsivan image -->
                        <img src="images/books.png" class="img-fluid center-image" alt="picture of books" title="picture of books"> 
                    </div>
                </div>
                
                <!-- Bootstrap kolona zauzima 5 kolona na velikim desktopovima i 5 kolona na desktopovima srednje veliċine -->
                <div class="col-lg-5 col-md-5"> 
                    <div class="container"> <!-- dodavanje kontejnera u Bootstrap grid -->
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col">
                                &nbsp; &nbsp;
                                <br />
                                <h3  class="text-info">Prijava</h3> 
                                <br /> 
                                
                                <form id="login" name="login" action="LoginServlet" method="post">
                                <!-- creating the input element for the username -->
                                <!-- labela i input kontrola za korisničko ime -->
                                    <div class="form-group">
                                        <%  
                                            String input0 = ""; // proċitaj vrednost koja je bila pre u input polju korisničko ime i ponovo je prikaži
                                            
                                            // IDEJA : fill_in je postavljena u SubscrServl.java - true ako su neke od varijabli sesije ( u input polju ) 
                                            // bile postavljene i one treba da se dodaju ovde obrazcu - ovo je taċno ako je korisnik PRE PRIKAZAO OVU STRANICU
                                            // i posle toga je uneo email u prijavi za Newsletter (u footer-u) i na sledećoj stranici je kliknuo na Zatvori
                                            if (PticaMetodi.sessVarExists(hSession, "fill_in")) { 
                                                String fill_in = String.valueOf(hSession.getAttribute("fill_in")); 
                                                // postavljanje vrednosti varijable sesije page_name. Ako je korisnik kliknuo na dugme Prijavite se 
                                                // i posle toga ako je na veb stranici subscrres_content kliknuo na Zatvori dugme, onda se ova veb 
                                                // stranica ponovo prikazuje
                                                if (PticaMetodi.sessVarExists(hSession, "page_name")) { 
                                                    String page_name = String.valueOf(hSession.getAttribute("page_name"));
                                                    // Ako je korisnik kliknuo na Zatvori dugme na veb stranici subscrres_content i ako je 
                                                    // ova stranica bila prikazana pre ( page_name ) i ako su neke vrednosti saċuvane u varijablama
                                                    // sesije input tada proċitaj varijablu sesije input0 da bi se prikazala u input polju za korisničko ime
                                                    if ((page_name.equalsIgnoreCase(PAGE_NAME)) && (fill_in.equalsIgnoreCase("true"))) {
                                                        if (PticaMetodi.sessVarExists(hSession, "input0")) {
                                                            input0 = String.valueOf(hSession.getAttribute("input0")); // vrednost koja je bila u ovom polju
                                                        } 
                                                        PticaMetodi.setToEmptyInput(hSession); // setToEmptyInput: postavlja vrednosti varijabli sesije na "" za varijable input0, input1, ... 
                                                    }
                                                }
                                                hSession.setAttribute("fill_in", "false"); // input polja ne treba da budu popunjena
                                            } 
                                            
                                            // saċuvaj ime stranice gde sam sada u sluċaju da korisnik klikne na Prijavite se dugme u footer-u
                                            hSession.setAttribute("page_name", PAGE_NAME);
                                        %>
                                        <label for="username">Korisničko ime <span class="text_size text-danger">*</span></label> 
                                        <!-- input kontrola za korisničko ime -->
                                        <input type="text" class="form-control form-control-sm" name="username" id="username" maxlength="20" onchange="setCookie()" onfocusout='setFocus("login", "username")' required value = "<%= input0 %>" > 
                                    </div>
                                        
                                    <div class="form-group">
                                        <label for="passw">Lozinka <span class="text_size text-danger">*</span></label> <!-- password name label -->
                                        <!-- input kontrola za lozinku ( obavezno polje ) -->
                                        <input type="password" class="form-control form-control-sm" name="passw" id="passw" maxlength="17" required> 
                                    </div>
                                    
                                    <div class="container">
                                        <div class="row">
                                            <div class="col">
                                                &nbsp; &nbsp; <!-- dodavanje praznog prostora -->
                                            </div>
                                        </div>    
                                    </div>
                                        
                                    <!-- btn-sm se koristi za manju ( užu ) veličinu kontrole -->
                                    <button type="submit" id="btnSubmit" class="btn btn-info btn-sm">Prijava</button>
                                    <!-- dodavanje novog kontejnera -->
                                    <div class="container">
                                        <div class="row">
                                            <div class="col">
                                                &nbsp; &nbsp; <!-- dodavanje praznog prostora -->
                                            </div>
                                        </div>    
                                    </div>

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
