import module namespace hypercubes = "http://xbrl.io/modules/bizql/hypercubes";
import module namespace sec = "http://xbrl.io/modules/bizql/profiles/sec/core";

let $hypercube := hypercubes:dimensionless-hypercube()
return count(sec:facts-for-archives-and-concepts((), ("us-gaap:Assets", "us-gaap:Equity"), { Hypercube: $hypercube }))