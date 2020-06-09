<%-- 
    Document   : delete_title
    Formiran   : 21-Mar-2019, 14:51:52
    Author     : Ingrid Farkaš
    Project    : Ptica
--%>

<!-- delete_title.jsp - kada korisnik klikne na link Brisanje knjige ( u navigaciji ) ova stranica se prikazuje -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="miscellaneous.PticaMetodi"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ptica - Brisanje knjige</title>
        <!-- povezivanje sa eksternom listom stilova -->
        <link href="css/templatecss.css" rel="stylesheet" type="text/css">
    </head>
    <body>
        <% 
            HttpSession hSession = PticaMetodi.returnSession(request); // sesija kojoj ću dodati atribute
            hSession.setAttribute("source_name", "Brisanje knjige"); // stranica na kojoj sam sada
        %>
        <!-- ukljuċivanje fajla header.jsp -->
        <!-- header.jsp sadrži : logo, ime kompanije i navigaciju -->
        <%@ include file="header.jsp"%>
        <!-- ukljuċivanje fajla upd_del_title.jsp -->
        <%@ include file="upd_del_title.jsp" %>   
        <!-- ukljuċivanje fajla footer.jsp -->
        <!-- footer.jsp sadrži footer --> 
        <%@ include file="footer.jsp" %> 
    </body>
</html>
