/*
 * author: Ingrid Farkaš
 * project: Ptica
 * PticaMetodi.java : methods used more then once
 */
package miscellaneous;

import java.util.Enumeration;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class PticaMetodi {
    
    public static HttpSession returnSession(HttpServletRequest request) {
        HttpSession hSession = request.getSession(); // retrieve the session (to which I am going to add and read variables)
        return hSession;
    }
    
    // sessVarExists: vraća da li varijabla sesije name postoji u hSession
    public static boolean sessVarExists(HttpSession hSession, String name) { 
        boolean attr_found = false; // is the atribute named name one of variables in the session
        String attrName = ""; // the name of the attribute in the session
        Enumeration enumAttr; // enumeration of variable names added to the session
        enumAttr = hSession.getAttributeNames(); // the names of the session variables 
        while ((enumAttr.hasMoreElements()) && (!attr_found)) { // while the Enumeration has more el.
            attrName = String.valueOf(enumAttr.nextElement()); // read the next element
            if (attrName.equals(name)) {
                attr_found = true; // attribute with the name emp_adr was found
            }
        }
        return attr_found;
    }
    
    // readSetSessV : reads and returns the session variable named sessVar
    // sessVar : name of the session variable
    public static String readSetSessV(HttpSession hSession, String sessVar) {
        String readVal = "";
        
        // if the user entered the email (Subscribe) then read the session var. sessVar
        if (PticaMetodi.sessVarExists(hSession, sessVar)) { 
            readVal = String.valueOf(hSession.getAttribute(sessVar));
            if (!readVal.equalsIgnoreCase("")) { 
                hSession.setAttribute(sessVar, ""); // the next time the page is loaded the sessVar is ""  
            }
        } 
        return readVal;
    }
    
    // setToEmptyInput: set the session variable values to "" for the variables named input0, input1, ...
    public static void setToEmptyInput(HttpSession hSession) {
        String attrName = ""; // the name of the attribute in the session
        Enumeration enumAttr; // enumeration of variable names added to the session
        enumAttr = hSession.getAttributeNames(); // the names of the session variables 
        while ((enumAttr.hasMoreElements())) { // while the Enumeration has more el.
            attrName = String.valueOf(enumAttr.nextElement()); // read the next element
            if (attrName.startsWith("input")) {
                hSession.removeAttribute(attrName);
            }
        }
    }
    
    // setToEmpty: set the session variable values to "" 
    public static void setToEmpty(HttpSession hSession) {
        String attrName = ""; // the name of the attribute in the session
        Enumeration enumAttr; // enumeration of variable names added to the session 
        enumAttr = hSession.getAttributeNames(); // the names of the session variables 
        while ((enumAttr.hasMoreElements())) { // while the Enumeration has more el.
            attrName = String.valueOf(enumAttr.nextElement()); // read the next element
            hSession.removeAttribute(attrName); // attribute with the name emp_adr was found
        }
    }
    
    // addBackslash : adds 2 back slashes (if isApostrophy = true)  before the ' 
    // or 3 back slashes (if isApostrophy = false)  before the \ before EVERY appearance of that character
    // used to add the description (or some other string) to the database
    public static String addBackslash(String descr, boolean isApostrophy){
        
        String newDescription = ""; // the description where I add \ before the '
        String strToChar; // the substring of the description to the \ or '
        String strCharacter; // the string to be added instead of the ' ( or \ )
        String strAfterChar; // the substring of the description after the ' ( or \ )
        int prev_pos = -1; // position of the prevoius ' or \
        int pos = 1; // position of the ' or \
        int stringLen = descr.length();
        
        if (isApostrophy) { 
            strCharacter = "\\'";
        } else {
            strCharacter = "\\\\";
        }
        
        if (!isApostrophy) {
            pos = descr.indexOf("\\", 0); // finds the position of the \ starting from the position = prev_pos+3
        } else { 
            pos = descr.indexOf("'", 0); // finds the position of the ' starting from the position = prev_pos+3
        }
        
        if (pos<0)
            newDescription = descr;
        
        // while the next \ is found in the string substitute it with \\\\ (or while the next ' is found in the string substitute it with \\') 
        while (pos >= 0) {
            newDescription = "";
            prev_pos = pos-1;
            
            if (pos >= 0) {
                strToChar = descr.substring(0, pos);
                strAfterChar = descr.substring(pos+1, stringLen);
                newDescription = newDescription.concat(strToChar);
                newDescription = newDescription.concat(strCharacter);
                newDescription = newDescription.concat(strAfterChar);
                descr = newDescription;
                
                stringLen++; // I've added to the string \
                
                if (!isApostrophy) {
                    pos = descr.indexOf("\\", prev_pos+3); // finds the position of the \ starting from the position = prev_pos+3
                } else { 
                    pos = descr.indexOf("'", prev_pos+3); // finds the position of the ' starting from the position = prev_pos+3
                }
            }
        }
        return newDescription;
    }
    
    // addBacksl : poziva metod koji zamenjuje svaku pojavu \ sa \\\\ i zamenjuje svaku pojavu ' sa \\'
    public static String addBacksl(String descr) {
        boolean isApostrophy = false; // da li je karakter pre koga treba da dodam \\ je ' ( ili \ )
                
        // zamenjuje svaku pojavu \ sa \\\\
        descr = addBackslash(descr, isApostrophy);
        isApostrophy = true;
        // zamenjuje svaku pojavu ' sa \\'
        descr = addBackslash(descr, isApostrophy);
       
        return descr;
    }
    
    // deleteSpaces: uklanja prazan prostor sa početka i kraja stringa i zamenjuje 2 ili više prazna mesta ( unutar stringa )
    // sa jednim praznim mestom
    public static String deleteSpaces(String str) {
        String newString = str.trim(); // uklanja prazan prostor sa početka i kraja stringa
        newString = newString.replaceAll("\\s+", " "); // zamenjuje 2 ili više prazna mesta sa jednim praznim mestom
        return newString;
    }
    
    // dodajTacku: dodaje tačku u cenu iza hiljadu dinara 
    public static String dodajTacku(String price) {
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
        return price;
    }
}
