/*
 * author: Ingrid Farkaš
 * project: Ptica
 * ConnectionManager.java: creates a connection to the database
 */
package connection;

import java.sql.*;
import java.util.*;

public class ConnectionManager {
    static Connection con;
    static String url;
            
    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3305/bookstore?useSSL=false";
            try {            	
               // connecting to the database, with the username: "root", password: "bird&2018" 
               con = DriverManager.getConnection(url, "root", "bird&2018"); 
            }
            
            catch (SQLException ex) {
               ex.printStackTrace();
            }
        }

        catch (ClassNotFoundException e)
        {
            System.out.println(e);
        }
        return con;
    }
}
    

