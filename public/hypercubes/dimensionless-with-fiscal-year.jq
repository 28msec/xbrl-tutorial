import module namespace sec = "http://xbrl.io/modules/bizql/profiles/sec/core";

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
      "Name" : "xbrl:Entity"
    }, 
    "xbrl:Unit" : {
      "Name" : "xbrl:Unit", 
      "Default" : "xbrl:NonNumeric"
    }
  }
}
return count(sec:facts-for-archives-and-concepts(
    $sec:ALL_OF_THEM,
    ("us-gaap:Assets", "us-gaap:Equity"),
    {
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
        }
    }
))