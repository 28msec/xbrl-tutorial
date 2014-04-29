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
    }
  }
}
return count(sec:facts-for-archives-and-concepts($sec:ALL_OF_THEM, ("us-gaap:Assets", "us-gaap:Equity"), { Hypercube: $hypercube }))