import module namespace archives =
    "http://xbrl.io/modules/bizql/archives";

import module namespace sec =
    "http://xbrl.io/modules/bizql/profiles/sec/core";
import module namespace fiscal =
    "http://xbrl.io/modules/bizql/profiles/sec/fiscal/core";

let $filing :=
  fiscal:filings-for-entities-and-fiscal-periods-and-years(
    (4962, 1001039),
    "FY",
    (2011, 2012)
  )
let $hypercube := sec:user-defined-hypercube({
    "sec:Archive" : {
        Type: "string",
        Domain: [ archives:aid($filing) ]
    }
})
return count(sec:facts-for-hypercube($hypercube))
