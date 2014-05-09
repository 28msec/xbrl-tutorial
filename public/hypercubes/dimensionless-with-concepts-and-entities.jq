import module namespace sec = "http://xbrl.io/modules/bizql/profiles/sec/core";
import module namespace companies = "http://xbrl.io/modules/bizql/profiles/sec/companies";

let $hypercube := sec:dimensionless-hypercube({
  Concepts: [ "us-gaap:Assets", "us-gaap:Equity" ],
  Entities: [ companies:companies-for-tags("DOW30")._id ]
}
return count(sec:facts-for-hypercube($hypercube))
