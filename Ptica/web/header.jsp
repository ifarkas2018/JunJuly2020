<%-- 
    Dokument   : header
    Formiran   : 29-Mar-2019, 22:46:27
    Autor      : Ingrid Farkaš
    Projekat   : Ptica
--%>

<%@page import="java.util.Enumeration"%>
<%@page import="miscellaneous.PticaMetodi"%>

<!-- header.jsp formira logo, ime kompanije i navigaciju -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="miscellaneous.PticaMetodi"%>

<%  final String URL_EMP_ADM = "ptica/zaposleni"; // URL za zaposlene i administratore
    final String URL_CUST = "ptica"; // URL za kupce
%>

<!DOCTYPE html>
<html lang="en">
    <head>           
        <!-- meta elementi -->
        <!-- karakter set -->
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <!-- ključne reči koje se koriste prilikom Internet pretraživanja -->
        <meta name="keywords" content="Ptica, Knjižara u Beogradu i Novom Sadu, Online Knjižara, Onlajn Knjižara">
        <!-- meta tag koji se koristi za opis i svrhu veb sajte --> 
        <meta name="description" content="Razgledajte široki izbor knjiga i uživajte u kupovini sa dostavom do Vaših vrata">
        <meta name="author" content="Ingrid Farkaš"> 
        <!-- koristi se za responsivne veb stranice na uređajima sa razlicitom veličinom displeja -->
        <meta name="viewport" content="width=device-width, initial-scale=1"> 

        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        
        <!-- link za Bootstrap CDN -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script> 
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script> 
        <link rel="stylesheet" href="css/templatecss.css">
        
        <script>
            // setCookie: formiranje 2 kolačića 
            // 1. kolačić : fill_in = false 
            // 2. kolačić : webpg_name = webPageVal
            function cookieFillIn( webPageVal ) {                
                document.cookie = "fill_in=false;"; // formiranje 1. kolačića 
                document.cookie = "webpg_name=" + webPageVal;
            }
        </script>
    </head>

    <body class="greybckgr"> <!-- greybckgr - klasa koja postavlja sivu pozadinu ( templatecss.css ) -->
        <div class="container">
            <div class="whitebckgr"> <!-- novi red - bela pozadina -->
            <div class="whitebckgr">
                <!-- Bootstrap kolona zauzima 12 kolona na velikim desktopovima, 12 kolona na desktopovima srednje veliċine,
                     12 kolona na displejima male veličine, 12 kolona na displejima ekstra male veličine -->
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <p>&nbsp; &nbsp;</p> 
                </div>
              
                <div class="row"> <!-- novi red u Bootstrap grid-u -->
                    <!-- Bootstrap kolona zauzima 5 kolona na velikim desktopovima, 5 kolona na desktopovima srednje veliċine -->
                    <div class="col-lg-5 col-md-5"> 
                        &nbsp; &nbsp; 
                    </div>
                    <!-- Bootstrap kolona zauzima 4 kolone na velikim desktopovima, 4 kolone na desktopovima srednje veliċine -->
                    <div class="col-lg-4 col-md-4"> 
                        &nbsp;  
                        <!-- logo Ptice -->
                        <img class="img-logo" src="images/bookshelf.png" alt="Ptica Logo" title="Ptica Logo">  
                                    
                        <span class="title-text">Ptica</span> <!-- ime knjižare -->
                    </div>
                    
                    <!-- Bootstrap kolona zauzima 7 kolona na velikim desktopovima, 7 kolona na desktopovima srednje veliċine,
                         12 kolona na displejima male veličine, 12 kolona na displejima ekstra male veličine -->
                    <div class="col-lg-7 col-md-7 col-sm-12 col-xs-12 "> 
                        &nbsp; &nbsp; 
                    </div>
                </div> 
            </div>       
            
            <%
                String emp_adm = ""; // da li korisnk koristi veb sajtu za zaposlene i administratore ( ne za kupce )  
                String logged_in = ""; // da li se korisnik prijavio 
                String userType = ""; // vrsta korisnika: admin, emp ( zaposleni ), customer ( kupac )
                String attrName = ""; // naziv varijable sesije 
                boolean attr_found = false; // da li je emp_adm jedna od varijabli sesije
                String errPage = "false"; // da li se prikazuje stranica za grešku
                
                HttpSession hSession1 = PticaMetodi.returnSession(request);
                
                // sessVarExists: vraća da li varijabla sesije user_type postoji
                // user_type: admin, emp ( zaposleni ), customer ( kupac ) ( postoji posle prijave korisnika ) 
                attr_found = PticaMetodi.sessVarExists(hSession1, "user_type"); 
                if (attr_found) // da li je pronađen atribut user_type
                    userType = String.valueOf(hSession1.getAttribute("user_type")); // admin, emp, customer ( moguće vrednosti )
                
                String URL_String = (request.getRequestURL()).toString(); // URL veb stanice koja je prikazana pre ove 
                
                // da li je stranica za grešku prikazana  
                attr_found = PticaMetodi.sessVarExists(hSession1, "is_error"); // sessVarExists: vraća da li varijabla sesije is_error postoji u sesiji
                
                if (attr_found) { // da li je pronađena varijabla sesije is_error
                    errPage = String.valueOf(hSession1.getAttribute("is_error"));
                }
                
                // da li korisnik koristi veb sajtu za zaposlene i administratore ( a ne za kupce )
                attr_found = PticaMetodi.sessVarExists(hSession1, "emp_adm"); // sessVarExists: vraća da li varijabla sesije emp_adm postoji
                if (attr_found) // da li je pronađena varijabla sesije emp_adm 
                    emp_adm = String.valueOf(hSession1.getAttribute("emp_adm")); // čitam vrednost varijable sesije
                
                if (emp_adm.equals("")) { // da li je pronađena varijabla sesije emp_adm
                    if (URL_String.contains(URL_EMP_ADM)) { // da li korisnik koristi veb sajtu za zaposlene i administratore
                        emp_adm = "true";
                        hSession1.setAttribute("emp_adm1", emp_adm);                         
                    } else if (URL_String.contains(URL_CUST)) { // ako korisnik koristi veb sajtu za kupce 
                        emp_adm = "false";
                        hSession1.setAttribute("emp_adm", emp_adm); 
                    }
                }
                
                // sessVarExists: vraća da li varijabla sesije logged_in postoji 
                // logged_in je TRUE ako je korisnik prijavljen ( zaposleni ili administrator )
                attr_found = PticaMetodi.sessVarExists(hSession1, "logged_in"); 
                if (attr_found) // ako varijabla sesije logged_in postoji
                    logged_in = String.valueOf(hSession1.getAttribute("logged_in")); 
            %>
            
            <div class="row">
                <!-- Bootstrap kolona zauzima 12 kolona na velikim desktopovima, 12 kolona na desktopovima srednje veliċine,
                     12 kolona na displejima male veličine, 12 kolona na displejima ekstra male veličine -->
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12"> 
                    <!-- navigacija -->
                    <!-- navbar-expand-md : na srednjoj tački preloma navigacija je predstavljena toggler ikonom -->
                    <nav class="navbar navbar-expand-md navbar-light bg-light">
                        <a class="navbar-brand"><img src="images/bookshelf.png"></a> <!-- logo kompanije -->
                        <a class="navbar-brand" href="AddSessVar" onclick = "cookieFillIn('index.jsp')">Ptica</a> <!-- ime kompanije -->
                        <!-- toggler ikona se koristi da isključi/uključi navigaciju -->
                        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-    
                            expanded="false" aria-label="Toggle navigation">
                            <span class="navbar-toggler-icon"></span>
                        </button>

                        <div class="collapse navbar-collapse" id="navbarSupportedContent">
                            <!-- mr-auto : ovaj deo hiperveza u navigaciji je na LEVOJ strani -->
                            <ul class="navbar-nav mr-auto">
                                
                                <%
                                    // link Pretraga se ne prikazuje na stranici za grešku
                                    if ((!(userType.equals("admin"))) && (!(userType.equals("emp"))) && (errPage.equals("false"))) {
                                %>
                                        <!-- link Pretraga u navigaciji -->
                                        <li class="nav-item">
                                            <a class="nav-link" href="AddSessVar" onclick="cookieFillIn('search_page.jsp')">Pretraga</a>
                                        </li>
                                <%
                                    }
                                %>
                                
                                <%
                                    if (((userType.equals("admin")) || (userType.equals("emp"))) && (errPage.equals("false"))) {
                                %>
                                        <!-- link Knjige u navigaciji -->
                                        <li class="nav-item dropdown">
                                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                Knjige
                                            </a>
                                            <!-- padajućem meni -->
                                            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                                <a class="dropdown-item" href="AddSessVar" onclick="cookieFillIn('index.jsp')">Najnovija izdanja</a> <!-- Najnovija izdanja link na podmeniju -->
                                                <a class="dropdown-item" href="AddSessVar" onclick="cookieFillIn('search_page.jsp')">Pretraga knjiga</a>  
                                                <div class="dropdown-divider"></div> <!-- razdelnik na padajućem meniju -->
                                                <a class="dropdown-item" href="AddSessVar" onclick="cookieFillIn('add_page.jsp')">Nova knjiga</a>  
                                                <a class="dropdown-item" href="AddSessVar" onclick="cookieFillIn('update_prev.jsp')">Ažuriranje knjige</a>  
                                                <a class="dropdown-item" href="AddSessVar" onclick="cookieFillIn('delete_title.jsp')">Brisanje knjige</a>  
                                            </div>
                                        </li>
                                <%
                                    }
                                %>
                                <!-- O nama link u navigaciji -->
                                <li class="nav-item">
                                    <a class="nav-link" href="AddSessVar" onclick="cookieFillIn('about_page.jsp')">O nama</a>
                                </li>
                                <!-- Kontakt link u navigaciji -->
                                <li class="nav-item">
                                    <a class="nav-link" href="AddSessVar" onclick="cookieFillIn('contact_page.jsp')">Kontakt</a>
                                </li>
                            </ul>
                                                            
                            <!-- ml-auto : ovaj deo linkova u navbar je na DESNOJ strani -->
                            <ul class="navbar-nav ml-auto">
                                <%
                                    if ((userType.equals("admin")) && (errPage.equals("false"))) {
                                %>    
                                        <!-- Novi nalog link u navigaciji ( navbar ) -->
                                        <li class="nav-item">
                                            <a class="nav-link" href="AddSessVar" onclick="cookieFillIn('SignUp')">Novi nalog</a>
                                        </li>
                                <% 
                                    }
                                %>
                                
                                <%
                                    // ako je korisnik prijavljen prikaži link Odjava
                                    if ((logged_in.equals("true")) && (errPage.equals("false"))) {
                                %>    
                                        <!-- Odjava link u navigaciji ( navbar ) -->
                                        <li class="nav-item">
                                            <a class="nav-link" href="LogOutServlet">Odjava</a>
                                        </li>                               
                                <%
                                    // ako je korisnik prijavljen kao administrator("admin") ili zaposleni("emp") ili korisnik koristi veb sajtu
                                    // za zaposlene ili administratore
                                    } else if (((userType.equals("admin")) || (userType.equals("emp")) || (emp_adm.equals("true"))) && (errPage.equals("false"))){
                                %>    
                                        <!-- link u navigaciji -->
                                        <li class="nav-item">
                                            <a class="nav-link" href="AddSessVar" onclick="cookieFillIn('login_inf_page.jsp')">Prijava</a>
                                        </li>
                                <%
                                    }
                                %>
                            </ul>
                        </div>
                    </nav>
                </div> <!-- završetak class="col-lg-12 col-md-12 col-sm-12 col-xs-12 -->

            </div> <!-- završetak class="row" --> 
        
            <div class="whitebckgr"> <!-- novi red - bela pozadina -->
                <div class="col">
                    &nbsp; &nbsp;
                </div>
            </div>
            <div class="whitebckgr">
                <div class="col-lg-12 col-md-12">
                    &nbsp; &nbsp;
                </div>
            </div>