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
    },
    "us-gaap:StatementEquityComponentsAxis" : {
      "Name" : "us-gaap:StatementEquityComponentsAxis",
      "Domains" : { "us-gaap:CommonStockMember" : { Name: "us-gaap:CommonStockMember" } }
    }
  }
}
return count(sec:facts-for-archives-and-concepts((), ("us-gaap:DividendsCommonStock"), { Hypercube: $hypercube }))