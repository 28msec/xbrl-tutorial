import module namespace sec = "http://xbrl.io/modules/bizql/profiles/sec/core";
import module namespace fiscal = "http://xbrl.io/modules/bizql/profiles/sec/fiscal/core";

let $filing := fiscal:filings-for-entities-and-fiscal-periods-and-years( (4962, 1001039), "FY", 2012 )
return sec:facts-for-schema("FundamentalAccountingConcepts", $filing)