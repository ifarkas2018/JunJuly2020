<%-- 
    Dokument   : contact_page
    Formiran   : 10-Apr-2019, 19:45:25
    Autor      : Ingrid Farkaš
    Projekat   : Ptica
--%>

<!-- contact_page.jsp - kada korisnik klikne na Kontakt ( u navigaciji ) prikazuje se ova veb stranica -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ptica - Kontakt</title>
        <!-- povezivanje sa eksternom listom stilova -->
        <link href="css/templatecss.css" rel="stylesheet" type="text/css">
    </head>
    <body>
        <!-- ukljuċivanje fajla header.jsp -->
        <!-- header.jsp sadrži : logo, ime kompanije i navigaciju -->
        <%@ include file="header.jsp"%>
        <%@ include file="contact_info.jsp"%> 
        <!-- ukljuċivanje fajla footer.jsp --> 
        <%@ include file="footer.jsp"%> 
    </body>
</html>
