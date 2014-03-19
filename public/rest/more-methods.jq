import module namespace companies =
    "http://xbrl.io/modules/bizql/profiles/sec/companies";
import module namespace request =
    "http://www.28msec.com/modules/http-request";
import module namespace response =
    "http://www.28msec.com/modules/http-response";

let $tickers := request:param-values("t")
return switch(true)
case request:method-post() and exists($tickers)
return {
  response:content-type("application/json");
  companies:companies-for-tickers($tickers)
}
case request:method-post() and empty($tickers)
return {
  response:status-code(404);
  ()
}
default return {
  response:content-type("text/plain");
  "Method not supported."
}