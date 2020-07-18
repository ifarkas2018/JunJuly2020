/*
 * autor    : Ingrid Farkaš
 * projekat : Ptica
 * SubscrDAO.java : rukuje izvršavanjem SQL upita ( SubscrServl.java, metod doPost )
 */
package subscrservlet;

import connection.ConnectionManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class SubscrDAO {
    static Connection con; 
    static ResultSet rs = null;  // rezultat upita
   
    // metod addEmail dodaje novi email u tabelu subscription
    // vraća "exists" ako email već postoji u tabeli subscription inače vraća TRUE ako je došlo do izuzetka, a vraća FALSE ako nije 
    // došlo do izuzetka
    public static String addEmail(String subscrEmail) {
        String excOccurred = "false"; // da li je došlo do izuzetka prilikom pristupa bazi podataka
    
        try {
            con = ConnectionManager.getConnection(); // povezivanje sa bazom 
            ResultSet rs; // objekat gde se čuva rezultat upita
            Statement stmt = con.createStatement();
            
            // da li email već postoji u tabeli subscription
            String query = "select * from subscription where email='" + subscrEmail + "';";
            rs = stmt.executeQuery(query);
            if (!(rs.next())) { // ako email NE POSTOJI u bazi dodaj ga    
                PreparedStatement preparedStmt;
                // 2. insert upit
                query = "insert into subscription(email) values ('" + subscrEmail + "');"; 
                preparedStmt = con.prepareStatement(query);
                preparedStmt.execute();
            } else {
                excOccurred = "exists";
            }
        } catch (SQLException e) {
            excOccurred = "true"; // došlo je do izuzetka
            return excOccurred;
        }
        return excOccurred; // vraća da li je došlo do izuzetka
    }
}
