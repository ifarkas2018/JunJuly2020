<%-- 
    Dokument   : about_info
    Formiran    : 12-May-2019, 05:30:48
    Autor      : Ingrid Farkaš
    Project    : Ptica
--%>

<%@page contentType = "text/html" pageEncoding = "UTF-8"%>
<%@page import = "miscellaneous.PticaMetodi"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body>
        <%
            HttpSession hSession = PticaMetodi.returnSession(request);
            hSession.setAttribute("webpg_name", "about_page.jsp");
            // postavljanje varijable sesije na inicijalnu vrednost: ako je korisnik završio prijavu na Newsletter, formular na SLEDEĆOJ
            // veb stranici treba da pokaže prethodne vrednosti
            hSession.setAttribute("subscribe", "false"); 
        %>
        <!-- dodavanje novog reda u Bootstrap grid: klasa whitebckgr postavlja pozadinu u belu boju -->
        <div class="whitebckgr">
            <div class="row"> 
                <!-- Bootstrap kolona zauzima 6 kolona na velikim desktopovima i 6 kolona na desktopovima srednje veliċine -->
                <div class="col-lg-6 col-md-6"> 
                    <br /><br />
                    <div> 
                        <!-- center-image postavlja sliku u sredinu ( horizontalno ), img-fluid je za responzivan image -->
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
                                <span class="text-info">
                                    <h3>O nama</h3>
                                </span>
                                <br/>
                                <p>
                                    Lanac knjižara Ptica je osnovan 2010 u Beogradu. Knjižara ima veoma širok izbor knjiga različitih žanrova uključujući
                                    beletristiku, stručnu literaturu, popularnu nauku, umetnost, dečje knjige i sve što poželite u zavisnosti od afiniteta.
                                </p>
                                <p>  
                                    Smeštena u centru grada Ptica ima veoma toplu i prijateljsku atmosferu gde se ljubitelji knjiga sreću i uživaju
                                    u razgledanju i kupovini knjiga uz šolju kafe ili čaja. 
                                </p>
                                <p>
                                    Ptica je mesto gde se ljubitelji knjiga sreću da istražuju knjige i da razmenjuju ideje i misli. Naše ljubazno 
                                    osoblje je uvek tu da odgovori na Vaša pitanja i da pronađu knjige koje Vas zanimaju.
                                </p>
                                <p>  
                                    Ako nemate vremena ili niste u mogućnosti da posetite jednu od naših prodavnica molimo Vas posetite našu veb 
                                    sajtu, pretražite širok izbor knjiga i poručite knjige na veb sajti ili na telefonu. 
                                </p>
                                <p>
                                    Ako ste u mogućnosti da posetite jednu od naših prodavnica dođite i uživajte u prodavnici sa veoma prijatnom
                                    atmosferom koja je veoma jedinstvena gde možete naći kjnige koje su Vam potrebne ili knjige koje nisu neophodne ali koje 
                                    biste hteli da pročitate.
                                </p>
                            </div> <!-- završetak class="col" -->
                        </div> <!-- završetak class="row" --> 
                    </div> <!-- završetak class="container" -->
                </div> <!-- završetak class="col-lg-5 col-md-5" -->
            </div> <!-- završetak class="row" -->
        </div> <!-- završetak class="whitebckgr" -->
            
        <!-- dodavanje novog reda; klasa whitebckgr je za postavljanje pozadine u belu boju -->
        <div class = "whitebckgr">
            <div class = "col">
                &nbsp; &nbsp;
            </div>
        </div> 
    </body>
</html>

