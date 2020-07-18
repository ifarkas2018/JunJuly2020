<%-- 
    Dokument   : index
    Formiran   : 02-Sep-2018, 01:41:44
    Autor      : Ingrid Farkaš
    Projekat   : Ptica
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="miscellaneous.PticaMetodi"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <!-- povezivanje sa eksternom listom stilova -->
        <link href="css/templatecss.css" rel="stylesheet" type="text/css">
        
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
        
        <!-- ukljuċivanje fajla header.jsp -->
        <!-- header.jsp sadrži : logo, ime kompanije i navigaciju -->
         <%@ include file="header.jsp"%>
        <!-- dodajem sadržaj veb stranice -->
        <%@ include file="index_content.jsp"%>
        <!-- ukljuċivanje fajla footer.jsp -->
        <%@ include file="footer.jsp"%> 
    </body>
</html>
