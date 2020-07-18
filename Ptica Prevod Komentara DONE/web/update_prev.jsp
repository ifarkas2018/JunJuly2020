<%-- 
    Dokument   : update_prev
    Formiran   : 14-Mar-2019, 04:56:04
    Autor      : Ingrid Farkaš
    Projekat   : Ptica
--%>

<!-- update_prev.jsp - kada korisnik klikne na Ažuriranje knjige ( navigacija ) prikazuje se ova veb stranica -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ptica - Ažuriranje knjige</title>
        <!-- povezivanje sa eksternom listom stilova -->
        <link href="css/templatecss.css" rel="stylesheet" type="text/css">
    </head>

    <body>
        <% 
            HttpSession hSession = PticaMetodi.returnSession(request);
            hSession.setAttribute("source_name", "Ažuriranje knjige"); // stranica na kojoj sam sada
        %>
        
        <!-- ukljuċivanje fajla header.jsp -->
        <!-- header.jsp sadrži - logo i ime kompanije i navigaciju -->
        <%@ include file="header.jsp" %>
        <%@ include file="upd_del_title.jsp" %>
        <!-- footer.jsp sadrži footer --> 
        <%@ include file="footer.jsp" %> 
    </body>
</html>

