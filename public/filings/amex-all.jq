import module namespace companies = "http://xbrl.io/modules/bizql/profiles/sec/companies";
import module namespace filings = "http://xbrl.io/modules/bizql/profiles/sec/filings";

let $amex := companies:companies(4962)
return filings:filings-for-companies($amex)