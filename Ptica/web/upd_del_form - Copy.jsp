<%-- 
    Document   : upd_del_form
    Created on : 13-Mar-2019, 11:36:48
    Author     : Ingrid Farkas
    Project    : Ptica    
--%>

<!-- upd_del_form.jsp - adds the form to the page Update Book -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="miscellaneous.PticaMetodi"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="connection.ConnectionManager"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">        
        <script src="javascript/validationJS.js"></script>
        
        <style>            
            input:disabled, textarea:disabled, select:disabled {
                background-color: white !important;
            }
        </style>
        
        <script>
            
            NUM_FIELDS = 11; // maximum number of the input fields on this and the previous forms             
            START = 3; 
           
            // setCookie: creates cookie inputI = value in the input field ; (I - number 3..11)
            function setCookie() {
                var i;
                var inp_names = new Array('title', 'author', 'isbn', 'price', 'pages', 'category', 'descr', 'publisher', 'yrpublished'); // names of the input fields
                // cookies named input0, input1, input2 were created in upd_del_title.jsp
                for (i = START; i <= NUM_FIELDS; i++) {
                    if (i === 6) { // creating the cookie that containes the price
                        strWithDot = document.getElementById(inp_names[i-3]).value; 
                        strWithDot = strWithDot.replace(',','.');
                        document.cookie = "input" + i + "=" + strWithDot + ";"; // creating a cookie
                    } else {
                        document.cookie = "input" + i + "=" + document.getElementById(inp_names[i-3]).value + ";"; // creating a cookie
                    }    
                } 
            }
            
            // setDefaults : sets the values of the cookies (input0, input1, input2) to the default
            function setDefaults() {              
                var i;
                
                for (i = START; i <= NUM_FIELDS; i++) {
                    document.cookie = "input" + i + "= "; // setting the VALUE of the cookie to EMPTY
                }
                setCookie(); // go through every input field and write its content to the cookie
            }
            
        </script>
        
        <%
            HttpSession hSession2 = PticaMetodi.returnSession(request);    
            String source = (String)hSession2.getAttribute("source_name"); // on which page I am now
        %>
        
        <title>Ptica - <%= source %> </title>
    </head>
    
    <body onload="setDefaults()">
        <%
            final String PAGE_NAME = "upd_del_page.jsp"; // page which is shown now 
        %>
        <%                                  
            String input3 = ""; // read the value which was before in the input field title to show it again
            String input4 = "";
            String input5 = "";
            String input6 = "";
            String input7 = "";
            String input8 = "";
            String input9 = "";
            String input10 = "";
            String input11 = "";
            
            String title = ""; // used for showing the record which is being updated
            String au_name = "";
            String isbn = "";
            String price = "";
            String pages = "";
            String descr = "";
            String publ_name = ""; 
            String publ_year = "";
            String category = "";
            
            // IDEA : fill_in variable is set in SubscrServl.java - true if some of the input session variables were set,
            // and they need to be added to the form here - this true if the user BEFORE LOADED THIS PAGE and after that he entered
            // the email to subscribe (in the footer) and on the next page he clicked on Close
            if (PticaMetodi.sessVarExists(hSession2, "fill_in")) { 
                String fill_in = String.valueOf(hSession2.getAttribute("fill_in")); 
                
                // session variable page_name is set below. It is used if the user clicks on the Subscribe button and after that on
                // the page subscrres_content if the user clicks on the Close button then this page will be shown again
                if (PticaMetodi.sessVarExists(hSession2, "page_name")) { 
                    String page_name = String.valueOf(hSession2.getAttribute("page_name"));
                    
                    // if the user clicked on the Close button on the page subscrres_content and this page was shown before (page_name)
                    // and if something is stored in session variables input 
                    // then retrieve the session variable input3..input11 to show it in the input field title (and other fields)
                    if ((page_name.equalsIgnoreCase(PAGE_NAME)) && (fill_in.equalsIgnoreCase("true"))) {
                        if (PticaMetodi.sessVarExists(hSession2, "input3")) {
                            input3 = String.valueOf(hSession2.getAttribute("input3")); // the value that was in this input field
                        } 
                        if (PticaMetodi.sessVarExists(hSession2, "input4")) {
                            input4 = String.valueOf(hSession2.getAttribute("input4"));
                        } 
                        if (PticaMetodi.sessVarExists(hSession2, "input5")) {
                            input5 = String.valueOf(hSession2.getAttribute("input5"));
                        }
                        if (PticaMetodi.sessVarExists(hSession2, "input6")) {
                            input6 = String.valueOf(hSession2.getAttribute("input6")); // the value that was in this input field
                        } 
                        if (PticaMetodi.sessVarExists(hSession2, "input7")) {
                            input7 = String.valueOf(hSession2.getAttribute("input7"));
                        } 
                        if (PticaMetodi.sessVarExists(hSession2, "input8")) {
                            input8 = String.valueOf(hSession2.getAttribute("input8"));
                        } 
                        if (PticaMetodi.sessVarExists(hSession2, "input9")) {
                            input9 = String.valueOf(hSession2.getAttribute("input9")); // the value that was in this input field
                        } 
                        if (PticaMetodi.sessVarExists(hSession2, "input10")) {
                            input10 = String.valueOf(hSession2.getAttribute("input10"));
                        } 
                        if (PticaMetodi.sessVarExists(hSession2, "input11")) {
                            input11 = String.valueOf(hSession2.getAttribute("input11"));
                        } 
                        PticaMetodi.setToEmptyInput(hSession2); // setToEmpty: set the session variable values to "" for the variables named input3, input4, ...
                    }
                }
                hSession2.setAttribute("fill_in", "false"); // the input fields don't need to be filled in
            }
            PticaMetodi.setToEmptyInput(hSession2); // setToEmptyInput: set the session variable values to "" for the variables named input0, input1, ...
            hSession2.setAttribute("page_name", PAGE_NAME);
        %>
        
        <%
            hSession2.setAttribute("webpg_name", "upd_del_page.jsp");
            // if the user just did do the subscribe, the form on the NEXT web page DOESN'T NEED to show the previous values
            hSession2.setAttribute("subscribe", "false");
            
            Connection con = ConnectionManager.getConnection(); //connecting to the database 
            Statement stmt = con.createStatement();
            
            String sQuery = "select b.title, b.price, b.isbn, b.pages, b.publ_year, b.descr, b.category, a.au_name, p.publ_name from book b, author a, publisher p where b.au_id = a.au_id and b.publ_id = p.publ_id";
            // previous_title: is the book title in the database which already exists
            String previous_title = (String)hSession2.getAttribute("prev_title"); // retrieving the title from the session variable (upd_del_title.jsp)
            // previous_auth: is the author in the database which already exists
            String previous_auth = (String)hSession2.getAttribute("prev_auth"); // retrieving the author 
            // previous_isbn: is the isbn in the database which already exists
            String previous_isbn = (String)hSession2.getAttribute("prev_isbn"); // retrieving the ISBN
            
            if (!((previous_title.equalsIgnoreCase("")))) {
                sQuery += " and b.title='" + previous_title + "'";
            }
            
            if (!((previous_auth.equalsIgnoreCase("")))) {
                sQuery += " and a.au_name='" + previous_auth + "'";
            }
            
            if (!((previous_isbn.equalsIgnoreCase("")))) {
                sQuery += " and b.isbn='" + previous_isbn + "'";
            }
            
            sQuery += ";";
            
            // execute the query - the result will be in the rset
            ResultSet rset = stmt.executeQuery(sQuery); 

             // if result set of the query has the next record
            if (rset.next()) {
                title = rset.getString("title"); // retrieve the title from rset
                if (title == null) {
                    title = "";
                }
                
                au_name = rset.getString("au_name"); // retrieve the au_name from rset
                if (title == null) {
                    title = "";
                }
                
                isbn = rset.getString("isbn"); // retrieve the isbn from rset
                if (isbn == null) {
                    isbn = "";
                }
                
                price = rset.getString("price"); // retrieve the price from rset
                if (price == null) {
                    price = "";
                } else {
                    // in the database the price is in form 99999.99; on the form the price should be shown in form 99.999,99 
                    price = price.replace('.',',');
                    if (price.length() > 6) {
                        String substrLevi = ""; // part of the string from the left until the .
                        String substrDesni = ""; // string from the right hand side of the .
                        if (price.length() == 7) {
                            substrLevi = price.substring(0,1);
                            substrDesni = price.substring(1);
                        } else if (price.length() == 8) {
                            substrLevi = price.substring(0,2);
                                substrDesni = price.substring(2);
                        }
                        price = "";
                        price = price.concat(substrLevi); 
                        price = price.concat(".");
                        price = price.concat(substrDesni);
                    }
                }
                
                pages = rset.getString("pages"); // retrieve pages from rset
                if (pages == null) {
                    pages = "";
                }
                
                category = rset.getString("category"); // retrieve the category from rset
                if (category == null) {
                    category = "";
                }
                
                descr = rset.getString("descr"); // retrieve the descr from rset
                if (descr == null) {
                    descr = "";
                }
                
                publ_name = rset.getString("publ_name"); // retrieve the publ_name from rset
                if (publ_name == null) {
                    publ_name = "";
                }
                
                publ_year = rset.getString("publ_year"); // retrieve the publ_year from rset
                if (publ_year == null) {
                    publ_year = "";
                }
            }
        %>   
            
        <!-- adding a new row to the Bootstrap grid; class whitebckgr is for setting the background to white -->
        <div class="whitebckgr">
            <div class="row"> <!-- adding a new row to the Bootstrap grid -->
                <!-- the Bootstrap column takes 6 columns on the large desktops and 6 columns on the medium sized desktops -->
                <div class="col-lg-6 col-md-6"> 
                    <br /><br />
                    <div> 
                        <!-- horizontally centering the picture using center-image, img-fluid is for responsive image -->
                        <img src="images/books.png" class="img-fluid center-image" alt="slika sa knjigama" title="slika sa knjigama"> 
                    </div>
                    <br /><br />
                    <div> 
                        <!-- horizontally centering the picture using center-image, img-fluid is for responsive image -->
                        <img src="images/books.png" class="img-fluid center-image" alt="slika sa knjigama" title="slika sa knjigama"> 
                    </div>
                </div>
                
                <!-- the Bootstrap column takes 5 columns on the large desktops and 5 columns on the medium sized desktops -->
                <div class="col-lg-5 col-md-5"> 
                    <div class="container"> <!-- adding the container to the Bootstrap grid -->
                        <div class="row"> <!-- adding a new row to the Bootstrap grid -->
                            <div class="col">
                                &nbsp; &nbsp;
                                <br />
                               
                                <!-- Update -->
                                <% if (source.equals("Ažuriraj knjigu")) {
                                %>
                                    <h3 class="text-info">Ažuriraj knjigu</h3>
                                <%
                                   } else if (source.equals("Izbriši knjigu")) {
                                %>
                                    <!-- Delete -->
                                    <h3 class="text-info">Izbriši knjigu</h3>
                                <%
                                   }
                                %>
                                
                                <br />
                             
                                <% if (source.equals("Ažuriraj knjigu")) {
                                %>
                                    <!-- after clicking on the button updateDB.jsp is shown -->
                                    <form id="upd_del_book" name="upd_del_book" action="updateDB.jsp" onsubmit="return checkForm();" method="post">
                                <%
                                    } else if (source.equals("Izbriši knjigu")) {
                                %>
                                     <!-- after clicking on the button DelServlet is shown -->
                                     <form id="upd_del_book" name="upd_del_book" action="DelServlet" onsubmit="return checkForm();" method="post">
                                <%
                                    }
                                %>
                                
                                    <!-- creating the input element for the title -->
                                    <div class="form-group">
                                        <label for="title">Naslov</label> 
                                        <% if (source.equals("Ažuriraj knjigu")) {
                                        %>
                                            <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                            <% if (!input3.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control form-control-sm" name="title" id="title" maxlength="60" onchange="setCookie()" value="<%= input3 %>"> <!-- title input field -->
                                                <!-- otherwise read the record from the DB and show it -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" name="title" id="title" maxlength="60" onchange="setCookie()" value="<%= title %>"> <!-- title input field -->
                                            <% } 
                                            %>
                                        <%
                                           } else if (source.equals("Izbriši knjigu")) {
                                        %>
                                            <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                            <% if (!input3.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="title" id="title" maxlength="60" onchange="setCookie()" value="<%= input3 %>"> <!-- title input field -->
                                                <!-- otherwise read the record from the DB and show it -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="title" id="title" maxlength="60" onchange="setCookie()" value="<%= title %>"> <!-- title input field -->
                                            <% } 
                                            %>
                                        <%
                                           }
                                        %>
                                    </div>
                                    
                                    <!-- creating the input element for the author -->
                                    <div class="form-group">
                                        <label for="author">Autor</label>
                                        <% if (source.equals("Ažuriraj knjigu")) {
                                        %>
                                            <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                            <% if (!input4.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control form-control-sm" name="author" id="author" maxlength="70" onchange="setCookie()" onfocusout="valLetters(document.upd_del_book.author, author_message, 'fullname', false, 'false');" value="<%= input4 %>"> <!-- author input field -->
                                            <!-- otherwise read the record from the DB and show it -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" name="author" id="author" maxlength="70" onchange="setCookie()" onfocusout="valLetters(document.upd_del_book.author, author_message, 'fullname', false, 'false');" value="<%= au_name %>"> <!-- author input field -->
                                            <% }
                                            %>
                                        <%
                                           } else if (source.equals("Izbriši knjigu")) {
                                        %>
                                                <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                                <% if (!input4.equalsIgnoreCase("")) { %>
                                                    <input type="text" class="form-control form-control-sm" disabled name="author" id="author" maxlength="70" value="<%= input4 %>"> <!-- author input field -->
                                                <!-- otherwise read the record from the DB and show it -->
                                                <% } else { %>
                                                    <input type="text" class="form-control form-control-sm" disabled name="author" id="author" maxlength="70" value="<%= au_name %>"> <!-- author input field -->
                                                <% }
                                                %>
                                        <% 
                                           } 
                                        %>
                                        <span id="author_message" class="text_size text-danger"></span>
                                    </div>
                
                                    <!-- creating the input element for the ISBN -->
                                    <div class="form-group">
                                        <label for="isbn">Isbn</label> 
                                        <% if (source.equals("Ažuriraj knjigu")) {
                                        %>
                                            <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                            <% if (!input5.equalsIgnoreCase("")) { %>
                                                <!-- isbn input field : up to 13 characters can be entered -->
                                                <input type="text" class="form-control form-control-sm" maxlength="13" name="isbn" id="isbn" maxlength="13" onchange="setCookie()" onfocusout='isNumber("upd_del_book", "isbn", "is_isbn", "isbn_message", false, false)' value="<%= input5 %>"> 
                                            <!-- otherwise read the record from the DB and show it -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" maxlength="13" name="isbn" id="isbn" maxlength="13" onchange="setCookie()" onfocusout='isNumber("upd_del_book", "isbn", "is_isbn", "isbn_message", false, false)' value="<%= isbn %>"> 
                                            <% } %>
                                        <%
                                           } else if (source.equals("Izbriši knjigu")) {
                                        %>
                                            <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                            <% if (!input5.equalsIgnoreCase("")) { %>
                                                <!-- isbn input field : up to 13 characters can be entered -->
                                                <input type="text" class="form-control form-control-sm" disabled maxlength="13" name="isbn" id="isbn" maxlength="13" value="<%= input5 %>"> 
                                            <!-- otherwise read the record from the DB and show it -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" disabled maxlength="13" name="isbn" id="isbn" maxlength="13" value="<%= isbn %>"> 
                                            <% } %>
                                        <% 
                                           } 
                                        %>
                                        <span id="isbn_message" class="text_size text-danger"></span>
                                    </div>
                                        
                                    <!-- creating the input element for price -->
                                    <div class="form-group">
                                        <label for="price">Cena</label> 
                                        <% if (source.equals("Ažuriraj knjigu")) {
                                        %>
                                            <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                            <% if (!input6.equalsIgnoreCase("")) { 
                                                input6 = input6.replace('.', ',');
                                            %>
                                                <input type="text" class="form-control form-control-sm" name="price" id="price" maxlength="9" onchange="setCookie()" onfocusout='daLiJeCena("upd_del_book", "price", "is_price", "price_message")' value="<%= input6 %>"> 
                                            <!-- otherwise read the record from the DB and show it -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" name="price" id="price" maxlength="9" onchange="setCookie()" onfocusout='daLiJeCena("upd_del_book", "price", "is_price", "price_message")' value="<%= price %>"> 
                                            <% } %>
                                        <%
                                           } else if (source.equals("Izbriši knjigu")) {
                                        %>
                                            <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                            <% if (!input6.equalsIgnoreCase("")) { 
                                                input6 = input6.replace('.', ',');
                                            %>
                                                <input type="text" class="form-control form-control-sm" disabled name="price" id="price" maxlength="9" value="<%= input6 %>"> 
                                            <!-- otherwise read the record from the DB and show it -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="price" id="price" maxlength="9" value="<%= price %>"> 
                                            <% } %>
                                        <% 
                                           } 
                                        %>
                                        <span id="price_message" class="text_size text-danger"></span>
                                    </div>
                                        
                                    <!-- creating the input element for number of pages -->
                                    <div class="form-group">
                                        <label for="pages">Broj strana</label>
                                        <% if (source.equals("Ažuriraj knjigu")) {
                                        %>
                                            <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                            <% if (!input7.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control form-control-sm" name="pages" id="pages" maxlength="4" onchange="setCookie()" onfocusout='isNumber("upd_del_book", "pages", "is_pages", "pages_message", false, false)' value="<%= input7 %>"> 
                                            <!-- otherwise read the record from the DB and show it -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" name="pages" id="pages" maxlength="4" onchange="setCookie()" onfocusout='isNumber("upd_del_book", "pages", "is_pages", "pages_message", false, false)' value="<%= pages %>"> 
                                            <% } %>
                                        <%
                                           } else if (source.equals("Izbriši knjigu")) {
                                        %>
                                            <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                            <% if (!input7.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control berform-control-sm" disabled name="pages" id="pages" maxlength="4" value="<%= input7 %>"> 
                                            <!-- otherwise read the record from the DB and show it -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="pages" id="pages" maxlength="4" value="<%= pages %>"> 
                                            <% } %>
                                        <% 
                                           } 
                                        %>
                                        <span id="pages_message" class="text_size text-danger"></span>
                                    </div>
                                        
                                    <!-- creating the drop down list for the Category -->
                                    <div class="form-group"> 
                                        <label for="category">Žanrovi</label> <!-- category label -->
                                        <% if (source.equals("Ažuriraj knjigu")) {
                                        %>
                                            <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                            <% if (!input8.equalsIgnoreCase("")) { %>
                                                <!-- creating a drop down list; form-control-sm is used for narrower control -->
                                                <select  class="form-control form-control-sm" name="category" id="category" onchange="setCookie()">
                                                    <% if (input8.equalsIgnoreCase("all")) { %>
                                                        <option value="all" selected>Svi žanrovi</option> <!-- options shown in the drop down list -->
                                                    <% } else { %>
                                                        <option value="all">Svi žanrovi</option>
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("fict")) { %>
                                                        <option value="fict" selected>Romani</option> 
                                                    <% } else { %>
                                                        <option value="fict">Romani</option>   
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("bus")) { %>
                                                        <option value="bus" selected>Biznis i ekonomija</option> 
                                                    <% } else { %>
                                                        <option value="bus">Biznis i ekonomija</option>      
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("comp")) { %>
                                                        <option value="comp" selected>Internet i računari</option> 
                                                    <% } else { %>
                                                        <option value="comp">Internet i računari</option>  
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("edu")) { %>
                                                        <option value="edu" selected>Edukativni</option> 
                                                    <% } else { %>
                                                        <option value="edu">Edukativni</option>   
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("child")) { %>
                                                        <option value="child" selected>Knjige za decu</option> 
                                                    <% } else { %>
                                                        <option value="child">Knjige za decu</option>  
                                                    <% } %>
                                                </select>
                                            <!-- otherwise read the record from the DB and show it -->
                                            <% } else { %>
                                                <!-- creating a drop down list; form-control-sm is used for narrower control -->
                                                <select class="form-control form-control-sm" name="category" id="category" onchange="setCookie()">
                                                    <% if (category.equalsIgnoreCase("all")) { %>
                                                        <option value="all" selected>Svi žanrovi</option> <!-- options shown in the drop down list -->
                                                    <% } else { %>
                                                        <option value="all">Svi žanrovi</option>
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("fict")) { %>
                                                        <option value="fict" selected>Romani</option> 
                                                    <% } else { %>
                                                        <option value="fict">Romani</option>   
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("bus")) { %>
                                                        <option value="bus" selected>Biznis i ekonomija</option> 
                                                    <% } else { %>
                                                        <option value="bus">Biznis i ekonomija</option>      
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("comp")) { %>
                                                        <option value="comp" selected>Internet i računari</option> 
                                                    <% } else { %>
                                                        <option value="comp" >Internet i računari</option>  
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("edu")) { %>
                                                        <option value="edu" selected>Edukativni</option> 
                                                    <% } else { %>
                                                        <option value="edu">Edukativni</option>   
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("child")) { %>
                                                        <option value="child" selected>Knjige za decu</option> 
                                                    <% } else { %>
                                                        <option value="child">Knjige za decu</option>  
                                                    <% } %>
                                                </select>
                                            <% } %>
                                        <%
                                           } else if (source.equals("Izbriši knjigu")) {
                                        %>
                                            <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                            <% if (!input8.equalsIgnoreCase("")) { %>
                                                <!-- creating a drop down list; form-control-sm is used for narrower control -->
                                                <select  class="form-control form-control-sm" disabled name="category" id="category">
                                                    <% if (input8.equalsIgnoreCase("all")){ %>
                                                        <option value="all" selected>Svi žanrovi</option> <!-- options shown in the drop down list -->
                                                    <% } else { %>
                                                        <option value="all">Svi žanrovi</option>
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("fict")) { %>
                                                        <option value="fict" selected>Romani</option> 
                                                    <% } else { %>
                                                        <option value="fict">Romani</option>   
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("bus")) { %>
                                                        <option value="bus" selected>Biznis i ekonomija</option> 
                                                    <% } else { %>
                                                        <option value="bus">Biznis i ekonomija</option>      
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("comp")) { %>
                                                        <option value="comp" selected>Internet i računari</option> 
                                                    <% } else { %>
                                                        <option value="comp">Internet i računari</option>  
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("edu")) { %>
                                                        <option value="edu" selected>Edukativni</option> 
                                                    <% } else { %>
                                                        <option value="edu">Edukativni</option>   
                                                    <% } %>

                                                    <% if (input8.equalsIgnoreCase("child")) { %>
                                                        <option value="child" selected>Knjige za decu</option> 
                                                    <% } else { %>
                                                        <option value="child">Knjige za decu</option>  
                                                    <% } %>
                                                </select>
                                            <!-- otherwise read the record from the DB and show it -->
                                            <% } else { %>
                                                <!-- creating a drop down list; form-control-sm is used for narrower control -->
                                                <select class="form-control form-control-sm" disabled name="category" id="category">
                                                    <% if (category.equalsIgnoreCase("all")) { %>
                                                        <option value="all" selected>Svi žanrovi</option> <!-- options shown in the drop down list -->
                                                    <% } else { %>
                                                        <option value="all">Svi žanrovi</option>
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("fict")) { %>
                                                        <option value="fict" selected>Romani</option> 
                                                    <% } else { %>
                                                        <option value="fict">Romani</option>   
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("bus")) { %>
                                                        <option value="bus" selected>Biznis i ekonomija</option> 
                                                    <% } else { %>
                                                        <option value="bus">Biznis i ekonomija</option>      
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("comp")) { %>
                                                        <option value="comp" selected>Internet i računari</option> 
                                                    <% } else { %>
                                                        <option value="comp" >Internet i računari</option>  
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("edu")) { %>
                                                        <option value="edu" selected>Edukativni</option> 
                                                    <% } else { %>
                                                        <option value="edu">Edukativni</option>   
                                                    <% } %>

                                                    <% if (category.equalsIgnoreCase("child")) { %>
                                                        <option value="child" selected>Knjige za decu</option> 
                                                    <% } else { %>
                                                        <option value="child">Knjige za decu</option>  
                                                    <% } %>
                                                </select>

                                            <% } %>
                                        <% 
                                           } 
                                        %>    
                                    </div>
                                        
                                    <!-- creating the textarea for the book description -->
                                    <div class="form-group">
                                        <label for="descr">Opis</label>
                                        <% if (source.equals("Ažuriraj knjigu")) {
                                        %>
                                            <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                            <% if (!input9.equalsIgnoreCase("")) { %>
                                                <textarea class="form-control" name="descr" id="descr" rows="4" onchange="setCookie()"><%= input9 %></textarea>
                                            <!-- otherwise read the record from the DB and show it -->
                                            <% } else { %>
                                                <textarea class="form-control" name="descr" id="descr" rows="4" onchange="setCookie()"><%= descr %></textarea>
                                            <% } %>
                                        <%
                                           } else if (source.equals("Izbriši knjigu")) {
                                        %>
                                            <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                            <% if (!input9.equalsIgnoreCase("")) { %>
                                                <textarea class="form-control" disabled name="descr" id="descr" rows="4"><%= input9 %></textarea>
                                            <!-- otherwise read the record from the DB and show it -->
                                            <% } else { %>
                                                <textarea class="form-control" disabled name="descr" id="descr" rows="4"><%= descr %></textarea>
                                            <% } %>
                                        <% 
                                           } 
                                        %>
                                    </div>
                                        
                                    <!-- creating the input element for the publisher -->
                                    <div class="form-group">
                                        <label for="publisher">Izdavač</label> 
                                        <% if (source.equals("Ažuriraj knjigu")) {
                                        %>
                                            <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                            <% if (!input10.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control form-control-sm" name="publisher" id="publisher" maxlength="40" onchange="setCookie()" value="<%= input10 %>"> 
                                            <!-- otherwise read the record from the DB and show it -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" name="publisher" id="publisher" maxlength="40" onchange="setCookie()" value="<%= publ_name %>"> 
                                            <% } %>
                                        <%
                                           } else if (source.equals("Izbriši knjigu")) {
                                        %>
                                            <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                            <% if (!input10.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="publisher" id="publisher" maxlength="40" value="<%= input10 %>"> 
                                            <!-- otherwise read the record from the DB and show it -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="publisher" id="publisher" maxlength="40" value="<%= publ_name %>"> 
                                            <% } %>
                                        
                                        <% 
                                           } 
                                        %>
                                    </div>
                                    
                                    <!-- creating the input element for year the book was published -->
                                    <div class="form-group">
                                        <label for="yrpublished">Godina izdanja</label>
                                        <% if (source.equals("Ažuriraj knjigu")) {
                                        %>
                                            <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                            <% if (!input11.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control form-control-sm" name="yrpublished" id="yrpublished" maxlength="4" onchange="setCookie()" onfocusout='isNumber("upd_del_book", "yrpublished", "is_yrpubl", "yrpubl_message", false, false)' value="<%= input11 %>"> 
                                            <!-- otherwise read the record from the DB and show it -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" name="yrpublished" id="yrpublished" maxlength="4" onchange="setCookie()" onfocusout='isNumber("upd_del_book", "yrpublished", "is_yrpubl", "yrpubl_message", false, false)' value="<%= publ_year %>"> 
                                            <% } %>
                                        <%
                                           } else if (source.equals("Izbriši knjigu")) {
                                        %>
                                            <!-- if the user just did the subscribe show the value from the form before the subscribe -->
                                            <% if (!input11.equalsIgnoreCase("")) { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="yrpublished" id="yrpublished" maxlength="4" value="<%= input11 %>"> 
                                            <!-- otherwise read the record from the DB and show it -->
                                            <% } else { %>
                                                <input type="text" class="form-control form-control-sm" disabled name="yrpublished" id="yrpublished" maxlength="4" value="<%= publ_year %>"> 
                                            <% } %>
                                        <% 
                                           } 
                                        %>
                                        <span id="yrpubl_message" class="text_size text-danger"></span>
                                    </div> 
                                        
                                    <div class="container">
                                        <div class="row">
                                            <div class="col">
                                                &nbsp; &nbsp; <!-- adding some empty space -->
                                            </div>
                                        </div>    
                                    </div>
                                    
                                    <% if (source.equals("Ažuriraj knjigu")) {
                                    %>
                                        <!-- adding the Update button to the form; btn-sm is used for smaller (narrower) size of the control -->
                                        <button type="submit" id="btnSubmit" class="btn btn-info btn-sm">Ažuriraj</button>
                                    <%
                                        } else if (source.equals("Izbriši knjigu")) {
                                    %>
                                        <!-- adding the Delete button to the form; btn-sm is used for smaller (narrower) size of the control -->
                                        <button type="submit" id="btnSubmit" class="btn btn-info btn-sm">Izbriši</button>
                                    <%
                                        }
                                    %>
                                    
                                    <div class="container">
                                        <div class="row">
                                            <div class="col">
                                                &nbsp; &nbsp; <!-- adding some empty space -->
                                            </div>
                                        </div>    
                                    </div> 
                                </form>  
                            </div> <!-- end of class="col" -->
                        </div> <!-- end of class="row" --> 
                    </div> <!-- end of class="container" -->
                </div> <!-- end of class="col-lg-5 col-md-5" -->
            </div> <!-- end of class="row" -->
        </div> <!-- end of class="whitebckgr" -->
            
        <!-- adding a new row; class whitebckgr is for setting the background to white -->
        <div class="whitebckgr">
            <div class="col">
                &nbsp; &nbsp;
            </div>
        </div> 
        </div>   
    </body>
</html>