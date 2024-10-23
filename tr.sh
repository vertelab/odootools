#!/bin/bash

function tr_word() {
    echo $1 $2  $file
    perl -p -i -e "s/\%\($1\)s/\%\($2\)s/g" $file 
    perl -p -i -e "s/\%\($1\)r/\%\($2\)r/g" $file 
}

function tr_curly() {
    echo $1 $2  $file
    perl -p -i -e "s/\{$1\}/\{$2\}/g" $file 
}
function tr_phrase() {
    echo $1 $2  $file
    perl -p -i -e "s/$1/$2/g" $file 
}
file=$1

tr_word attribut attribute
tr_word pris   price
tr_word belopp amount
tr_word påslag surcharge
tr_word bas base
tr_word rabatt discount
tr_word rabatt_avgift discount_charge
tr_word totalt_belopp total_amount
tr_word procent percentage
tr_word produkt product 
tr_word produkter products
tr_word "v\ärde" value
tr_word "produkt_src" "product_src"
tr_word "produkt_dest" "product_dest"
tr_word "pris_till\ägg" price_surcharge
tr_word procent percentage
tr_word "f\öretag" company
tr_word fel error
tr_word vy view
tr_word namn name
tr_word fil file

tr_phrase "%(fält)s" "%(field)s"
tr_phrase "%(fält_grupper)s" "%(field_groups)s"
tr_phrase "%(beskrivning)s" "%(description)s"
tr_phrase "%(namn)s" "%(name)s"
tr_phrase "%(grupper)s" "%(groups)s"
tr_phrase "%(nod)s" "%(node)s"
tr_phrase "%(modell)s" "%(model)s"
tr_phrase "%(antal)s" "%(count)s"
tr_phrase "%(tid)s" "%(time)s"
tr_phrase "%(detaljer)s" "%(details)s"
tr_phrase "%(användning)s" "%(use)s"
tr_phrase "%(filnamn)s" "%(file_name)s"
tr_phrase "%(felmeddelande)s" "%(error_message)s"
tr_phrase "%(relaterat_fält)s" "%(related_field)s"
tr_phrase "%(start_datum)s" "%(start_date)s"
tr_phrase "%(slut_datum)s" "%(end_date)s"
tr_phrase "%(team_namn)s" "%(team_name)s"
tr_phrase "%(arbetade_timmar)s" "%(worked_hours)s"
tr_phrase "%(metod)s" "%(method)s"
tr_phrase "%(övrigt_utgiftsnamn)s" "%(other_expense_name)s"
tr_phrase "%(anställningsnamn)s" "%(employee_name)s"
tr_phrase "%(utgiftsnamn)s" "%(expense_name)s"


tr_phrase "oi oi-pil-höger" "oi oi-arrow-right"




tr_phrase "&amp; &amp; &amp; &amp; &amp;;;;;;;;;;;;;;;;;;;;;;;;;;;;" "&amp;nbsp;&amp;nbsp;"
tr_word total_kredit total_credit
tr_curly nytt_datum new_date
tr_phrase "Analytisk redovisning" Objektredovisning
tr_phrase "Analytisk distributionsmodell" Objektfördelning
tr_phrase "Analytisk distributionsmodeller" Objektfördelningnar
tr_phrase "Analytisk distributions\ökning" "Sökning objektfördelning"
tr_phrase "Analytiskt filter" "Objektfilter"
tr_phrase "Analytisk Plans Tillämpbarheter" "Tillämpbara objektscheman"
tr_phrase "Analytiska planer" "Objektscheman"
tr_phrase "Analytisk Precision" "Objektprecision"
tr_phrase "Analytisk Rapportering" "Objektrapportering"
tr_phrase "Analytisk Rapportering" "Objektrapportering"
tr_phrase "Analytisk" "Objekt"
tr_phrase "Etapp" "Läge"
tr_phrase "TRUE" "SANT"
tr_phrase "FALSE" "FALSK"
tr_phrase "Förkasta" "Avbryt"
tr_phrase "förkasta" "avbryt"
tr_phrase " Token" " pollett"
tr_phrase " token" " pollett"
tr_phrase " tokens" " polletter"
tr_phrase " Feedback" " \Återkoppling"
tr_phrase " feedback" " \återkoppling"
tr_phrase "Analyskonto" "Objektkonto"
tr_phrase "Analyskonto" "Objektkonto"
tr_phrase "Analysrad" "Objekttransaktion"
tr_phrase "Analysrader" "Objekttransaktion"
tr_phrase "Analyser" "Objekt"
tr_phrase "analytiska distribution" "objektf\ördelning"
tr_phrase "analytiskt konto" objektkonto
tr_phrase "analytiska budgetar" objektbudgetar
tr_phrase "analyskonto" objektkonto
tr_phrase "betalningstoken " "betalningspollett "
tr_phrase "Journalposterna " "Verifikaten "
tr_phrase "journalposterna " "verifikaten "
tr_phrase "Journalpostens " "Verifikatets "
tr_phrase "journalpostens " "verifikatets "
tr_phrase "Journalposten " "Verifikatet "
tr_phrase "journalposten " "verifikatet "
tr_phrase "journalpost " "verifikat "
tr_phrase "Journalpost " "Verifikat "
tr_phrase "Journalverifikat " "Verifikat "
tr_phrase "journalverifikat " "verifikat "
tr_phrase "Journalanteckning " "Verifikat "
tr_phrase "journalanteckning " "verifikat "
tr_phrase "journalposter " "verifikat "
tr_phrase "Journalposter " "Verifikat "
tr_phrase "journalanteckning " "verifikat "
tr_phrase "journalanteckningar " "verifikat "
tr_phrase "Journalanteckning " "Verifikat "
tr_phrase "Journalanteckningar " "Verifikat "
tr_phrase "Journalinl\ägg " "Verifikat "
tr_phrase "journalinl\ägg " "verifikat "
tr_phrase "Din journalf\öring " "Ditt verifikat "
tr_phrase "din journalf\öring " "ditt verifikat "
tr_phrase "bokf\öringsposter " "verifikat "
tr_phrase "Bokf\öringsposter " "Verifikat "
tr_phrase "bokf\öringsposten " "verifikatet "
tr_phrase "Bokf\öringsposten " "Verifikatet "
tr_phrase "bokf\öringsposterna " "verifikaten "
tr_phrase "Bokf\öringsposterna " "Verifikaten "
tr_phrase "bokf\öringspost " "verifikat "
tr_phrase "Bokf\öringspost " "Verifikat "
# tr_phrase "e.g. " "till exempel "
tr_phrase "Arbetspost " "Arbetsuppgift "
tr_phrase "arbetspost " "arbetsuppgift "
tr_phrase "Arbetsposter " "Arbetsuppgifter "
tr_phrase "arbetsposter " "arbetsuppgifter "
tr_phrase "validerad" "bekräftad"
tr_phrase "valideras" "bekräftas"
tr_phrase "Omv\änd journalf\öring" "Omv\änt verifikat "
tr_phrase "konto\.move" "account\.move"
tr_phrase "<tjocklek>" "<tbody>"
tr_phrase "-->>" "-->"
tr_phrase "ledtr\ådar " "kund\ämnen "
tr_phrase "Visa namn" "Visningsnamn"
tr_phrase "Följare (Partners)" "Följare (Kontakter)"
tr_phrase "Journalanteckning" "Verifikat"

