<%-- 
    Dokument   : subscrres_content
    Formiran   : 16-Apr-2019, 16:28:06
    Autor      : Ingrid Farkaš
    Projekat   : Ptica
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="miscellaneous.PticaMetodi"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ptica - Newsletter</title>
        <script>
            function setFillIn() {
                // ako se korisnik vrati na prethodnu veb stranicu ( sa formularom ) gde je bio pre prijave na Newsletter fill_in treba da bude true 
                document.cookie = "fill_in=true;"; 
                
            }
        </script>
    </head>
    
    <body onload="setFillIn()">
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
                                <br /><br /><br /><br /><br />
                                <h3 class="text-info">Newsletter</h3>
                                <br /><br /> 
                                <%  HttpSession hSession = PticaMetodi.returnSession(request);
                                    hSession.setAttribute("subscribe", "true");
                                    String validEmail = String.valueOf(hSession.getAttribute("valid_email"));
                                    String exOccurred = "false"; // da li je došlo do izuzetka 
                                    String page_name = "";
                                    if (page_name.equalsIgnoreCase("")) // ako page_name nije postavljen u ovom skriptu čitam ga iz webpg_name 
                                        page_name = String.valueOf(hSession.getAttribute("webpg_name")); // ime veb stranice gde je korisnik bio pre prijave na Newsletter
                                    exOccurred = String.valueOf(hSession.getAttribute("db_exoccurred"));
                                    
                                    if (validEmail.equalsIgnoreCase("false"))
                                        out.print("<span class=\"text-warning\">Uneta email adresa nije validna!</span>");
                                    else if (exOccurred.equalsIgnoreCase("exists"))
                                        out.print("<span class=\"text-warning\">Uneta email adresa se već koristi!</span>");
                                    else if (exOccurred.equalsIgnoreCase("true"))
                                        out.print("<span class=\"text-warning\">Došlo je do greške prilikom pristupa bazi podataka!</span>"); 
                                    else {
                                        out.print("Poštovani, uspešno ste se prijavili na našu mejling listu!");
                                    } 

                                    if ((page_name.equalsIgnoreCase("null")) || (page_name.equalsIgnoreCase("")) || (page_name == null)) 
                                        page_name = "index.jsp";
                                %>
                                
                                <!-- posle klika na dugme prikazuje se veb stranica na kojoj je korisnik bio pre prijave na Newsletter --> 
                                <form action=<%= page_name %> method="post" > 
                                    <br /><br /><br />
                                    <!-- adding the button Subscribe, btn-info is used for defining the color of the button,
                                         form-control-sm is used for smaller size of the button -->
                                    <!-- btn-info je boja dugmeta -->
                                    <button type="submit" class="btn btn-info btn-sm" id="btnClose">Zatvori</button>
                                </form>    
                            </div> <!-- završetak class="col" -->
                            
                        </div> <!-- završetak class="row" --> 
                    </div> <!-- završetak class="container" -->
                </div> <!-- završetak class="col-lg-5 col-md-5" -->
            </div> <!-- završetak class="row" -->
        </div> <!-- završetak class="whitebckgr" -->
            
        <!-- dodavanje novog reda u Bootstrap grid; whitebckgr: postavljanje pozadine na belu boju -->
        <div class="whitebckgr">
            <div class="col">
                &nbsp; &nbsp;
            </div>
        </div> 
    </body>
</html>