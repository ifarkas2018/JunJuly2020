/*
 * autor   : Ingrid Farkaš
 * projekat: Ptica
 * DetermineID.java : koristi se u DelServlet.java
 */
package delservlet;

import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;

public class DetermineID {
    
    // za autora sa imenom auth_name vraća author id
    public String determineAuthID(String auth_name, Statement stmt) { 
        try {
            // formiranje upita SELECT au_id FROM author WHERE au_name='...';
            String authid = ""; // broj autora
            
            // formiranje upita
            String rs_query = "SELECT au_id "; 
            rs_query += "FROM author WHERE au_name='" + auth_name + "'";
            rs_query += ";";   
            
            // izvršavanje upita
            ResultSet rs = stmt.executeQuery(rs_query);
            
            // ako rezultat upita sadrži slogove, nalazim broj autora 
            if (rs.next()) 
                authid = rs.getString("au_id");
            return authid;
            
        } catch (SQLException ex) {
            return ""; // ako je došlo do izuzetka vraćam broj autora = ""
        }
    }
}
