import module namespace fiscal = "http://xbrl.io/modules/bizql/profiles/sec/fiscal/core";

let $filings := fiscal:filings-for-entities-and-fiscal-periods-and-years( (320193, 1288776), "FY", (2011, 2012) )
return sum($filings.Statistics.NumFacts)