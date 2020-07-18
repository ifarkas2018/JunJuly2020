<%-- 
    Dokument   : err_header
    Formiran   : 20-Feb-2020, 11:59:30
    Autor      : Ingrid Farkaš
    Projekat   : Ptica 
--%>

<%@page import="java.util.Enumeration"%>
<%@page import="miscellaneous.PticaMetodi"%>

<!-- err_header.jsp formira logo, ime kompanije i navigaciju -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>           
        <!-- meta elementi -->
        <!-- karakter set -->
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <!-- ključne reči koje se koriste prilikom Internet pretraživanja -->
        <meta name="keywords" content="Knjižara u Beogradu i u Novom Sadu, Internet knjižara">
        <!-- meta tag koji se koristi za opis i svrhu veb sajte --> 
        <meta name="description" content="Razgledanje širokog izbora knjiga i kupovina knjiga">
        <meta name="author" content="Ingrid Farkaš"> 
        <!-- koristi se za responsivne veb stranice na uređajima sa različitom veličinom displeja -->
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
                        <img class="img-logo" src="images/bookshelf.png" alt="Logo Ptice" title="Logo Ptice">  
                                    
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
                 HttpSession hSession1 = PticaMetodi.returnSession(request);
                 hSession1.setAttribute("is_error", "true"); // koristi se u O nama, Kontakt tako da se ne pojavljuje Pretraga ( navigacija )            
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
                                <!-- O nama link u navigaciji -->
                                <li class="nav-item">
                                    <a class="nav-link" href="AddSessVar" onclick="cookieFillIn('about_page.jsp')">O nama</a>
                                </li>
                                
                                <!-- Kontakt link u navigaciji -->
                                <li class="nav-item">
                                    <a class="nav-link" href="AddSessVar" onclick="cookieFillIn('contact_page.jsp')">Kontakt</a>
                                </li>
                            </ul>
                                                            
                        </div>
                    </nav>
                </div> <!-- završetak class="col-lg-12 col-md-12 col-sm-12 col-xs-12 -->
            </div> <!-- završetak class="row" --> 
        
            <div class="whitebckgr">
                <div class="col-lg-12 col-md-12">
                    &nbsp; &nbsp; 
                </div>
            </div>
