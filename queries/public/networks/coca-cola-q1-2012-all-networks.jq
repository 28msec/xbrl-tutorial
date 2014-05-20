import module namespace sec-networks = "http://xbrl.io/modules/bizql/profiles/sec/networks";

import module namespace fiscal = "http://xbrl.io/modules/bizql/profiles/sec/fiscal/core";

let $filing := fiscal:filings-for-entities-and-fiscal-periods-and-years( 21344, "Q1", 2012 )
return sec-networks:networks-for-filings($filing)