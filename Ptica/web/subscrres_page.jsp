<%-- 
    Dokument   : subscrres_page
    Formiran   : 16-Apr-2019, 16:21:18
    Autor      : Ingrid Farkaš
    Projekat   : Ptica
--%>

<!-- subscrres_page.jsp - posle unosenja email-a u footer-u kada korisnik klikne na dugme poziva se SubscrServl.java koji prikazuje ovu veb stranicu -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ptica - Newsletter</title>
        <!-- povezivanje sa eksternom listom stilova -->
        <link href="css/templatecss.css" rel="stylesheet" type="text/css">
    </head>
    <body>
        <!-- ukljuċivanje fajla header.jsp -->
        <!-- header.jsp sadrži : logo, ime kompanije i navigaciju -->
        <%@ include file="header.jsp"%>   
        <%@ include file="subscrres_content.jsp"%> 
        <!-- ukljuċivanje fajla footer.jsp -->
        <%@ include file="footer.jsp"%>
    </body>
</html>