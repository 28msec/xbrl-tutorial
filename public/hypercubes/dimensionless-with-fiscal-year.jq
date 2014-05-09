import module namespace hypercubes = "http://xbrl.io/modules/bizql/hypercubes";

import module namespace sec = "http://xbrl.io/modules/bizql/profiles/sec/core";

let $hypercube := hypercubes:dimensionless-hypercube({
  Concepts: [ "us-gaap:Assets", "us-gaap:Equity" ]
}
return count(sec:facts-for-hypercube(
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
))
