import module namespace companies = "http://xbrl.io/modules/bizql/profiles/sec/companies";
import module namespace filings = "http://xbrl.io/modules/bizql/profiles/sec/filings";

let $apple := companies:companies(4962)
let $google := companies:companies(1001039)
return filings:filings-for-companies( ($apple, $google) )