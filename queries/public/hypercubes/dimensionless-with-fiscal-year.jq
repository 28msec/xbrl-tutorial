import module namespace sec =
    "http://xbrl.io/modules/bizql/profiles/sec/core";

let $hypercube := sec:user-defined-hypercube({
    "xbrl:Concept": {
      Domain: [ "us-gaap:Assets", "us-gaap:Equity" ]
    },
    "sec:FiscalPeriod" : {
        Domain: [ "FY" ]
    },
    "sec:FiscalYear" : {
        Domain: [ 2012 ]
    }
}
)
return count(sec:facts-for-hypercube($hypercube))
