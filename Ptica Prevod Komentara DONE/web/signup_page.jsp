<%-- 
    Dokument   : signup_page.jsp
    Formiran   : 06-Apr-2019, 00:42:10
    Autor      : Ingrid Farkaš
    Projekat   : Ptica  
--%>

<!-- signup_page.jsp - kada korisnik klikne na Novi nalog ( u navigaciji ) tada se poziva ova veb stranica -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ptica - Novi nalog</title>
        <!-- povezivanje sa eksternom listom stilova -->
        <link href="css/templatecss.css" rel="stylesheet" type="text/css">
    </head>
    
    <body>       
        <!-- header.jsp sadrži : logo, ime kompanije i navigaciju -->
        <%@ include file="header.jsp"%>        
        <%@ include file="signup_form.jsp"%> 
        <!-- ukljuċivanje fajla footer.jsp --> 
        <%@ include file="footer.jsp"%> 
    </body>
</html>



