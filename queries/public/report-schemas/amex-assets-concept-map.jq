import module namespace sec = "http://xbrl.io/modules/bizql/profiles/sec/core";
import module namespace fiscal = "http://xbrl.io/modules/bizql/profiles/sec/fiscal/core";

let $filing := fiscal:filings-for-entities-and-fiscal-periods-and-years( 4962, "FY", 2012 )
return sec:facts-for({
    Hypercube:
        sec:user-defined-hypercube({
            "sec:Archive" : {
                Type: "string",
                Domain: [ $filing._id ]
            },
            "xbrl:Concept" : {
                Domain: [ "fac:Assets" ]
            }
        }),
        ConceptMaps: "FundamentalAccountingConcepts"
    }
)
