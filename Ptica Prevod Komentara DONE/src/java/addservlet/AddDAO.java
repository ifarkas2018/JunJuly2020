/*
 * autor   : Ingrid Farkaš
 * projekat: Ptica
 * AddDAO.java : izvršavanje SQL upita ( koristi se u AddServlet.java )
 */
package addservlet;

import connection.ConnectionManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.http.HttpSession;

/**
 *
 * @author user
 */

public class AddDAO {
    static Connection con;
    static ResultSet rs = null;  // objekat gde ae čuvaju rezultati upita
    
    // publExistsAdd : proverava da li slog sa unetim unetim imenom izdavača i gradom postoji. Ako ne postoji tada dodaje novi slog
    // ako je došlo do izuzetka onda vraća TRUE inače vraća FALSE
    public static boolean publExistsAdd(String publisher) {
        boolean excOccurred = false; // da li došlo do izuzetka
        Statement stmt;
        
        try {
            stmt = con.createStatement();
            rs = null;
       
            // Prvo proveravam da li u tabeli PUBLISHER slog sa unetim IMENOM IZDAVAČA i GRADOM postoji
            // Da bih to uradila prvo izvršavam select upit u tabeli publisher da bih proverila da li slog sa unetim imenom izdavača i gradom postoji
            // Ako select ne vrati slog tada treba da izvršim insert
            // 1. select upit
            String rs_query=""; 
          
            if (!((publisher.equalsIgnoreCase("")))) {
                PreparedStatement preparedStmt;
                // proveri da li u bazi postoji samo ime izdavača bez grada
                rs_query = "select publ_id from publisher where (publ_name = '" + publisher + "');";
                rs = stmt.executeQuery(rs_query);
                if (!rs.next()) {
                    // 2. insert upit
                    String query = "insert into publisher(publ_name) values ('" + publisher + "');";
                    preparedStmt = con.prepareStatement(query);
                    preparedStmt.execute();
                }
            }
            excOccurred = false; // nije došlo do izuzetka
        } catch (SQLException e) {
            excOccurred = true; // došlo je do izuzetka
        }
        return excOccurred; // vraća da li je došlo do izuzetka
    }
   
    // authExistsAdd : proverava da li u tabeli AUTHOR slog sa unetim IMENOM AUTORA postoji. Ako slog ne postoji tada dodaje slog.
    // ako je došlo do izuzetka vraća TRUE inače vraća FALSE 
    public static boolean authExistsAdd(String author) {
        boolean excOccurred = false; // došlo je do izuzetka
        Statement stmt;
        
        try {
            String rs_query=""; 
            boolean empty_field = false; // da li je input polje prazno
            
            // tabela author
            // Prvo proveravam da li u tabeli AUTHOR slog sa unesenim IMENOM AUTORA postoji
            // Da bih to uradila ja prvo izvršavam select na tabeli author da proverim da li slog sa unetim imenom autora postoji.
            // Ako select nije vratio ni jedan slog tada izvršavam insert
            // 1. select upit
            stmt = con.createStatement(); 
            rs_query = "";
            rs = null;
            empty_field = false; // korisnik nije uneo ime autora u input polje
            // ako korisnik nije uneo ime autora tada ništa nije potrebno da se uradi, inače dodaj vrednosti u bazu
            if (author.equalsIgnoreCase(""))
                empty_field = true; 
            if (!(empty_field)) {
                rs_query = "select au_name from author where (au_name = '" + author + "');";
                rs = stmt.executeQuery(rs_query);
                PreparedStatement preparedStmt;
                
                // 2. upit insert - slučaj kada autor sa tim imenom ne postoji u tabeli autor
                if (!rs.next()) {
                    String query = "insert into author(au_name) values('" + author + "');";
                    preparedStmt = con.prepareStatement(query);
                    preparedStmt.execute();
                }
            }
            excOccurred = false; // nije došlo do izuzetka
        } catch (SQLException e) {
            excOccurred = true; // došlo je do izuzetka
        }
        return excOccurred; // vraća da li je došlo do izuzetka
    }
    
    // addNewBook: dodaje novu knjigu u tebelu book ( vraća String na osnovu koga error_succ.jsp prikazuje poruku )
    // poziva se iz AddServlet.java, metod doPost
    public static String addNewBook(HttpSession hSession, String title, String author, String publisher, String isbn, String price, String pages, String category, //
                                    String descr, String yrpublished) {
        String returnStr = ""; // String koji ovaj metod vraća 
        // objekati koji se koriste za pristup bazi
        Statement stmt = null;  
        PreparedStatement preparedStmt = null;
        rs = null;
        boolean excOccurred; // da li je došlo do izuzetka priliko pristupa bazi
        
        try {
            con = ConnectionManager.getConnection(); // povezivanje sa bazom
            stmt = con.createStatement();
        
            String rs_query=""; 
            boolean empty_field = false;
            
            // publExistsAdd : proverava da li slog sa unetim unetim imenom izdavača postoji. Ako ne postoji tada dodaje nov slog
            // ako je došlo do izuzetka onda vraća TRUE inače vraća FALSE
            excOccurred = publExistsAdd(publisher);
            if (excOccurred)
                returnStr = "ERR_ADD";
            else {    
                // authExistsAdd : proverava da li u tabeli AUTHOR slog sa unetim IMENOM AUTORA postoji. Ako slog ne postoji tada dodaje slog.
                // ako je došlo do izuzetka vraća TRUE inače vraća FALSE 
                excOccurred = authExistsAdd(author);
                if (excOccurred)
                    returnStr = "ERR_ADD";
                else {
                    // da li knjiga sa tim naslovom postoji u tabeli BOOK
                    boolean isbn_exist = false; // da li knjiga sa tim NASLOVOM ili ISBN-om već postoji u bazi

                    if (!isbn_exist) {
                        rs_query = "select isbn from book where (isbn = '" + isbn + "');";
                        rs = stmt.executeQuery(rs_query);
                        if (rs.next()) {
                            isbn_exist = true;
                            returnStr = "ERR_ADD_EXISTS"; // rezultat dodavanja knjige u bazu
                        }
                    }
                    
                    // da li je korisnik uneo ime izdavača I ime autora I ( naslov knjige ILI isbn ) tada dodaj ( insert ) unesene vrednsti u bazu
                    if ((!isbn_exist) && ((!(publisher.equalsIgnoreCase(""))) && (!(author.equalsIgnoreCase("")))) && ((!(title.equalsIgnoreCase(""))) || (!(isbn.equalsIgnoreCase(""))))) {
                        String query = "insert into book(au_id, publ_id";
                        if (!(title.equalsIgnoreCase(""))) {
                            query += ", title"; // dodaj "title" listi kolona   
                        }
                        if (!(isbn.equalsIgnoreCase(""))) {
                            query += ", isbn"; // dodaj "isbn" listi kolona
                        }
                        if (!(price.equalsIgnoreCase(""))) {
                            query += ", price"; // dodaj "price" listi kolona
                        }
                        if (!(pages.equalsIgnoreCase(""))) {
                            query += ", pages"; // dodaj "pages" listi kolona
                        }
                        if (!(category.equalsIgnoreCase(""))) {
                            query += ", category"; // dodaj "category" listi kolona
                        }
                        if (!(descr.equalsIgnoreCase(""))) {
                            query += ", descr"; // dodaj "descr" listi kolona
                        }
                        if (!(yrpublished.equalsIgnoreCase(""))) {
                            query += ", publ_year"; // dodaj "publ_year" listi kolona
                        }
                        
                        query += " ) values ((select au_id from author where au_name='" + author + "'),"; // nađi au_id za autora
                        query += " (select publ_id from publisher where (publ_name='" + publisher + "') "; // nađi publ_id za izdavača
                        query += " ),";
                        if (!(title.equalsIgnoreCase(""))) {
                            query += "'" + title + "'"; // dodaj naslov upitu
                        }
                        if ((!(title.equalsIgnoreCase(""))) && (!(isbn.equalsIgnoreCase("")))) {
                            query +=  ",";
                        }
                        if (!(isbn.equalsIgnoreCase(""))) {
                            query += "'" + isbn + "'"; // dodaj isbn upitu 
                        }
                        if (!(price.equalsIgnoreCase(""))) {
                            query += ",'" + price + "'"; // dodaj cenu upitu
                        }
                        if (!(pages.equalsIgnoreCase(""))) {
                            query += ",'" + pages + "'"; // dodaj broj stranica upitu
                        }
                        if (!(category.equalsIgnoreCase(""))) {
                            query += ",'" + category + "'"; // dodaj žanr upitu
                        }
                        if (!(descr.equalsIgnoreCase(""))) {
                            query += ",'" + descr + "'"; // dodaj opis knjige upitu
                        }
                        if (!(yrpublished.equalsIgnoreCase(""))) {
                            query += ",'" + yrpublished + "'"; // dodaj godinu izdavanja upitu
                        }
                        query += ");";
                        
                        preparedStmt = con.prepareStatement(query);
                        preparedStmt.execute(); // izvrši upit
                        
                        // Prikaži veb stranicu sa porukom da je knjiga uspešno dodata bazi
                        returnStr = "SUCC_ADD"; // rezultat dodavanja knjige bazi
                    } 
                } // kraj else ( od if (excOccured))
            } // kraj else ( od if (excOccured))
        } catch (SQLException e) {
            returnStr = "ERR_ADD";
        }
        
        // rukovanje izuzetkom
        finally {
            if (con != null) {
                try {
                    con.close(); // zatvaranje objekta Connection
                } catch (Exception e) {
                    System.out.print("Izuzetak: ");
                    System.out.println(e.getMessage());
                }
                con = null;
            }
            
            if (rs != null) {
                try {
                    rs.close(); // zatvaranje objekta RecordSet
                } catch (Exception e) {
                    System.out.print("Izuzetak: ");
                    System.out.println(e.getMessage());
                }
                rs = null;
            }
	
            if (stmt != null) {
                try {
                    stmt.close(); // zatvaranje objekta Statement
                } catch (Exception e) {
                    System.out.print("Izuuzetak: ");
                    System.out.println(e.getMessage());
                }
                stmt = null;
            }
            
            if (preparedStmt != null) {
                try {
                    preparedStmt.close(); // zatvaranje objekta Statement
                } catch (Exception e) {
                    System.out.print("Izuuzetak: ");
                    System.out.println(e.getMessage());
                }
                preparedStmt = null;
            }
        }
        return returnStr;
    }
}
