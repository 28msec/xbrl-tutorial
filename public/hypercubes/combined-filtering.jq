import module namespace facts = "http://xbrl.io/modules/bizql/facts";
import module namespace hypercubes = "http://xbrl.io/modules/bizql/hypercubes";

import module namespace sec = "http://xbrl.io/modules/bizql/profiles/sec/core";
import module namespace companies = "http://xbrl.io/modules/bizql/profiles/sec/companies";

let $hypercube := hypercubes:user-defined-hypercube({
    "xbrl:Entity" : {
      Domain: [  companies:companies-for-tags("DOW30")._id ]
    }, 
    "us-gaap:StatementEquityComponentsAxis" : {
      Domain: [ "us-gaap:CommonStockMember" ]
    }
  }
}
let $fact := sec:facts-for-hypercube(
  $hypercube,
  {
    Filter: {
      Profiles: {
        SEC: {
          Fiscal: {
            Period: "FY",
            Year: 2012
          }
        }
      }
    }
  }
)
return companies:companies(facts:entity-for-fact($fact)).Profiles.SEC.CompanyName
