import module namespace fiscal = "http://xbrl.io/modules/bizql/profiles/sec/fiscal/core";
import module namespace sec-networks = "http://xbrl.io/modules/bizql/profiles/sec/networks";

let $filing := fiscal:filings-for-entities-and-fiscal-periods-and-years( 21344, "FY", 2012 )
let $balance-sheet := sec-networks:networks-for-filings-and-disclosures($filing, $sec-networks:BALANCE_SHEET)
return sec-networks:model-structures($balance-sheet)