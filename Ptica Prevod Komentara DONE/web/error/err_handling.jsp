<%-- 
    Dokument   : err_handling
    Formiran   : 20-Feb-2020, 11:59:05
    Autor      : Ingrid Farkaš
    Projekat   : Ptica
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="miscellaneous.PticaMetodi"%>
<%@page isErrorPage="true"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <!-- povezivanje sa eksternom listom stilova -->
        <link href="css/templatecss.css" rel="stylesheet" type="text/css">
        
        <style>
            /* stilovi za pretraživače manje od 350px; */
            /* ne prikazuje ( ili još uvek prikazuje ) tekst text pored slike zavisno od širine pretraživača */ 
            @media screen and (max-width: 350px) {
                span.pic_text {
                    display: none;
                }
            }
            
            /* stilovi za pretraživače manje od 767px: ne prikazuju prostor levo od slike u levoj koloni */
            @media screen and (max-width: 767px) {
                div.book_L {
                    display: none;
                }
            }
             
            /* stilovi za pretraživače ( na mobilnim uređajima ) većim od 350px; ( iPhone ) */
            /* ne prikazuje ( ili još uvek prikazuje ) tekst ispod slike zavisno od širine pretraživača */
            @media screen and (min-width: 350px) {
                div.pic_text_below {
                    display: none;
                }
            }
                                   
        </style>
        
        <title>Ptica</title>
    </head>
    
    <body>
        <% 
            HttpSession hSession = PticaMetodi.returnSession(request);
            
            if (PticaMetodi.sessVarExists(hSession, "fill_in")) {  
                // postavljanje vrednosti fill_in na inicijalnu vrednost ( da li postoje varijable sesije koje sadrže vrednosti input 
                // kontrola koje kasnije treba da se popune )
                hSession.setAttribute("fill_in","false");  
            }
            
            if (PticaMetodi.sessVarExists(hSession, "page_name")) { 
                // postavljam vrednost page_name na inicijalnu vrednost
                // page_name - ime veb stranice gde je korisnik bio kada je uneo email
                hSession.setAttribute("page_name", ""); 
            }
            
        %>
        <!-- ukljuċivanje fajla err_header.jsp -->
        <!-- err_header.jsp sadrži : logo, ime kompanije i navigaciju -->
        <%@ include file="err_header.jsp"%> 
        
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
                </div>
                
                <!-- Bootstrap kolona zauzima 5 kolona na velikim desktopovima i 5 kolona na desktopovima srednje veliċine -->
                <div class="col-lg-5 col-md-5"> 
                    <div class="container"> <!-- dodavanje kontejnera u Bootstrap grid -->
                        <div class="row"> <!-- dodavanje reda u Bootstrap grid -->
                            <div class="col">
                                &nbsp; &nbsp;
                                <br />
                                <br /><br /><br />
                                <br />
                                <h3 class="text-info">Ptica</h3> 
                                <br />
                                Sada menjamo veb sajtu.
                                <br />
                                <br />
                                Molimo Vas <span class="text-warning">posetite nas kasnije!</span>
                                <br />
                                <br />
                                <br />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- dodavanje novog reda; klasa whitebckgr je za postavljanje pozadine u belu boju -->
        <div class="whitebckgr">
            <div class="col">
                &nbsp; &nbsp;
            </div>
        </div> 
        <!-- ukljuċivanje fajla footer.jsp --> 
        <%@ include file="../footer.jsp"%>
    </body>
</html>
