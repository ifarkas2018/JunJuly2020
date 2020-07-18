/*
 * autor    : Ingrid Farkaš
 * projekat : Ptica
 * PticaMetodi.java : metodi koji se koriste više puta
 */
package miscellaneous;

import java.util.Enumeration;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class PticaMetodi {
    
    public static HttpSession returnSession(HttpServletRequest request) {
        HttpSession hSession = request.getSession(); // sesija kojoj ću dodati varijable
        return hSession;
    }
    
    // sessVarExists: vraća da li varijabla sesije name postoji u hSession
    public static boolean sessVarExists(HttpSession hSession, String name) { 
        boolean attr_found = false; // da li postoji varijabla sesije name
        String attrName = ""; // ime varijable u sesiji
        Enumeration enumAttr; // sadrži imena varijabli koje sam dodala sesiji  
        enumAttr = hSession.getAttributeNames(); // čitam imena varijabli sesije 
        while ((enumAttr.hasMoreElements()) && (!attr_found)) { // ako postoji sledeći element
            attrName = String.valueOf(enumAttr.nextElement()); // čitam sledeći element
            if (attrName.equals(name)) {
                attr_found = true; // pronađena je varijabla sesije sa imenom name 
            }
        }
        return attr_found;
    }
    
    // readSetSessV : čita i vraća vrednost varijable sesije sassVar
    // sessVar : ime varijable sesije
    public static String readSetSessV(HttpSession hSession, String sessVar) {
        String readVal = "";
        
        // ako je korisnik uneo email ( Newsletter ) tada čitam vrednost varijable sessVar
        if (PticaMetodi.sessVarExists(hSession, sessVar)) { 
            readVal = String.valueOf(hSession.getAttribute(sessVar));
            if (!readVal.equalsIgnoreCase("")) { 
                hSession.setAttribute(sessVar, ""); // sledeći put stranica je prikazana sessVar je ""  
            }
        } 
        return readVal;
    }
    
    // setToEmptyInput: postavi vrednost varijable sesije na "" za varijable input0, input1, ...
    public static void setToEmptyInput(HttpSession hSession) {
        String attrName = ""; // ime varijable sesije
        Enumeration enumAttr; // sadrži imena varijabli u sesiji
        enumAttr = hSession.getAttributeNames(); // imena varijabli sesije  
        while ((enumAttr.hasMoreElements())) { // ako postoji sledeći element
            attrName = String.valueOf(enumAttr.nextElement()); // čitam sledeći element
            if (attrName.startsWith("input")) {
                hSession.removeAttribute(attrName);
            }
        }
    }
    
    // setToEmpty: postavi vrednost varijable sesije na "" 
    public static void setToEmpty(HttpSession hSession) {
        String attrName = ""; // ime varijable sesije
        Enumeration enumAttr; // enumeration of variable names added to the session 
        enumAttr = hSession.getAttributeNames(); // imena varijabli sesije 
        while ((enumAttr.hasMoreElements())) { // ako postoji sledeći element
            attrName = String.valueOf(enumAttr.nextElement()); // čitam sledeći element
            hSession.removeAttribute(attrName); 
        }
    }
    
    // addBackslash : dodaje dve \ ( ako isApostrophy = true ) ispred ' 
    // ili tri \ ( ako isApostrophy = false ) ispred \ pre SVAKE pojave tog karaktera 
    // koristi se prilikom dodavanja opisa ( ili nekog drugog stringa ) bazi
    // @@@@@@@@@@@@@@@@@ descr zameni sa opis ( dodato u komentaru )
    public static String addBackslash(String descr, boolean isApostrophy){
        
        String newDescription = ""; // string u kome dodajem \ ispred '
        String strToChar; // podstring stringa opisa do \ ili '
        String strCharacter; // string koji se dodaje umesto ' ( ili \ )
        String strAfterChar; // podstring opisa iza ' ( ili \ )
        int prev_pos = -1; // pozicija prethodnog ' ili \
        int pos = 1; // pozicija ' ili \
        int stringLen = descr.length();
        
        if (isApostrophy) { 
            strCharacter = "\\'";
        } else {
            strCharacter = "\\\\";
        }
        
        if (!isApostrophy) {
            pos = descr.indexOf("\\", 0); // pronalazi poziciju \ počevši od pozicije prev_pos+3
        } else { 
            pos = descr.indexOf("'", 0); // pronalazi poziciju ' počevši od pozicije prev_pos+3
        }
        
        if (pos<0)
            newDescription = descr;
         
        // dok postoji sledeći \ zameni ga sa \\\\ ( ili dok postoji sledeći ' zameni ga sa \\' )
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
                
                stringLen++; // dodala sam stringu \
                
                if (!isApostrophy) {
                    pos = descr.indexOf("\\", prev_pos+3); // pronalazi poziciju \ počevši od pozicije prev_pos+3
                } else { 
                    pos = descr.indexOf("'", prev_pos+3); // pronalazi poziciju ' počevši od pozicije prev_pos+3
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
            String substrLevi = ""; // deo stringa s leva do .
            String substrDesni = ""; // deo stringa s desne strane do .
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
