import module namespace facts =
    "http://xbrl.io/modules/bizql/facts";

import module namespace sec =
    "http://xbrl.io/modules/bizql/profiles/sec/core";
import module namespace companies =
    "http://xbrl.io/modules/bizql/profiles/sec/companies";

let $hypercube := sec:user-defined-hypercube({
  "xbrl:Entity" : {
    Domain: [  companies:companies-for-tags("DOW30")._id ]
  }, 
  "us-gaap:StatementEquityComponentsAxis" : {
    Domain: [ "us-gaap:CommonStockMember" ]
  },
  "sec:FiscalPeriod" : {
    Domain: [ "FY" ]
  },
  "sec:FiscalYear" : {
    Domain: [ 2012 ]
  }
})
let $fact := sec:facts-for-hypercube($hypercube)
return companies:companies($fact ! facts:entity-for-fact($$))
    .Profiles.SEC.CompanyName