import module namespace sec =
    "http://xbrl.io/modules/bizql/profiles/sec/core";

let $hypercube := sec:dimensionless-hypercube({
  Concepts: [ "us-gaap:Assets", "us-gaap:Equity" ]
})
return count(sec:facts-for-hypercube($hypercube))
