import module namespace hypercubes = "http://xbrl.io/modules/bizql/hypercubes";

import module namespace sec = "http://xbrl.io/modules/bizql/profiles/sec/core";

let $hypercube := hypercubes:user-defined-hypercube({
  "xbrl:Concept" : {
    "Domain" : [ "us-gaap:DividendsCommonStock" ]
  },
  "us-gaap:StatementEquityComponentsAxis" : {
    "Domain" : [ "us-gaap:CommonStockMember" ]
  }
}
return count(sec:facts-for-hypercube($hypercube))
