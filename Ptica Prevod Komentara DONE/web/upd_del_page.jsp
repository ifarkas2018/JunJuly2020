<%-- 
    Dokument   : upd_del_page
    Formiran   : 12-March-2019, 16:15:01
    Autor      : Ingrid Farkaš
    Projekat   : Ptica
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="connection.ConnectionManager"%>
<%@page import="miscellaneous.PticaMetodi"%>

<!-- upd_del_page.jsp - prikazuje se kada korisnik klikne na dugme Pošalji na upd_del_title.jsp -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
       <%
            HttpSession hSession = PticaMetodi.returnSession(request);    
            String source1 = (String)hSession.getAttribute("source_name"); // naziv veb strane na kojoj sam sada
        %>
        
        <title>Ptica - <%= source1 %></title>
        <!-- povezivanje sa eksternom listom stilova -->
        <link href="css/templatecss.css" rel="stylesheet" type="text/css">
    </head>

    <body>
        <%
            String fillIn = "false"; // da li varijable sesije sadrže vrednosti polja ( u obrazcu update_prev.jsp )
            String rs_query = ""; 
            String prev_title = "";
            String prev_auth = "";
            String prev_isbn = "";
            ResultSet rs; // objekat u kome se čuva rezultat upita
            
            try {
                
                Connection con = ConnectionManager.getConnection(); // povezivanje sa bazom
                Statement stmt = con.createStatement();

                // ako varijabla sesije fill_in postoji tada je pročitaj
                if (PticaMetodi.sessVarExists(hSession, "fill_in")) {
                    fillIn = String.valueOf(hSession.getAttribute("fill_in"));
                } 
                
                // ako korisnik nije prethodno učitao ovu veb stranicu i uneo email ( Newsletter ) tada je prethodno učitao 
                // upd_del_title.jsp sa naslovom, autorom, isbn-om ( inače je uneo email adresu a ne naslov, autor, isbn ) 
                // pročitaj ih
                if (fillIn.equalsIgnoreCase("false")) { 
                    prev_title = request.getParameter("prev_title"); // naslov ( upd_del_title.jsp )
                    prev_auth = request.getParameter("prev_author"); // autor ( upd_del_title.jsp )
                    prev_isbn = request.getParameter("prev_isbn"); // isbn ( upd_del_title.jsp )
                    
                    // deleteSpaces: uklanja prazan prostor sa početka i kraja stringa i zamenjuje 2 ili više prazna mesta ( unutar
                    // stringa ) sa jednim praznim mestom
                    prev_title = PticaMetodi.deleteSpaces(prev_title);
                    prev_auth = PticaMetodi.deleteSpaces(prev_auth);
                    prev_isbn = PticaMetodi.deleteSpaces(prev_isbn);
                    
                    // addBacksl : zamenjuje svaku pojavu \ sa \\\\ i zamenjuje svaku pojavu ' sa \\'
                    prev_title = PticaMetodi.addBacksl(prev_title);
                    prev_auth = PticaMetodi.addBacksl(prev_auth);
                    
                    // dodaj sesiji prev_title, prev_auth, prev_isbn
                    hSession.setAttribute("prev_title", prev_title); // PRETHODNI naslov knjige
                    hSession.setAttribute("prev_auth", prev_auth); // prethodni autor
                    hSession.setAttribute("prev_isbn", prev_isbn); // prethodni isbn
                } else {
                    // ako je fillIn true znači da je korisnik prethodno učitao ovu stranicu ( varijable sesije su bile postavljene ),
                    // posle toga on je uneo email adresu ( Newsletter ). Sada treba da pročitam varijable sesije.
                    prev_title = String.valueOf(hSession.getAttribute("prev_title")); // PRETHODNI naslov knjige
                    prev_auth = String.valueOf(hSession.getAttribute("prev_auth")); // pročitaj autora 
                    prev_isbn = String.valueOf(hSession.getAttribute("prev_isbn")); // pročitaj isbn
                }
                
                String bookid = ""; // id knjige
                
                // traženje book_id za knjigu sa naslovom prev_title, autorom prev_auth, isbn-om prev_isbn
                // formiranje upita :
                // SELECT b.book_id,
                // FROM book b, author a
                // WHERE b.au_id = a.au_id AND b.isbn = 'prev_isbn' AND b.title = 'prev_title' AND a.au_name = 'prev_auth';
                rs_query = "SELECT b.book_id FROM book b, author a WHERE b.au_id = a.au_id";
                
                // dodavanje autora upitu 
                if (!((prev_auth.equalsIgnoreCase("")))) {
                    rs_query += " AND a.au_name = "; 
                    rs_query += "'" + prev_auth + "'";
                }
                
                // dodavanje naslova upitu 
                if (!((prev_title.equalsIgnoreCase("")))) {
                    rs_query +=" AND b.title = ";
                    rs_query += "'" + prev_title + "'";
                }
                
                // dodavanje isbn-a upitu
                if (!((prev_isbn.equalsIgnoreCase("")))) {
                    rs_query += " AND b.isbn ='" + prev_isbn + "'";
                }
                
                rs_query += ";";
                rs = stmt.executeQuery(rs_query);
                
                // ako rezultat upita ima bar jedan slog
                if (rs.next()) {
                    // nalazim book_id za uneseni naslov, autor, isbn
                    bookid = rs.getString("book_id");
                    hSession.setAttribute("bookid", bookid); // čuvam book id u varijabli sesije bookid
                } else {
                    String sTitle = "";
                    bookid = "";
                    // prikaži veb stranicu sa porukom da se knjiga ne može naći u bazi podataka               
                    if (source1.equalsIgnoreCase("Brisanje knjige")) {
                        hSession.setAttribute("source_name", "Brisanje knjige"); // naziv veb strane na kojoj sam sada
                    } else if (source1.equalsIgnoreCase("Ažuriranje knjige")) {
                        hSession.setAttribute("source_name", "Ažuriranje knjige"); // naziv veb strane na kojoj sam sada
                    }
                    String sMessage = "ERR_NO_BOOKID"; // koristi se za prosleđivanje poruke
                    sTitle = "Greška"; // koristi se za prosleđivanje naslova
                    hSession.setAttribute("message", sMessage);
                    hSession.setAttribute("title", sTitle);
                    response.sendRedirect("error_succ.jsp"); // preusmeravanje na error_succ.jsp    
                }
            } catch (Exception e){
                String sTitle = "Greška"; // koristi se za prosleđivanje naslova
                String sMessage = "ERR_DB"; // koristi se za prosleđivanje poruke
                if (source1.equalsIgnoreCase("Ažuriranje knjige"))
                    hSession.setAttribute("source_name", "Ažuriranje knjige"); // naziv veb strane na kojoj sam sada
                else
                    hSession.setAttribute("source_name", "Brisanje knjige"); // naziv veb strane na kojoj sam sada
                hSession.setAttribute("message", sMessage); 
                hSession.setAttribute("title", sTitle); 
                response.sendRedirect("error_succ.jsp"); // preusmeravanje na error_succ.jsp  
            }
        %>
        
        <!-- header.jsp sadrži - logo i ime kompanije i navigaciju -->
        <%@ include file="header.jsp"%>
        <%@ include file="upd_del_form.jsp"%> 
        <!-- footer.jsp sadrži footer -->  
        <%@ include file="footer.jsp"%>
    </body>
</html>
