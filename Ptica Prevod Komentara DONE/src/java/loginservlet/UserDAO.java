/*
 * autor   : Ingrid Farkaš
 * projekat: Ptica
 * UserDAO.java : izvršava SQL upit ( LoginServlet.java - metod doPost, SignUpServlet - metod doPost )
 */
package loginservlet;

import java.sql.*;
import connection.ConnectionManager;

public class UserDAO {
    static Connection currentCon = null;
    static ResultSet rs = null;  // rezultat upita 
	
    // metod login vraća admin - za administratora, emp - za zaposlenog koji nije admnistrator, none ako korisnik nije prijavljen 
    public static String login(String userName, String password) {
	
        String is_employee = "false"; // da li je korisnik zaposleni
        String is_admin = "false"; // da li je korisnik administrator
        
        Statement stmt = null;       
	    
        // upit
        String loginQuery = "select username, passw, adm from login where username='"
                            + userName
                            + "' AND passw='"
                            + password
                            + "';";
	    
        try {
            currentCon = ConnectionManager.getConnection(); // povezivanje sa bazom 
            stmt = currentCon.createStatement(); 
            rs = stmt.executeQuery(loginQuery);	// izvršavanje upita        
            
            if (rs.next()) { // korisnik sa unetim korisničkim imenom i lozinkom već postoji u bazi 
                is_admin = rs.getString("adm"); // da li je korisnik prijavljen kao administrator
                if (is_admin.equalsIgnoreCase("yes")) { // ako je korisnik administrator tada on nije običan zaposleni 
                    is_employee = "false";
                    is_admin = "true";
                } else { // ako je korisnik nije administrator tada je on običan zaposleni 
                    is_employee = "true";
                    is_admin = "false";
                }
            }
        } catch (Exception ex) {
            System.out.println("Neuspela prijava: Izuzetak: " + ex);
        } 
	    
        // rukovanje izuzecima
        finally {
            if (rs != null) {
                try {
                    rs.close(); // zatvaranje objekta RecordSet 
                } catch (Exception e) {
                    e.printStackTrace();
                }
                rs = null;
            }
	
            if (stmt != null) {
                try {
                    stmt.close(); // zatvaranje objekta Statement
                } catch (Exception e) {
                    e.printStackTrace();
                }
                stmt = null;
            }
	
            if (currentCon != null) {
                try {
                    currentCon.close(); // zatvaranje objekta Connection 
                } catch (Exception e) {
                    e.printStackTrace();
                }
                currentCon = null;
            }
        }

        if (is_employee.equals("true")) { // ako je korisnik prijavljen kao zaposleni, vraća "emp"
            return "emp";
        } else if (is_admin.equals("true")) { // ako je korisnik prijavljen kao admin vraća "admin"
            return "admin";
        } else { // ako se korisnik nije prijavio ni kao administrator ni kao zaposleni vraća "customer"
            return "customer";
        }
    }	
   
    // userExists: vraća TRUE ako korisnik sa unetim korisničkim imenom i lozinkom već postoji u bazi, inače vraća FALSE
    public static boolean userExists(String userName, String password) {
        boolean returnVal = false; // da li korisnik postoji
        
        Statement stmt = null;       
	    
        // upit za selektovanje korisnika sa unetim korisničkim imenom i lozinkom
        String userQuery = "select username, passw from login where username='";
        userQuery += userName + "'";
        userQuery += ";";
        
        try {
           currentCon = ConnectionManager.getConnection(); // povezivanje sa bazom 
           stmt = currentCon.createStatement(); 
           ResultSet rs = stmt.executeQuery(userQuery); // izvršavanje upita 
           if (rs.next())
               returnVal = true; // korisnik sa unetim korisničkim imenom i lozinkom već postoji u bazi 
           else
               returnVal = false; // korisnik ne postoji u bazi
        } catch (Exception ex) {
            System.out.println("Korisnik sa datim korisničkim imenom i lozinkom ne postoji: Izuzetak: " + ex);    
        } 
        
        // rukovanje izuzetkom
        finally {
            if (rs != null){
                try {
                    rs.close(); // zatvaranje objekta RecordSet
                } catch (Exception e) {
                    e.printStackTrace();
                }
                rs = null;
            } 
	
            if (stmt != null) {
                try {
                    stmt.close(); // zatvaranje objekta Statement
                } catch (Exception e) {
                    e.printStackTrace();
                }
                stmt = null;
            }
	
            if (currentCon != null) {
                try {
                    currentCon.close(); // zatvaranje objekta Connection
                } catch (Exception e) {
                    e.printStackTrace();
                }

                currentCon = null;
            }
        }
        return returnVal;
    }
           
    // signUp: vraća TRUE ako je novi korisnik uspešno dodat u tabelu login, inače vraća FALSE
    public static boolean signUp(String userName, String password, String name, String admin) {
        boolean returnVal = false; // da li je dodavanje novog korisnika uspešno 
        
        PreparedStatement pStmt = null;       
	    
        // SQL upit
        String loginQuery = "insert into login( username, passw";
        
        if (!name.equals(""))
            loginQuery += ", name"; 

        loginQuery += ", adm"; 
        loginQuery += " ) values ( '" + userName + "', '" + password + "'";
        // ako je korisnik uneo ime dodaj ime upitu
        if (!name.equals(""))
            loginQuery += ", '" + name + "'";
        // dodaj da li je novi korisnik administrator  
        if (admin.equals("adm_yes"))
            loginQuery += ", 'yes'";
        else
            loginQuery += ", 'no'";
        loginQuery += " );";
	    
        try {
           currentCon = ConnectionManager.getConnection(); // povezivanje sa bazom  
           pStmt = currentCon.prepareStatement(loginQuery); 
           pStmt.execute(loginQuery); // izvršavanje upita 
           returnVal = true; // novi korisnik je  uspešno dodat u bazu
        } catch (Exception ex) {
            System.out.println("Nije uspeo unos novog korisnika: Izuzetak: " + ex);    
        } 
        
        // rukovanje izuzetkom
        finally {	
            if (pStmt != null) {
                try {
                    pStmt.close(); // zatvarnje objekta PreparedStatement
                } catch (Exception e) {
                    System.out.println("Izuzetak: " + e); 
                }
                pStmt = null;
            }
	
            if (currentCon != null) {
                try {
                    currentCon.close(); // zatvaranje objekta Connection
                } catch (Exception e) {
                    System.out.println("Izuzetak: " + e); 
                }
                currentCon = null;
            }
        }
        return returnVal;
    }
}
