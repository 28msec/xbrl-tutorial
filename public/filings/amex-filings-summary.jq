import module namespace archives = "http://xbrl.io/modules/bizql/archives";
import module namespace companies = "http://xbrl.io/modules/bizql/profiles/sec/companies";
import module namespace filings = "http://xbrl.io/modules/bizql/profiles/sec/filings";
import module namespace fiscal = "http://xbrl.io/modules/bizql/profiles/sec/fiscal/core";

let $amex := companies:companies(4962)
for $filing in filings:filings-for-companies($amex)
return {
  AID: archives:aid($filing),
  Period: fiscal:fiscal-period($filing),
  Year: fiscal:fiscal-year($filing)
}