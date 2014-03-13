import module namespace companies = "http://xbrl.io/modules/bizql/profiles/sec/companies";
import module namespace filings = "http://xbrl.io/modules/bizql/profiles/sec/filings";

let $apple := companies:companies(320193)
return filings:filings-for-companies($apple)