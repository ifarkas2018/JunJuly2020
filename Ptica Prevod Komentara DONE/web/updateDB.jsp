<%-- 
    Dokument   : updateDB poziva se iz update_form.jsp
    Formiran   : 14-Mar-2019, 04:09:42
    Autor      : Ingrid Farkaš
    Projekat   : Ptica
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="connection.ConnectionManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="miscellaneous.PticaMetodi"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/templatecss.css" type="text/css" rel="stylesheet"/>
        <title>Ptica - Ažuriranje knjige</title>
        
        <%@ include file="header.jsp"%>
    </head>
    
    <body>
        <%!
            // za izdavača sa imenom publ_name vraća broj izdavača 
            String determinePublID(String publ_name, Statement stmt) { 
                try {
                    // formiranje upita SELECT publ_id, city FROM publisher WHERE publ_name='...' AND city='...';
                    String publid = ""; // izdavača broj
                    String rs_query = "SELECT publ_id"; 
                    rs_query += " FROM publisher WHERE publ_name='" + publ_name + "'";
                    rs_query += ";";   
                    
                    // izvršavanje upita
                    ResultSet rs = stmt.executeQuery(rs_query);
                    
                    // ako rezultat izvršavanja upita nije prazan, pročitaj broj izdavača
                    if (rs.next()) 
                        publid = rs.getString("publ_id");
                    return publid;
                } catch (SQLException ex) {
                    return ""; // ako je došlo do izuzetka vraća broj izdavača = ""
                }
            }
            
            // ako autor sa imenom auth_name postoji vraća id autora
            String determineAuthID(String auth_name, Statement stmt) { 
                try {
                    // formiranje upita SELECT au_id FROM author WHERE au_name='...';
                    String authid = ""; // broj autora
                    String rs_query = "SELECT au_id "; 
                    rs_query += "FROM author WHERE au_name='" + auth_name + "'";
                    rs_query += ";";   
                    // izvršavanje upita
                    ResultSet rs = stmt.executeQuery(rs_query);
                    // ako rezultat izvršavanja upita nije prazan, pročitaj broj autora
                    if (rs.next()) 
                        authid = rs.getString("au_id");
                    return authid;
                } catch ( SQLException ex) {
                    return ""; // ako je došlo do izuzetka vraća broj autora = ""
                }
            }
        %>   
        
        <%
            // sesija kojoj ću dodati atribute
            HttpSession hSession = request.getSession();
            try { 
                String form_title = request.getParameter("title"); // naslov
                String form_auth = request.getParameter("author"); // autor
                String form_isbn = request.getParameter("isbn"); // isbn 
                String form_price = request.getParameter("price"); // cena
                String form_pages = request.getParameter("pages"); // broj stranica
                String form_categ = request.getParameter("category"); // žanr
                String form_descr = request.getParameter("descr"); // opis knjige
                String form_publ = request.getParameter("publisher"); // ime izdavača
                String form_yrpublished = request.getParameter("yrpublished"); // godina izdavanja
                
                form_price = form_price.replace(".", "");
                form_price = form_price.replace(",", "."); // tip podatka za cenu je u bazi float

                // deleteSpaces: uklanja prazan prostor sa početka i kraja stringa i zamenjuje 2 ili više prazna mesta ( unutar stringa )
                // sa jednim praznim mestom
                form_title = PticaMetodi.deleteSpaces(form_title);
                form_auth = PticaMetodi.deleteSpaces(form_auth);
                form_isbn = PticaMetodi.deleteSpaces(form_isbn);
                form_price = PticaMetodi.deleteSpaces(form_price);
                form_pages = PticaMetodi.deleteSpaces(form_pages);
                form_publ = PticaMetodi.deleteSpaces(form_publ);
                form_descr = PticaMetodi.deleteSpaces(form_descr);

                // addBacksl zamenjuje svaku pojavu \ sa \\\\ i zamenjuje svaku pojavu ' sa \\'
                form_title = PticaMetodi.addBacksl(form_title);
                form_auth = PticaMetodi.addBacksl(form_auth);
                form_publ = PticaMetodi.addBacksl(form_publ);
                form_descr = PticaMetodi.addBacksl(form_descr);

                Connection con = ConnectionManager.getConnection(); // povezivanje sa bazom
                Statement stmt = con.createStatement();

                String rs_query=""; 
                ResultSet rs; // objekat gde se čuva rezultat upita
                String auid = ""; // broj autora
                String publid = ""; // broj izdavača  
                String bookid = ""; // broj knjige

                // ODREĐIVANJE ID IZDAVAČA 
                if (!((form_publ.equalsIgnoreCase("")))) {
                    // determinePublID : formiranje i izvršavanje upita SELECT publ_id, city FROM publisher WHERE publ_name='...' AND city='...';
                    publid = determinePublID(form_publ, stmt); // određuje ID izdavača za zadati izdavač ( u tom gradu )
                     

                    if (publid.equals("")) { // ako izdavač sa tim imenom ne postoji, tada se novi izdavač dodaje tabeli publisher 
                        
                        // formiranje stringa "INSERT INTO publisher(publ_name, city) VALUES ('...', '...');
                        // i izvršavanje upita
                        rs_query = "INSERT INTO publisher(publ_name";
                        rs_query += ") VALUES ('" + form_publ + "'";
                        rs_query += ");";

                        PreparedStatement preparedStmt = con.prepareStatement(rs_query);
                        preparedStmt.execute();

                        // određivanje publ_id za dodati izdavač
                        publid = determinePublID(form_publ, stmt);
                    }
                }

                // ODREĐIVANJE ID AUTORA
                if (!((form_auth.equalsIgnoreCase("")))) {
                    // determineAuthID : formiranje i izvršavanje upita SELECT au_id FROM author WHERE au_name='...';
                    auid = determineAuthID(form_auth, stmt); // određivanje ID autora za tog authora
                    // ako autor sa tim imenom ne postoji, dodaj ga tabeli autor
                    if (auid.equals("")) { 
                        // formiranje stringa "INSERT INTO author(au_name) VALUES ('...');
                        // i izvršavanje upita
                        rs_query = "INSERT INTO author(au_name) ";
                        rs_query += "VALUES ('" + form_auth + "');";

                        PreparedStatement preparedStmt = con.prepareStatement(rs_query);
                        preparedStmt.execute();
                        // određivanje publ_id za dodatog izdavača
                        auid = determineAuthID(form_auth, stmt);
                    }
                }

                // čitaj ID knjige iz sesije
                bookid = String.valueOf(hSession.getAttribute("bookid"));

                // TABELA book : upit update
                boolean is_added = false; // da li je ime neke kolone dodato upitu update
                String query = "update book set ";

                // ako je ime autora novo, dodaj upitu au_id = auid
                // auid sam odredila pre pozivom metoda determineAuthID(form_auth, stmt)
                if (!((form_auth.equalsIgnoreCase("")))) {
                    query += "au_id='" + auid + "'";
                    is_added = true; // ime kolone je dodato upitu update 
                }

                // ako je ime idavača novo dodaj upitu publ_id = publid
                // publid sam odredila pre pozivom metoda determinePublID(form_publ, stmt)
                if (!(form_publ.equalsIgnoreCase("")))  {
                    // ako je prethodno dodato au_id = '...' tada dodajem zarez
                    if (is_added){
                        query += ",";
                    }
                    query += "publ_id='" + publid + "'";
                    is_added = true; // ime kolone je bilo dodato upitu update
                }

                // ako postoji novi naslov tada dodaj upitu title = form_title
                if (!((form_title.equalsIgnoreCase("")))) {
                    // ako je prethodno dodato publ_id = '...' ( ili neka druga kolona ) tada dodajem zarez
                    if (is_added){
                        query += ",";
                    }
                    query += "title='" + form_title + "'";
                    is_added = true;
                }

                // ako je isbn ima novu vrednost tada dodaj upitu isbn = form_isbn
                if (!((form_isbn.equalsIgnoreCase("")))) {
                    // ako je prethodno dodato title='...' tada dodajem zarez
                    if (is_added){
                        query += ",";
                    }
                    query += "isbn='" + form_isbn + "'";
                    is_added = true;
                }

                // ako cena ima novu vrednost tada dodaj upitu price = form_price
                form_price = form_price.replaceAll(" ", "");
                if (!((form_price.equalsIgnoreCase("")))) {
                    // ako je prethodno dodato isbn = '...' ( ili neka druga kolona ) tada dodajem zarez
                    if (is_added){
                        query += ",";
                    }
                    query += "price='" + form_price + "'";
                    is_added = true;
                }

                // ako broj strana ima novu vrednost tada dodaj upitu pages = form_pages
                if (!((form_pages.equalsIgnoreCase("")))) {
                    // ako je prethodno dodato price = '...' ( ili neka druga kolona ) tada dodajem zarez
                    if (is_added){
                        query += ",";
                    }
                    query += "pages='" + form_pages + "'";
                    is_added = true;
                }

                // ako žanr ima novu vrednost tada dodaj upitu category = form_categ
                if (!((form_categ.equalsIgnoreCase("")))) {
                    // ako je prethodno dodato pages = '...' ( ili neka druga kolona ) tada dodajem zarez
                    if (is_added){
                        query += ",";
                    }
                    query += "category='" + form_categ + "'";
                    is_added = true;
                }

                // ako opis ima novu vrednost tada dodaj upitu descr = form_descr
                if (!((form_descr.equalsIgnoreCase("")))) {
                    // ako je prethodno dodato category = '...' ( ili neka druga kolona ) tada dodajem zarez
                    if (is_added){
                        query += ",";
                    }
                    query += "descr='" + form_descr + "'";
                    is_added = true;
                }

                // ako godina izdavanja ima novu vrednost tada dodaj upitu publ_year = form_yrpublished
                if (!((form_yrpublished.equalsIgnoreCase("")))) {
                    // ako je prethodno dodato category = '...' ( ili neka druga kolona ) tada dodajem zarez
                    if (is_added){
                        query += ",";
                    }
                    query += "publ_year='" + form_yrpublished + "'";
                    is_added = true;
                }

                query += " where book_id='" + bookid + "';";           

                PreparedStatement preparedStmt = con.prepareStatement(query);
                preparedStmt.execute();

                // prikaži veb stranicu sa porukom da je knjiga uspešno ažurirana u bazi
                hSession.setAttribute("source_name", "Ažuriranje knjige"); // naziv veb strane na kojoj sam sada
                String sTitle = "Ažuriranje knjige"; // koristi se za prosleđivanje naslova 
                String sMessage = "SUCC_UPDATE"; // koristi se za prosleđivanje poruke
                hSession.setAttribute("message", sMessage);
                hSession.setAttribute("title", sTitle);
                response.sendRedirect("error_succ.jsp"); // preusmeravanje na error_succ.jsp    
        %>
        
        <br>
        <br>
        
        <%
            out.print(" ");
        %>
             
        <%
            } catch(Exception e) { // ako je došlo  do izuzetka postavljam varijable sesije
                String sTitle = "Greška"; // koristi se za prosleđivanje naslova
                String sMessage = "ERR_UPDATE"; // koristi se za prosleđivanje poruke
                hSession.setAttribute("source_name", "Ažuriranje knjige"); // naziv veb strane na kojoj sam sada
                hSession.setAttribute("message", sMessage); 
                hSession.setAttribute("title", sTitle); 
                response.sendRedirect("error_succ.jsp"); // preusmeravanje na error_succ.jsp   
            }
        %>
       
    <%@ include file="footer.jsp"%>
    </body>
</html>