/* Projekat : Ptica
 * Autor : Ingrid Farkaš
 * validationJS.js: funkcije korišćene za validaciju
 */

NAME_VAL = 'true'; // da li input field za celo ime sadrži samo slova( i apostrof )
FNAME_VAL = 'true'; // da li input field za ime sadrži samo slova( i apostrof )
LNAME_VAL = 'true'; // da li input field za prezime sadrži samo slova( i apostrof )
ISBN_VAL = 'true'; // da li ISBN input field sadrži samo cifre
PRICE_VAL = 'true'; // da li input field za cenu sadrži samo cifre( i tačku i zarez )
PG_VAL = 'true'; // da li input field za broj stranica sadrži samo cifre
YRPUBL_VAL = 'true'; // da li input field za godinu izdavanja sadrži samo cifre

// setVal: zavisno od num_type, postavlja jednu od variabli na vrednost value
function setVal(num_type, value) {
    if (num_type == 'is_isbn') {
        ISBN_VAL  = value;
    } else if (num_type == 'is_pages') {
        PG_VAL = value;
    } else if (num_type == 'is_price') {
        PRICE_VAL = value;
    } else if (num_type == 'is_yrpubl') {
        YRPUBL_VAL = value;
    }
}

// isNumber: prikazuje poruku( u msg_field) ako je korisnik uneo vrednost koja nije broj( u input field za nazivom input_field )
// ako je characters true, broj može da sadrži % ili _
// ako je dec_point true, broj može da sadrži .
// num_type - da li je unos u input field-u isbn, cena, broj stranica ili godina
// formid: id forme
function isNumber(formid, input_field, num_type, msg_field, characters, dec_point) {
    var number;
    var regex;
    
    number = document.getElementById(input_field).value;
    if (characters && dec_point) { // %, _ ili . može da se unese u input field( pored cifara )
        regex = /^[0-9\x25\x5F\x2E]+$/;
    } else if (dec_point) {
        regex = /^[0-9\x2E]+$/;
    } else if (characters) { // % or _ može da se unese u input field ( pored cifara )
        regex = /^[0-9\x25\x5F]+$/;
    } else {
        regex = /^[0-9]+$/;
    }
    if (number != '') {
        // ako vrednost unesena za isbn nije broj ( ako je characters true, broj može da sadrži % ili _ )
        if (!regex.test(number)) {
            if (characters && dec_point) { // %, _, . can be entered in the input field ( beside digits )
                document.getElementById(msg_field).innerHTML = "Ovo polje može da sadrži cifre (džoker znakove i decimalnu tačku)"; // show the message
            } else if (dec_point) { 
                document.getElementById(msg_field).innerHTML = "Ovo polje može da sadrži cifre (i decimalnu tačku)"; 
            } else if (characters) {
                document.getElementById(msg_field).innerHTML = "Ovo polje može da sadrži cifre (i džoker znakove)"; 
            } else {
                document.getElementById(msg_field).innerHTML = "Ovo polje može da sadrži cifre."; // prikaži poruku
            }
            setVal( num_type, 'false' );
        } else {
            setVal( num_type, 'true' );
            document.getElementById(msg_field).innerHTML = ""; // prikaži poruku 
        }
    } else {
        setVal( num_type, 'true' );
        document.getElementById(msg_field).innerHTML = ""; // prikaži poruku 
    }
}

// dalijeCena: prikazuje poruku( u msg_field ) ako je korisnik uneo vrednost koja nije cena( u input field za nazivom input_field )
// num_type - da li je unos u input field-u isbn, cena, broj stranica ili godina
// formid: id forme
function daLiJeCena(formid, input_field, num_type, msg_field) {
    var number;
    var regex;
    
    number = document.getElementById(input_field).value;
    regex = /^[0-9\x2C\x2E]+$/; // može da sadrži cifre, zarez i decimalnu tačku
    if (number.length > 9) {
        document.getElementById(msg_field).innerHTML = "Ovo polje može da sadrži cenu manju ili jednaku 99.999,99"; 
        setVal(num_type, 'false');
    } else {
        if (number != '') {
            // ako vrednost unesena za isbn nije broj
            if (!regex.test(number)) { 
                document.getElementById(msg_field).innerHTML = "Ovo polje može da sadrži cenu ( cifre, tačku i zarez )"; 
                setVal(num_type, 'false');
            } else {
                setVal(num_type, 'true');
                document.getElementById(msg_field).innerHTML = ""; // prikaži poruku  
            }
        } else {
            setVal( num_type, 'true' );
            document.getElementById(msg_field).innerHTML = ""; // prikaži poruku  
        }
    }
}

// setNameVal - zavisno da li je korisnik uneo celo ime, ime ili prezime postavi vrednost odgovarajuće varijable
// name_type: 'fullname' ( korisnik uneo celo ime ), 'firstname', 'lastname' 
// value: 'true' or 'false'
function setNameVal(name_type, value) {
    switch (name_type) { // zavisno da li je korisnik uneo celo ime, ime ili prezime postavi vrednost odgovarajuće varijable
        case 'fullname':
            NAME_VAL = value;
            break;
        case 'firstname':
            FNAME_VAL = value;
            break;
        case 'lastname':
            LNAME_VAL = value;
            break;
        default:
    }
}

// valLetters: proverava da li su u input_field unesena samo slova( ili apostrofi, zarezi, -, prazno mesto, %, _ ).
// ako je nešto drugo uneseno u message_span se prikazuje poruka
// required - ako je popunjavanje polja obavezno pre prikazivanja poruke, kada korisnik ispravi grešku, ispod polja se ponovo prikazuje
// poruka da je polje obavezno
// name_type - 'fullname'( korisnik je uneo celo ime ), 'firstname', 'lastname'
// characters - da li se džoker znakovi mogu pojaviti u polju
function valLetters(input_field, message_span, name_type, characters, required) {
    var regex;
    
    if (characters) { // % ili _ može da se unese u polje( pored slova, apostrofa, zareza, -, praznog mesta )
        regex = /^[a-zA-Z\x27\x20\x2C\x2D\x25\x5F]+$/;
    } else {
        regex = /^[a-zA-Z\x27\x20\x2C\x2D]+$/;
    }
    if (!input_field.value == '') {
        if (!regex.test(input_field.value)) { // ako je korisnik uneo karaktere koja nisu slova( u polje )
            if (characters)
                message_span.innerHTML = "Ovo polje može da sadrži slova, prazno mesto, džoker znakove i znakove ,'- ";
            else
                message_span.innerHTML = "Ovo polje može da sadrži slova, prazno mesto, i znakove ,'- ";
            setNameVal(name_type, 'false');
        } else { // ako je korisnik uneo karaktere koja su slova( u polje )
            setNameVal(name_type, 'true');
            if (required == 'true') {
                message_span.innerHTML = "Ovo polje je obavezno.";
            } else {
                message_span.innerHTML = "";
            }
        }
    } else {
        if (required == 'true') {
            setNameVal(name_type, 'false');
            message_span.innerHTML = " ";
        } else {
            setNameVal(name_type, 'true');
            NAME_VAL = 'true';
            message_span.innerHTML = "";
        }
    }
}

// checkForm: ako je validacija uspešna onda vraća TRUE inače vraća FALSE
function checkForm(){
    if ((NAME_VAL === 'true') && (FNAME_VAL === 'true') && (LNAME_VAL === 'true') && (ISBN_VAL === 'true') && (PRICE_VAL === 'true') && (PG_VAL === 'true') && (YRPUBL_VAL === 'true')) { 
        return true;
    } else {
        return false;
    }
}

