import module namespace companies = "http://xbrl.io/modules/bizql/profiles/sec/companies";
import module namespace request = "http://www.28msec.com/modules/http/request";

let $tickers := request:parameter-values("t")
return companies:companies-for-tickers($tickers)