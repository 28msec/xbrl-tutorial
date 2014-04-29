import module namespace facts = "http://xbrl.io/modules/bizql/facts";
import module namespace sec = "http://xbrl.io/modules/bizql/profiles/sec/core";
import module namespace companies = "http://xbrl.io/modules/bizql/profiles/sec/companies";

let $hypercube := {
  "Name" : "xbrl:DimensionlessHypercube", 
  "Aspects" : {
    "xbrl:Concept" : {
      "Name" : "xbrl:Concept"
    }, 
    "xbrl:Period" : {
      "Name" : "xbrl:Period"
    }, 
    "xbrl:Entity" : {
      "Name" : "xbrl:Entity",
      "Domains" : {| for $company in companies:companies-for-tags("DOW30")._id
                     return { $company : { Name: $company } }
      |}
    }, 
    "xbrl:Unit" : {
      "Name" : "xbrl:Unit", 
      "Default" : "xbrl:NonNumeric"
    },
    "us-gaap:StatementEquityComponentsAxis" : {
      "Name" : "us-gaap:StatementEquityComponentsAxis",
      "Domains" : { "us-gaap:CommonStockMember" : { Name: "us-gaap:CommonStockMember" } }
    }
  }
}
let $fact := sec:facts-for-archives-and-concepts($sec:ALL_OF_THEM, ("us-gaap:DividendsCommonStock"), {
        Hypercube: $hypercube,
        Filter: {
            Profiles: {
                SEC: {
                    Fiscal: {
                        Period: "FY",
                        Year: 2012
                    }
                }
            }
        } })
return companies:companies(facts:entity-for-fact($fact)).Profiles.SEC.CompanyName