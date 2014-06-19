import module namespace sec =
    "http://xbrl.io/modules/bizql/profiles/sec/core";

let $hypercube := sec:user-defined-hypercube({
    "xbrl:Concept": {
      Domain: [ "us-gaap:Assets", "us-gaap:Equity" ]
    },
    "sec:FiscalPeriod" : {
        Type: "string",
        Domain: [ "FY" ]
    },
    "sec:FiscalYear" : {
        Type: "integer",
        Domain: [ 2012 ]
    }
}
)
return count(sec:facts-for-hypercube($hypercube))
