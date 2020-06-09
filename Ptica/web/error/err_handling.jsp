<%-- 
    Document   : err_handling
    Formiran : 20-Feb-2020, 11:59:05
    Author     : Ingrid Farkaš
    Project    : Ptica
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="miscellaneous.PticaMetodi"%>
<%@page isErrorPage="true"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <!-- link to the external stylesheet -->
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
             
            /* stilovi za pretraživače ( na mobilnim uređajima ) većim od 350px; (iPhone) */
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
                // set the value of fill_in to default (whether there are some session var. which contain values of the input fields
                // that need later to be filled in)
                hSession.setAttribute("fill_in","false");  
            }
            
            if (PticaMetodi.sessVarExists(hSession, "page_name")) { 
                // set the value of the page_name to default
                // page_name - name of the page where the user was just before he entered the email. 
                hSession.setAttribute("page_name", ""); 
            }
            
        %>
        <!-- including the file header.jsp into this file -->
        <!-- header.jsp contains - company logo, company name and the navigation bar -->
        <%@ include file="err_header.jsp"%> 
        
        <!-- adding a new row to the Bootstrap grid; class whitebckgr is for setting the background to white -->
        <div class="whitebckgr">
            <div class="row"> <!-- adding a new row to the Bootstrap grid -->
                <!-- the Bootstrap column takes 6 columns on the large desktops and 6 columns on the medium sized desktops -->
                <div class="col-lg-6 col-md-6"> 
                    <br /><br />
                    <div> 
                        <!-- horizontally centering the picture using center-image, img-fluid is for responsive image -->
                        <img src="images/books.png" class="img-fluid center-image" alt="slika sa knjigama" title="slika sa knjigama"> 
                    </div>
                </div>
                
                <!-- the Bootstrap column takes 5 columns on the large desktops and 5 columns on the medium sized desktops -->
                <div class="col-lg-5 col-md-5"> 
                    <div class="container"> <!-- adding the container to the Bootstrap grid -->
                        <div class="row"> <!-- adding a new row to the Bootstrap grid -->
                            <div class="col">
                                &nbsp; &nbsp;
                                <br />
                                <br /><br /><br />
                                <br />
                                <h3 class="text-info">Ptica</h3> <!-- title on the web page -->
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
        <!-- adding a new row; class whitebckgr is for setting the background to white -->
        <div class="whitebckgr">
            <div class="col">
                &nbsp; &nbsp;
            </div>
        </div> 
        <!-- including the file footer.jsp into this file -->
        <!-- footer.jsp contains the footer of the web page --> 
        <%@ include file="../footer.jsp"%>
    </body>
</html>
