<%-- 
    Dokument   : footer
    Formiran   : 02-Sep-2018, 01:51:27
    Autor      : Ingrid Farkaš
    Projekat   : Ptica
--%>

<!-- footer.jsp formira footer na veb stranici --> 
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="miscellaneous.PticaMetodi"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <script>
            
            // isEmail: vraća true ako je email važeći ( inače vraća false )
            function isEmail(email) {
                // regex pattern se koristi za validaciju email-a
                var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if(!regex.test(email)) {
                    return false;
                } else {
                    return true;
                }
            }

            // createCookie: formira kolačić sa nazivom valid_email ( vrednost je uneseni email )
            function createCookie() {
                var email = document.getElementById("subscr_email").value;
                var cookie_str = "valid_email=";
                // ako je email važeći vrednost je true
                if (isEmail(email)) {
                   cookie_str += "true;";
                } else {
                    cookie_str += "false;"; 
                }
                document.cookie = cookie_str; // formiranje kolačića sa nazivom valid_email
            }
        </script>
    </head>
    <body> 
        <%
            boolean is_attr_found;
            String isErrPage = "false"; // da li je došlo do greške 
            HttpSession hSess = PticaMetodi.returnSession(request);
            // da li se prikazuje stranica za grešku ( error page ) 
            is_attr_found = PticaMetodi.sessVarExists(hSess, "is_error"); // sessVarExists: vraća da li varijabla sesije is_error postoji u sesiji
            if (is_attr_found) { // da li je varijabla sesije sa imenom is_error pronađena 
                isErrPage = String.valueOf(hSess.getAttribute("is_error"));
            }
        %>
        
        <footer>
            <!-- footer je klasa ( u templatecss.css ) -->
            <div class="footer" align="center" id="footer">
                <div class="container"> 
                    <div class="row"> 
                        <!-- Bootstrap kolona zauzima 2 kolone na velikim desktopovima, 2 kolone na desktopovima srednje veliċine,
                             4 kolone na small ekranima, 6 kolona na extra small ekranima -->
                        <div  class="col-lg-2  col-md-2 col-sm-4 col-xs-6">
                            &nbsp; &nbsp; <!-- prazan prostor -->
                        </div>
                        <!-- Bootstrap kolona zauzima 2 kolone na velikim desktopovima, 2 kolone na desktopovima srednje veliċine,
                             4 kolone na small ekranima, 6 kolona na extra small ekranima -->
                        <div class="col-lg-2  col-md-2 col-sm-4 col-xs-6">
                            <h3> O nama </h3> <!-- naslov kolone -->
                            <!-- smaller-text je klasa koja određuje veličinu teksta -->
                            <ul class="smaller-text" >
                                <li> <a href="#"> Our Company </a> </li> <!-- link u footer-u -->
                                <li> <a href="AddSessVar" onclick = "cookieFillIn('about_page.jsp')"> O nama </a> </li>
                                <li> <a href="#"> Terms of Services </a> </li>
                                <li> <a href="#"> Our Team </a> </li>
                            </ul>
                        </div>
                       
                        <!-- Bootstrap kolona zauzima 2 kolone na velikim desktopovima, 2 kolone na desktopovima srednje veliċine -->
                        <div class="col-lg-2  col-md-2"> 
                            &nbsp; &nbsp; <!-- prazan prostor -->
                        </div>
    
                        <!-- Bootstrap kolona zauzima 1 kolonu na velikim desktopovima, 1 kolonu na desktopovima srednje veliċine -->
                        <div class="col-lg-1  col-md-1"> 
                            &nbsp; &nbsp; 
                        </div>
    
                        <!-- Bootstrap kolona zauzima 3 kolone na velikim desktopovima, 3 kolone na desktopovima srednje veliċine -->
                        <div class="col-lg-3  col-md-3"> 
                            <h3> Newsletter </h3> <!-- naslov kolone -->
                            <ul>
                                <li> 
                                    <div class="container"> 
                                        <!-- posle klika na dugme se poziva SubscrServl servlet -->
                                        <form action="SubscrServl" method="post"> 
                                            <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                                                <div class="col">
                                                    <%
                                                        if (isErrPage.equals("false")) { // nije došlo do greške
                                                    %>
                                                            <!-- input element za unošenje email-a; form-control-sm se koristi za užu kontrolu --> 
                                                            <input class="form-control form-control-sm" name="subscr_email" id="subscr_email" maxlength="35" id="subscr_email" type="text" placeholder="Email" required>
                                                    <%
                                                        } else {
                                                    %>
                                          
                                                            <!-- input element za unošenje email-a; form-control-sm se koristi za užu kontrolu --> 
                                                            <input class="form-control form-control-sm" name="subscr_email" id="subscr_email" maxlength="35" id="subscr_email" type="text" placeholder="Email" required disabled>
                                                    <%
                                                        }
                                                    %>
                                                </div>
                                            </div>
                                            
                                            <div class="row"> 
                                                <div class="col">
                                                    &nbsp; &nbsp;
                                                </div>
                                            </div>
                                            
                                            <div class="row"> <!-- novi red u Bootstrap grid-u -->
                                                <div class="col">
                                                    <%
                                                        if (isErrPage.equals("false")) { // nije došlo do greške
                                                    %>
                                                    
                                                         <!-- dodavanje dugmeta Subscribe, btn-info je boja dugmeta, form-control-sm se koristi za užu kontrolu -->
                                                         <button type="submit" class="btn btn-info btn-sm" id="btnSubscr" onclick="createCookie()">Prijavite se</button>
                                                    <%
                                                        } else { // ako je  došlo do greške tada se prikazuje DISABLED dugme
                                                    %>
                                                         <button type="submit" class="btn btn-info btn-sm" id="btnSubscr" onclick="createCookie()" disabled>Prijavite se</button>
                                                    <%
                                                        } 
                                                    %>
                                                </div>
                                            </div>
                                        </form>
                                    </div> <!-- završetak class="container" -->
                                </li>
                            </ul> 
                        </div> <!-- završetak class="col-lg-3 col-md-3" -->
                    </div> <!-- završetak class="row" -->
                    
                    <div class="row">
                        <!-- Bootstrap kolona zauzima 12 kolona na velikim desktopovima, 12 kolone na desktopovima srednje veliċine -->
                        <div class="col-lg-12 col-md-12">
                            &nbsp; &nbsp; <!-- przan prostor -->
                        </div>
                    </div>
                </div> <!-- završetak class="container" -->
            </div> <!-- završetak class="footer" --> 
                    
            <div class="footer"> <!-- donji deo footer-a -->
                <div class="container">
                    <div class="row">
                        <!-- Bootstrap kolona zauzima 12 kolone na velikim desktopovima, 12 kolona na desktopovima srednje veliċine,
                             12 kolone na small ekranima, 12 kolona na extra small ekranima -->
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            &nbsp; &nbsp; <!-- prazan prostor -->
                        </div>
                    </div>
                    <div class="container text-center">
                        <!-- Bootstrap kolona zauzima 12 kolone na velikim desktopovima, 12 kolona na desktopovima srednje veliċine,
                             12 kolone na small ekranima, 12 kolona na extra small ekranima -->
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <div class="smaller-text"> Ptica d.o.o. Resavska 58, Beograd Matični broj: 28945197 </div>
                            <!-- dodavanje copyright informacije na dnu footer-a -->
                            <div class="smaller-text"> Copyright &copy; Ptica 2018 </div>
                        </div>
                    </div>
                </div> <!-- završetak the class="container" -->
            </div> <!-- završetak class="footer" -->
        </footer> 
    </body>
</html>
