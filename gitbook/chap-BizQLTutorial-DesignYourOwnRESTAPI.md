
  #Design Your Own REST API
  If the above REST API does not cover your needs, you can design your own REST API.

  
    ##Getting the parameters from the query string
    We now explain how to do a simple API for just retrieve a company with its ticker.

    The first thing you need to know is that, whenever you write a public query, its results becomes available through a REST call.

    [http://project-name.xbrl.io/my-query.jq](http://project-name.xbrl.io/my-query.jq)


    For example, you can call the query returning all entities with the following URI:

    [http://project-name.xbrl.io/companies/all.jq](http://project-name.xbrl.io/companies/all.jq)


    For more elaborate queries though, the following endpoint is better suited:

    [http://project-name.xbrl.io/v1/_queries/public/companies/all.jq](http://project-name.xbrl.io/v1/_queries/public/companies/all.jq)


    However, it is more strict, meaning that it will complain if the query has side effects and if the method is GET -- you have to use POST for side-effecting queries.

    Finally, this more elaborate endpoint is stricter about types, meaning, you need to use a function to declare the type of what the query returns.

    For the sake of simplicity, we use the simpler endpoint in ths rest of this chapter.

  

  
    ##Useful functions
    You will need to read parameters from the query string.
      There is a function named parameter-values, which lives in the http://www.28msec.com/modules/http-request namespace.
      It takes a parameter name, and returns the sequence of all its values (it may have several if it appears several times in the request URL).

    
 Example - Read a parameter's value(s) from the query string

      
      
```jsoniq
import module namespace companies =
    "http://xbrl.io/modules/bizql/profiles/sec/companies";
import module namespace request =
    "http://www.28msec.com/modules/http/request";

let $tickers := request:parameter-values("t")
return companies:companies-for-tickers($tickers)```

    
    Here is a possible way to invoke this query via the REST API:

    GET [http://project-name.xbrl.io/rest-api/query-string-parameter.jq?t=wmt&t=GOOG](http://project-name.xbrl.io/rest-api/query-string-parameter.jq?t=wmt&t=GOOG)

    There are a few more useful functions. For example, request:method-get(), method-post(), etc, return a boolean and allow
you to know which method the consumer used.

    Until now, we used the request module. Likewise, there is a response module http://www.28msec.com/modules/http-response,
 with which you can tune the output (HTTP code, MIME type, etc).

    
 Example - Read a parameter's value(s) from the query string

      
      
```jsoniq
import module namespace companies =
    "http://xbrl.io/modules/bizql/profiles/sec/companies";
import module namespace request =
    "http://www.28msec.com/modules/http-request";
import module namespace response =
    "http://www.28msec.com/modules/http-response";

let $tickers := request:param-values("t")
return switch(true)
        case request:method-get() and exists($tickers)
        return {
          response:content-type("application/json");
          companies:companies-for-tickers($tickers)
        }
        case request:method-get() and empty($tickers)
        return {
          response:status-code(404);
          ()
        }
        default return {
          response:content-type("text/plain");
          "Method not supported."
        }
```

    
    The above query reacts on the method and on whether companies are found to demonstrate a few of the available features:

        *
        If the method is GET and facts are found, it returns them as JSON.
      
        GET [http://project-name.xbrl.io/rest/more-methods.jq?t=wmt&t=GOOG](http://project-name.xbrl.io/rest/more-methods.jq?t=wmt&t=GOOG)

          *
        If the method is GET and no facts are found, it returns a 404 NOT FOUND.
      
        GET [http://project-name.xbrl.io/rest/more-methods.jq?t=dummy](http://project-name.xbrl.io/rest/more-methods.jq?t=dummy)

          *
        If the method is different, it returns a message in plain text.
      
        DELETE [http://project-name.xbrl.io/rest/more-methods.jq?t=wmt&t=GOOG](http://project-name.xbrl.io/rest/more-methods.jq?t=wmt&t=GOOG)

      
  
  
    ##That's it for now!
    With these building blocks, and together with the 28.io platform and modules documentation, you are all set! Do not hesitate to ask questions
on our Zendesk support platform. We'll be very happy to assist you.

  
