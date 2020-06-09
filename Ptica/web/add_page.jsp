<%-- 
    Dokument   : add_page
    Formiran   : 08-Nov-2018, 13:08:01
    Autor      : Ingrid Farkaš
    Projekat   : Ptica
--%>

<!-- add_page.jsp - ova veb stranica se prikazuje kada korisnik klikne na link Nova knjiga ( u navigaciji ) -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ptica - Nova knjiga</title>
        <!-- povezivanje sa eksternom listom stilova -->
        <link href="css/templatecss.css" rel="stylesheet" type="text/css">
    </head>
    <body>
        <!-- ukljuċivanje fajla header.jsp -->
        <!-- header.jsp sadrži : logo, ime kompanije i navigaciju -->
        <%@ include file="header.jsp"%>
        <%@ include file="add_form.jsp"%> 
        <!-- ukljuċivanje fajla footer.jsp --> 
        <%@ include file="footer.jsp"%> 
    </body>
</html>
