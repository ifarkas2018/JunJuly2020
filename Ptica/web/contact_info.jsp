<%-- 
    Document   : contact_info
    Formiran   : 10-Apr-2019, 19:49:41
    Author     : Ingrid Farkaš
    Project    : Ptica
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="miscellaneous.PticaMetodi"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/templatecss.css">
        <title>Ptica - Kontakt</title>
      
        <!-- interna lista stilova -->
        <style>
      
            /* boja email hiperveze nakon što je kliknuta */
            .email a:visited {
                color: rgb(180, 187, 184) !important;  /* svetlo siva */ 
            } 
            
            /* boja email hiperveze nakon što korisnik postavi na nju miš */
            .email a:hover, a:active {
                color: #7F8C8D !important;    
            } 
            
            /* boja email hiperveze */ 
            .email a {
                color: #17A2B8 !important;  
            }
      
        </style>
        
    </head>
        <%
            HttpSession hSession = PticaMetodi.returnSession(request);
            hSession.setAttribute("webpg_name", "contact_page.jsp");
            // postavljanje vrednosti varijabli sesije na inicijalnu vrednost: ako je korisnik završio prijavu na Newsletter,
            // obrazac na sledećoj veb stranici ne treba da prikaže prethdne vrednosti
            hSession.setAttribute("subscribe", "false"); 
        %>
            <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                <!-- Bootstrap kolona zauzima 6 kolona na velikim desktopovima i 6 kolona na desktopovima srednje veliċine -->
                <div class="col-lg-6 col-md-6"> 
                    <br /><br />
                    <div> 
                        <!-- center-image postavlja sliku u sredinu ( horizontalno ), img-fluid je za responsivan image -->
                        <img src="images/books.png" class="img-fluid center-image" alt="slika sa knjigama" title="slika sa knjigama"> 
                    </div>
                </div>
                
                <!-- Bootstrap kolona zauzima 6 kolona na velikim desktopovima i 6 kolona na desktopovima srednje veliċine -->
                <div class="col-lg-5 col-md-5"> 
                    <div class="container"> <!-- dodavanje kontejnera u Bootstrap grid -->
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col">
                                &nbsp; &nbsp;
                                <br />
                                <h3  class="text-info">Kontakt</h3>
                                <br/>
                                <!-- podaci o prodavnici - Beograd -->
                                <span class="text-warning">
                                    <font size="+2">Beograd</font>
                                </span>
                                <br />
                                Resavska 58, Beograd <br/>
                                Email: 
                                <span class="email">
                                    <a href="mailto:ptica.beograd@ptica.com?subject=Feedback&body=Message">ptica.beograd@ptica.com</a>
                                </span>
                                <br />
                                <br />
                                <!-- radno vreme ( u tabeli ) -->
                                <table class="table table-bordered table-sm">
                                    <thead>
                                        <tr class="table-active">
                                          <th scope="col" colspan="2">Radno vreme</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="table-light">
                                          <th scope="row">Ponedeljak - Petak</th>
                                          <td>10:00 - 21:30</td>
                                        </tr>
                                        <tr class="table-light">
                                          <th scope="row">Subota</th>
                                          <td>10:00 - 21:00</td>
                                        </tr>
                                        <tr class="table-light"> 
                                          <th scope="row">Nedelja</th>
                                          <td>10:00 - 18:00</td>
                                        </tr>
                                    </tbody>
                                </table>
                                <br />
                                
                                <!-- podaci o prodavnici - Novi Sad -->
                                <span class="text-warning">
                                    <font size="+2">Novi Sad</font><br />
                                </span>
                                Zmaj Jovina 15, Novi Sad <br />
                                
                                Email: 
                                <span class="email">
                                    <a href="mailto:ptica.novisad@ptica.com?subject=Feedback&body=Message">ptica.novisad@ptica.com</a>
                                </span>
                                    
                                <br />
                                <br />
                                
                                <!-- radno vreme ( u tabeli ) -->
                                <table class="table table-bordered table-sm">
                                    <thead >
                                        <tr class="table-active">
                                            <th scope="col" colspan="2">Radno vreme</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="table-light">
                                            <th scope="row">Ponedeljak - Petak</th>
                                            <td>7:00 - 21:30</td>
                                        </tr>
                                        <tr class="table-light">
                                            <th scope="row">Subota</th>
                                            <td>9:00 - 17:00</td>
                                        </tr>
                                        <tr class="table-light">
                                            <th scope="row">Nedelja</th>
                                            <td>9:00 - 17:00</td>
                                        </tr>
                                    </tbody>
                                 </table>
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