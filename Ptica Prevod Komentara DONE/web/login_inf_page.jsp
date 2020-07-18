<%-- 
    Dokument   : login_inf_page.jsp
    Formiran   : 06-Oct-2019, 20:10:55
    Autor      : Ingrid Farkaš
    Projekat   : Ptica
--%>

<!-- login_info_page.jsp - kada korisnik klikne na Prijava ( u navigaciji ) tada se prikazuje ova veb stranica -->

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ptica - Prijava</title>
        <!-- povezivanje sa eksternom listom stilova -->
        <link href="css/templatecss.css" rel="stylesheet" type="text/css">
    </head>
    
    <body>
        <!-- ukljuċivanje fajla header.jsp -->
        <!-- header.jsp sadrži : logo, ime kompanije i navigaciju -->
        <%@ include file="header.jsp"%>
        <%@ include file="login_inf_info.jsp"%> 
        <!-- ukljuċivanje fajla footer.jsp --> 
        <%@ include file="footer.jsp"%> 
    </body>
</html>

