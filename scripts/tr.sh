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

# Vertel 2025-09-02
tr_phrase "<span osynlig=" "<span invisible="
tr_phrase "text-brytning text-muted" "text-break text-muted"
tr_phrase "aria-label=\"N\ästa" "aria-label=\"Next"
tr_phrase "text-bg-sekund\är" "text-bg-secondary"
tr_phrase "fa fa-penna" "fa fa-pencil"
tr_phrase "object.name eller 'n/a'" "object.name or 'n/a'"
tr_phrase "{{ objekt." "{{ object."
tr_phrase "{{ objekt.företag_id.namn" "{{ object.company_id.name"
tr_phrase "nästa_rank_id" "next_rank_id"
tr_phrase "id.namn" "in.name"
tr_word Lopp Kurser

## Odoo SA Point Of Sale 2025-09-12
tr_phrase "%(skatter)s" "%(taxes)s"
tr_phrase "%(titel)s" "%(title)s"

## odoo-base // booking
tr_phrase "%(bokningens_namn)s" "%(booking_name)s"
tr_phrase "%(deltagarens_namn)s" "%(attendee_name)s"

## Odoo SA Appointment 2025-09-11
tr_phrase "%(partner)s" "%(partners)s"
tr_phrase "fa fa-long-pil-h\öger" "fa fa-long-arrow-right"


## Silvertouch 2025-09-10
tr_phrase "%(tidsbokningar)s" "%(appointments)s"
tr_phrase "%(personal_användare)s" "%(staff_user)s"
tr_phrase "%(datum_start)s" "%(date_start)s"
tr_phrase "%(startdatum)s" "%(start_date)s"
tr_phrase "%(till_datum)s" "%(to_date)s"
tr_phrase "%(datum_slut)s" "%(date_end)s"
tr_phrase "%(slutdatum)s" "%(end_date)s"
tr_phrase "%(fr\ån_datum)s" "%(from_date)s"
tr_phrase "%(tid_start)s" "%(tid_start)s"
tr_phrase "%(tid_slut)s" "%(tid_end)s"
tr_phrase "%(tidszon)s" "%(timezone)s"
tr_phrase  "%(partner)s" "%(partners)s"
tr_phrase  "fa fa-varning" "fa fa-warning"
tr_phrase  "fa fa-info-cirkel" "fa fa-info-circle"
tr_phrase "%(deltagarnamn)s" "%(attendee_name)s"
tr_phrase "%(avtalsnamn)s" "%(appointment_name)s"
tr_phrase "%(namn_på_möte)s" "%(appointment_name)s"
tr_phrase "%(namn_på_partner)s" "%(partner_name)s"
tr_phrase "%(attributnamn)s" "%(attribute_name)s"
tr_phrase "%(varningsmeddelande_f\ör_hyrning)s" "%(renting_warning_message)s"
tr_phrase "%(konflikt_meddelande)s" "%(conflict_message)s"
tr_phrase "%(produkt)er" "%(product)s"

# OCA -- contract
tr_phrase "Kontrakts linje" "Kontraktsrader"
tr_phrase "Kontraktslinje" "Kontraktsrader"
tr_phrase "Contract Line" "Kontraktsrader"
tr_phrase "Kontraktslinjen" "Kontraktsraden"
tr_phrase "avtalslinje" "avtalsrad"
tr_phrase "object.name eller" "object.name or"
tr_phrase "(invoice_link)" "(faktural\änk)"
tr_phrase "Auto-price" "Autopris"
tr_phrase "{djup}" "{depth}"

tr_word nytt_datum_start new_date_start
tr_word nytt_datum_slut new_date_end
tr_word Kontraktslinje Kontraktsrad
tr_word Suspensionens Avstängningens


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
tr_word "produkt_src" product_src
tr_word "produkt_dest" product_dest
tr_word "pris_till\ägg" price_surcharge
tr_word procent percentage
tr_word "f\öretag" company
tr_word fel error
tr_word vy view
tr_word namn name
tr_word fil file
tr_word datum date

tr_word "f\ält" field
tr_word "f\ält_grupper" field_groups
tr_word beskrivning description
tr_word namn name
tr_word grupper groups
tr_word nod node
tr_word modell model
tr_word antal count
tr_word tid time
tr_word detaljer details
tr_word användning use
tr_word filnamn file_name
tr_word felmeddelande error_message
tr_word "relaterat_f\ält" related_field
tr_word start_datum start_date
tr_word slut_datum end_date
tr_word team_namn team_name
tr_word arbetade_timmar worked_hours
tr_word metod method
tr_word "\övrigt_utgiftsnamn" other_expense_name
tr_word anst\ällningsnamn employee_name
tr_word utgiftsnamn expense_name
tr_word tilldelnings_typ allocation_type
tr_phrase "%(f\ördelningstyp == 'periodiserad')s" "%(allocation_type == 'accrual')s"

tr_word varaktighet duration
tr_word max maximum
tr_word stat state
tr_word "l\änk)" link
tr_word timmar hours
tr_word minuter minutes

## account
tr_phrase "{konto_källnamn}" "{account_source_name}"
tr_phrase "{konto_målnamn}" "{account_target_name}"
tr_phrase "{länk}" "{link}"
tr_word field fields
tr_word records entries
tr_word record entry
tr_word kontonamn account_name
tr_word fakturadatum invoice_date
tr_word aktuell_total current_total
tr_word förväntad_total expected_total
tr_word medel mean
tr_word rad line
tr_word månad month
tr_word dag day
tr_word dagar days
tr_word valuta_belopp currency_amount
tr_phrase "{procent}" "{percent}"
tr_phrase "objekt.namn" "object.name"
tr_phrase "object.partner_id.name eller" "object.partner_id.name or"
tr_word nummer number
tr_word konto account
tr_word antal_konton num_accounts
tr_word kvantitet_levererad quantity_delivered
tr_word kvantitet_fakturerad quantity_invoiced
tr_word enhetspris unit_price
tr_word undantag exception
tr_word verifikat journal
tr_word Verifikat Journal
tr_phrase "Verifikat" "Journal Entry"
tr_word skatt_namn tax_name
tr_word landskod country_code
tr_word tagg tag
tr_word nb_av_värden nb_of_values

# mail
tr_word samtalsnamn conversation_name
tr_word typ type
tr_word "\åtgärd" operation
tr_word poster records
tr_word "anv\ändare" user
tr_word "anv\ändare1" user1
tr_word "anv\ändare2" user2
tr_word "anv\ändare3" user3
tr_word online_antal online_count
tr_word offline_antal offline_count
tr_word "tr\ådnamn" thread_name
tr_word "tr\ådnamn" threadName
tr_word underkanalsnamn subChannelName
tr_phrase "{'fält':'värde'}" "{'field': 'value'}"

tr_word "dom\än" domain
tr_word "dom\än_typ" domain_type
tr_word "f\ält" field
tr_word modell model
tr_word kanaler channels
tr_word goto_slut goto_end
tr_word "tr\ådnamn" thread_name

tr_word antal mottagare recipientCount
tr_word antal count
tr_word "anv\ändarnamn" user_name
tr_word samtalsnamn conversation_name
## mass_mailing
tr_word importerat_antal imported_count
tr_phrase "Nisse Hult" "John DOE"
tr_phrase "Nisse Hult" "John Doe"
tr_word "MittF\öretag" MyCompany

## mrp
tr_phrase "\"Fäll ut\" : \"Fäll in\" }" "Unfold' : 'Fold' }"
tr_phrase "{{ rekvisita.isFolded" "{{ props.isFolded"
tr_word produktnamn product_name
tr_word antal_boms number_of_boms
tr_phrase "%(produkt)er:" "%(product)s:"

## mrp_account
tr_phrase "%(order_list)s" "%(orders_list)s"

## payment
tr_phrase "oi-arrow-right ms-1 liten" "oi-arrow-right ms-1 small"
tr_phrase "%(kontohavare)s:" "%(account_holder)s:"
tr_phrase "%(kontonummer)s:" "%(account_number)s:"

## point_of_sale
tr_phrase "%(post)er:" "%(entry)s:"
tr_word betalningsmetod payment_method
tr_word "l\änk" link
tr_word originalpris original_price
tr_word rabatterat_pris discounted_price
tr_word session_namn session_name
tr_word kundnamn client_name
tr_word "f\öretagsnamn" company_name
tr_word "\är_fakturerat" is_invoiced
tr_word pos_namn pos_name
tr_word "\återbetalad_order" refunded_order
tr_word produktnamn product_name
tr_word gamla_pm old_pm
tr_word nya_pm new_pm
tr_word gamla_beloppet old_amount
## Att ta bort en produkt som är tillgänglig under en session skulle vara som att försöka ta en hamburgare ur en kunds hand mitt i tuggan; kaos kommer att uppstå när ketchup och majonnäs flyger överallt!

## pos_hr
tr_word betalningsmetod paymentMethod
tr_word "anst\älld" employee

## pos_restaurant
tr_word "v\åning" floor

## product
tr_word andra_prislistor other_pricelists
tr_word prislistor pricelists
tr_word produkt_antal product_count
tr_word "attribut_v\ärde" attribute_value
tr_word siffror digits
tr_word filnamn fileName
tr_word produkt_lista product_list
tr_word streckkod barcode
tr_word prislista pricelist
tr_word rabatt_typ discount_type
tr_word artikelnamn item_name
tr_word basbelopp base
tr_word rabatt_typ discount_type
tr_word "till\äggsavgift" surcharge
tr_word totalbelopp total_amount
tr_word "pristill\ägg" price_surcharge
tr_word rabattavgift discount_charge

tr_word prislistor pricelists
tr_word andra_prislistor other_pricelists
tr_word "attribut_v\ärde" attribute_value
tr_word produkt_antal product_count

tr_word kommando_start command_start
tr_word kommando_slut command_end
tr_word fet_start bold_start
tr_word fet_end bold_end
tr_word program_typ program_type
tr_word "v\ärde" value
tr_word kund_nummer customer_number

## project
tr_phrase "objekt.projekt_id.f\öretag_id.namn eller anv\ändare.env.företag.namn" "object.project_id.company_id.name or user.env.company.name"
tr_word projektlista projectList
tr_word synlighet visibility
tr_word datum date
tr_word kontoLista accountList
tr_word "v\änster" left
tr_word "h\öger" right
tr_phrase "{{'Viktig' if task.priority" "{{'Important' if task.priority"
tr_word partner_namn partner_name
tr_phrase "objekt.projekt_id.företag_id.namn eller användare.env.företag.namn" "object.project_id.company_id.name or user.env.company.name"
tr_word destination_projekt destination_project
tr_word källa_projekt source_project

## purchase
tr_word "%(s\äljare)s" "%(vendor)s"

## sale
tr_word "anv\ända_produkter" used_products
tr_phrase "%(order)" "%(order)s"
tr_word filnamn file_name
tr_word avkodare decoder
tr_word referens reference

## sale_pdf_quote_builder
tr_word f\ältnamn field_name
tr_word modellnamn model_name
tr_word s\ökv\äg path

## sale_project
tr_word procduct_name procduct_names

## 2025-05-12 odoo-management-system
tr_phrase "{{ bar.sträng }}" "{{ bar.string }}"



## sms
tr_word totalt total

## spreadsheet
tr_word _bredd _width
tr_word kvartal quarter
tr_word kvartal_nummer quarter_number
tr_word _höjd _height
tr_word andra_numret second_number
tr_word minut_antal minute_number
tr_word matchningar matches
tr_word intervall range
tr_word arknamn sheetName
tr_word tim_nummer hour_number
tr_word _bredd _width
tr_word formelId formulaId

## stock
tr_word lager warehouse
tr_word plats location
tr_word källa_lokal source_location
tr_word enhet unit
tr_word fel_linjer error_lines
tr_word plats_lista location_list
tr_word andra_platser other_locations
tr_word serienummer serial_number
tr_word plats_lista location_list
tr_word kod code
tr_word plocknamn picking_name
tr_word plats location
tr_word parti lot

## stock_account
tr_word kategori category
tr_word ny_metod new_method
tr_word gammal_metod old_method
tr_word nya new
tr_word gamla old
tr_word nytt_värde new_value
tr_word tidigare previous
tr_word anledning reason
tr_word nytt_pris new_price
tr_word post record
tr_word ny_kostnad new_cost

## stock_picking_batch
tr_word inkompatibla_överföringar incompatible_transfers

## odoo-resource 2025-06-10
tr_word "Stilla havet" Pacific
tr_word "stilla havet" pacific


## survey
tr_word "undersökningens namn" survey_names
tr_phrase "textbrytning textmuted" "text-break text-muted"
tr_phrase "oi oi-chevron-höger" "oi oi-chevron-right"


## web
tr_word visningsnamn displayName
tr_word gräns limit
tr_word meddelande message
tr_word mbLaddad mbLoaded

tr_phrase "{{plats}}" "{{location}}"
tr_phrase "oi oi-pil-h\öger" "oi oi-arrow-right"

## website
tr_word webbplatsnamn website_name
tr_word operation action
tr_word tangent key
tr_word e-post email


tr_phrase "visuellt dold" "visually-hidden"
tr_phrase "fa-pil-höger text-primär" "fa-arrow-right text-primar"
tr_phrase "fa-shopping-korg" "fa-shopping-basket"
tr_phrase "karusell-styrning-nästa-ikon" "carousel-control-next-icon"
tr_phrase "carousel-control-prev-icon" "karusellkontroll-prev-ikon"
tr_phrase "s_badge badge text-bg-sekundär o_animerbar" "s_badge badge text-bg-secondary o_animerbar"

## website_event
tr_phrase "oi-chevron-vänster" "oi-chevron-left"

## website_event_track
tr_word "kontaktnamn" "contact_name"
tr_word "funktion" "function"
tr_phrase "{{ objekt.namn }" "{{ object.name }"
tr_phrase "object.partner_id.name or object.partner_name or" "object.partner_id.name eller object.partner_name eller"

## website_forum
tr_phrase "fa fa-fråga-cirkel" "fa fa-question-circle"
tr_phrase "fa fa-svara mig-1" "fa fa-reply me-1"
tr_phrase "fa fa-flagga" "fa fa-flag"
tr_phrase "fa fa-pil-höger" "fa fa-arrow-right"

## website_hr_recruite
tr_word "rekryterare_kontakt" "recruiter_contact"
tr_phrase "fa-extern-länk" "fa-external-link"

## website_sale
tr_phrase "fa-bult me-2" "fa-bolt me-2"
tr_phrase "formulär-text" "form-text"
tr_phrase "record.namn.värde" "record.name.value"

## website_slides
tr_phrase "platshållare" "placeholder"
tr_phrase "fa fa-lås" "fa fa-lock"
tr_phrase "text-bg-varning" "text-bg-warning"
tr_phrase "text-varning" "text-warning"


tr_phrase "&amp; &amp; &amp; &amp; &amp;;;;;;;;;;;;;;;;;;;;;;;;;;;;" "&amp;nbsp;&amp;nbsp;"
tr_word total_kredit total_credit
tr_word nytt_datum new_date
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

