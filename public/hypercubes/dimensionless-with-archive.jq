import module namespace hypercubes = "http://xbrl.io/modules/bizql/hypercubes";

import module namespace sec = "http://xbrl.io/modules/bizql/profiles/sec/core";
import module namespace fiscal = "http://xbrl.io/modules/bizql/profiles/sec/fiscal/core";

let $hypercube := hypercubes:dimensionless-hypercube()
let $filing := fiscal:filings-for-entities-and-fiscal-periods-and-years( (4962, 1001039), "FY", (2011, 2012) )
return count(sec:facts-for({
  Hypercube: $hypercube 
  Filter: {
    Archive: $filing
  }
}))
