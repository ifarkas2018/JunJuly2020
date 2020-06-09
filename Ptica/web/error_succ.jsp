<%-- 
    Dokument   : error_succ.jsp
    Formiran   : 19-Nov-2018, 02:31:59
    Autor      : Ingrid Farkaš
    Projekat   : Ptica
--%>

<!-- error_succ.jsp prikazuje poruku o grešci ili uspešno izvršenoj operaciji -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="miscellaneous.PticaMetodi"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%
            HttpSession hSession = PticaMetodi.returnSession(request);
            // ime veb stranice koja treba da se prikaže ako korisnik unese email ( prijava na Newsletter )
            hSession.setAttribute("webpg_name", "error_succ.jsp");
            // ako je korisnik sada završio prijavu za Newsletter, obrazac na sledećoj veb stranici ne treba da prikaže prethdne vrednosti
            hSession.setAttribute("subscribe", "false");
            
            // title - prosleđuje se od jedne veb stranice do druge
            String sTitle = (String)hSession.getAttribute("title");
             
            String sSource = (String)hSession.getAttribute("source_name");
            // postavi naslov ove veb stranice zavisno od opearcije koja se izvršava
            if (sSource.equalsIgnoreCase("Nova knjiga")) {
                out.print("<title>Ptica - Nova knjiga</title>"); 
            } else if (sSource.equalsIgnoreCase("Novi naslovi")) {
                out.print("<title>Ptica - Novi naslovi</title>"); 
            } else if (sSource.equalsIgnoreCase("Pretraga knjiga")) {
                out.print("<title>Ptica - Pretraga knjiga</title>"); 
            } else if (sSource.equalsIgnoreCase("Ažuriranje knjige")) {
                out.print("<title>Ptica - Ažuriranje knjige</title>"); 
            } else if (sSource.equalsIgnoreCase("Brisanje knjige")) {
                out.print("<title>Ptica - Brisanje knjige</title>"); 
            } else if (sSource.equalsIgnoreCase("Prijava")){
                out.print("<title>Ptica - Prijava</title>");
            } else if (sSource.equalsIgnoreCase("Odjava")){
                out.print("<title>Ptica - Odjava</title>");    
            } else if (sSource.equalsIgnoreCase("Novi nalog")){
                out.print("<title>Ptica - Novi nalog</title>");
            }
        %>    
        
        <!-- povezivanje sa eksternom listom stilova -->
        <link href="css/templatecss.css" rel="stylesheet" type="text/css">
        
        <!-- header.jsp sadrži - logo i ime kompanije i navigaciju -->
        <%@ include file="header.jsp"%>
    </head>
    
    <body>
        <div class="whitebckgr">
            <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                <!-- Bootstrap kolona zauzima 6 kolona na velikim desktopovima i 6 kolona na desktopovima srednje veliċine -->
                <div class="col-lg-6 col-md-6"> 
                    <br /><br />
                    <div> 
                        <!-- center-image postavlja sliku u sredinu ( horizontalno ), img-fluid je za responsivan image -->
                        <img src="images/books.png" class="img-fluid center-image" alt="slika sa knjigama" title="slika sa knjigama"> 
                    </div>
                </div>
                
                <!-- Bootstrap kolona zauzima 5 kolona na velikim desktopovima i 5 kolona na desktopovima srednje veliċine -->
                <div class="col-lg-5 col-md-5"> 
                    <div class="container">
                        <div class="row"> <!-- dodavanje novog reda u Bootstrap grid -->
                            <div class="col">
                                &nbsp; &nbsp;
                                <br />
                                <br /><br /><br />
                                <%  
                                    // title, source_name, message - podaci prosleđeni sa druge veb stranice ( searchDB.jsp or updateDB.jsp )
                                    // sSource - tekst na dugmetu i koristi se za postavljanje action atributa u form tag-u
                                    
                                    // message - poruka koja se prikazuje ( varijabla koja je prosleđena sa prethodne veb stranice ) 
                                    String sMessage = (String)hSession.getAttribute("message");
                                    
                                    // promena boje poruke u text-warning
                                    String errStart = "<span class=\"text-warning\">";
                                    String errEnd = "</span>";
                                    
                                    out.print("<br />");
                                    out.print("<h3 class=\"text-info\">" + sTitle + "</h3><br /><br />");
                                    if (sMessage.equalsIgnoreCase("ERR_DB")) {
                                        out.print(errStart + "Došlo je do greške" + errEnd + " prilikom pristupa bazi podataka!"); 
                                    } else if (sMessage.equalsIgnoreCase("ERR_LOGIN")) {   
                                        out.print("Korisničko ime ili lozinka " + errStart + "ne postoje!" + errEnd );
                                    } else if (sMessage.equalsIgnoreCase("ERR_USER_EXISTS")) {
                                        out.print("Uneto korisničko ime " + errStart + "već postoji i korisnik nije unesen" + errEnd + " u bazu podataka!");
                                    } else if (sMessage.equalsIgnoreCase("ERR_SIGN_UP")) {
                                        out.print(errStart + "Došlo je do greške " + errEnd + "prilikom dodavanja novog korisnika i korisnik nije dodat u bazu podataka!"); 
                                    } else if (sMessage.equalsIgnoreCase("ERR_SEARCH")) {
                                        out.print(errStart + "Došlo je do greške" + errEnd + " prilikom pretraživanja!"); 
                                    } else if (sMessage.equalsIgnoreCase("ERR_NO_BOOKID")) {
                                        out.print("Knjiga sa tim naslovom, autorom i Isbn-om " + errStart + "ne postoji!" + errEnd); 
                                    } else if (sMessage.equalsIgnoreCase("ERR_NO_AUTHID")) {
                                        out.print("Knjiga od tog autora " + errStart + "ne postoji!" + errEnd); 
                                    } else if (sMessage.equalsIgnoreCase("ERR_ADD")) {
                                        out.print(errStart + "Došlo je do greške" + errEnd + " prilikom dodavanja knjige i knjiga nije uspešno dodata u bazu podataka!"); 
                                    } else if (sMessage.equalsIgnoreCase("ERR_UPDATE")) {
                                        out.print(errStart + "Došlo je do greške" + errEnd + " prilikom ažuriranja podataka o knjizi!"); 
                                    } else if (sMessage.equalsIgnoreCase("ERR_DELETE")) {
                                        out.print(errStart + "Došlo je do greške" + errEnd + " prilikom brisanja knjige!");
                                    } else if (sMessage.equalsIgnoreCase("DEL_NO_BOOK")) {
                                        out.print("Knjiga ne postoji i zbog toga" + errStart + " nije obrisana iz baze podataka!" + errEnd);
                                    } else if (sMessage.equalsIgnoreCase("ERR_ADD_EXISTS")) {
                                        out.print("Knjiga sa tim Isbn-om već postoji i" + errStart + " knjiga nije dodata u bazu podataka!" + errEnd);  
                                    } else if (sMessage.equalsIgnoreCase("SUCC_ADD")) {
                                        out.print("Podaci o knjizi su uspešno uneti u bazu podataka!");       
                                    } else if (sMessage.equalsIgnoreCase("SUCC_UPDATE")) {
                                        out.print("Podaci o knjizi su uspešno promenjeni u bazi podataka!");  
                                    } else if (sMessage.equalsIgnoreCase("SUCC_DELETE")) {
                                        out.print("Knjiga je uspešno obrisana iz baze podataka!");  
                                    } else if (sMessage.equalsIgnoreCase("SUCC_SIGN_UP")) {
                                        out.print("Novi korisnik je uspešno registrovan!"); 
                                    } else if (sMessage.equalsIgnoreCase("SUCC_LOGOUT")) {
                                        out.print("Uspešno ste se odjavili!");
                                    }
                                    
                                    // sSource - za postavljanje atributa action u form tag-u
                                    if (sSource.equalsIgnoreCase("Nova knjiga")) {
                                %>
                                        <form action="add_page.jsp" method="post">
                                <%
                                    } else if (sSource.equalsIgnoreCase("Novi naslovi")) {
                                %>
                                        <form action="index.jsp" method="post">
                                <%
                                    } else if (sSource.equalsIgnoreCase("Pretraga knjiga")) {
                                %>
                                        <form action="search_page.jsp" method="post">  
                                <%
                                    } else if (sSource.equalsIgnoreCase("Ažuriranje knjige")) {                            
                                %>
                                        <form action="update_prev.jsp" method="post"> 
                                <%
                                    } else if (sSource.equalsIgnoreCase("Brisanje knjige")) { 
                                %>
                                        <form action="delete_title.jsp" method="post">
                                <%
                                    } else if (sSource.equalsIgnoreCase("Prijava")) {
                                %>
                                        <form action="login_page.jsp" method="post">
                                <%
                                    } else if (sSource.equalsIgnoreCase("Odjava")) {
                                %>
                                        <form action="index.jsp" method="post">
                                <%
                                    } else if (sSource.equalsIgnoreCase("Novi nalog")) {
                                %>
                                        <form action="signup_page.jsp" method="post">
                                <%
                                    }
                                %>
                                <% if (sSource.equals("Odjava")) {
                                       sSource = "Ptica"; // tekst na dugmetu
                                   }
                                %>
                                    <br /><br /><br />
                                    <!-- btn-sm se koristi za manju ( užu ) veličinu kontrole -->
                                    <button type="submit" class="btn btn-info btn-sm"> <%= sSource %></button>
                                </form>
                                
                            </div> <!-- završetak class = "col" -->
                        </div> <!-- završetak class = "row" --> 
                    </div> <!-- završetak class = "container" -->
                </div> <!-- završetak class = "col-lg-5 col-md-5" -->
            </div> <!-- završetak class = "row" -->
        </div> <!-- završetak class = "whitebckgr" -->
            
        <!-- dodajem novi red u Bootstrap grid; klasa whitebckgr: za postavljanje pozadine u belo -->
        <div class="whitebckgr">
            <div class="col">
                &nbsp; &nbsp;
            </div>
        </div> 
        <!-- footer.jsp sadrži footer --> 
        <%@ include file="footer.jsp"%> 
    </body>
</html>
