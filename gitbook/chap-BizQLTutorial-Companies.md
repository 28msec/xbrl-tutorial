#Companies

Companies submit filings to the SEC via the Edgar system.


In the XBRL world, companies correspond to reporting`entities.`


The XBRL connector provides two modules for working with companies. One of them is generic, the other one offers functionality that is specific to the SEC. Modules are identified with URIs (they look very much like Web site addresses), in this case:
```jsoniq
http://xbrl.io/modules/bizql/entities
http://xbrl.io/modules/bizql/profiles/sec/companies```


##Looking Up Companies

Let us begin with a very simple query that just lists the SEC companies. It is generic, so it uses the entities module:


 Example - All companies

```jsoniq
import module namespace entities =
    "http://xbrl.io/modules/bizql/entities";

entities:entities()```

This query is just a function call. A function is identified with its prefix (hereentities:) and a name (hereentities). This function takes no parameters.


In the XBRL connector, a company is represented by a JSON object, like so:


 Example - A company in JSON format

```jsoniq
{
  "_id" : "http://www.sec.gov/CIK 0000320193", 
  "Profiles" : {
    "SEC" : {
      "Name" : "SEC", 
      "CompanyName" : "APPLE INC", 
      "CompanyType" : "Corporation", 
      "CIK" : "0000320193", 
      "SIC" : "3571", 
      "SICDescription" : "ELECTRONIC COMPUTERS", 
      "SICGroup" : 3, 
      "Taxonomy" : "ci", 
      "Sector" : "Industrial/Commercial Machinery/Computer Equip
ment", 
      "Tickers" : [ "aapl" ], 
      "Tags" : [ "SP500", "FORTUNE100" ], 
      "IsTrust" : false
    }
  }
}```

In the case of companies, most of the information is SEC-specific, and is embedded in a Profiles.SEC subobject. You will see in other parts of the tutorial, that the Profiles.SEC subobject is not restricted to companies, but also applies to all other objects.


Companies can be retrieved by tags (for example, indices) using thecompanies-for-tagsfunction, in the companies module, like so:


 Example - All Dow 30 companies

```jsoniq
import module namespace companies =
    "http://xbrl.io/modules/bizql/profiles/sec/companies";

companies:companies-for-tags("DOW30")```

Almost all functions in the XBRL connector accept sequences as parameters. For example, you can get DOW30 and FORTUNE100 companies in a single call. Mind the double parenthesis: you are passing one single sequence as a parameter, not two strings as two parameters.


 Example - All Dow 30 and Fortune 100 companies (companies in both indices will be returned twice)

```jsoniq
import module namespace companies =
    "http://xbrl.io/modules/bizql/profiles/sec/companies";

companies:companies-for-tags( ("DOW30", "FORTUNE100") )```

Companies are identified with CIKs. A CIK can be used to retrieve a company


 Example - Walt Disney by CIK

```jsoniq
import module namespace companies =
    "http://xbrl.io/modules/bizql/profiles/sec/companies";

companies:companies(1001039)```

Here too, you can pass sequences.


 Example - American Express and Walt Disney by CIK

```jsoniq
import module namespace companies =
    "http://xbrl.io/modules/bizql/profiles/sec/companies";

companies:companies((4962, 1001039))```

Companies by SIC (electronic and other electrical equipment, semiconductors and related devices).


 Example - American Express and Walt Disney by CIK

```jsoniq
import module namespace companies =
    "http://xbrl.io/modules/bizql/profiles/sec/companies";

companies:companies-for-SIC(("3600", "3674"))```

 Example - Companies by sector (electronic)

```jsoniq
import module namespace companies =
    "http://xbrl.io/modules/bizql/profiles/sec/companies";

companies:companies-for-sector(
   "Electronic/Other Electrical Equipment/Components"
)```

 Example - JPMorgan and Walmart by ticker

```jsoniq
import module namespace companies =
    "http://xbrl.io/modules/bizql/profiles/sec/companies";

companies:companies-for-tickers(("jpm", "wmt"))```

Using FLWOR expressions, you can build many interesting queries just with companies. For example, this groups company names by sector, using the Sector and CompanyName fields in the SEC Profile.


 Example - All company names grouped by sector

```jsoniq
import module namespace entities =
    "http://xbrl.io/modules/bizql/entities";

for $e in entities:entities()
let $s := $e.Profiles.SEC.Sector
group by $s
return {
  sector : $s,
  entities : [ $e.Profiles.SEC.CompanyName ]
}```
##Querying Companies

In the former section, we showed how to query indices. But which indices are available? Even if there were no documentation, the answer lies at your fingertips.


One of the provided pieces of information for a company is the Tags field, which we use to stamp companies with indices. Using navigation syntax (the dot navigates deep into an object, double square brackets with an integer into an array, empty square brackets extract the entire array) as well as the distinct-values builtin function, it is very easy to discover, in real time, all indices currently used over the entire database:


 Example - Discovering all indices in half a second's time

```jsoniq
import module namespace entities =
    "http://xbrl.io/modules/bizql/entities";

distinct-values(entities:entities().Profiles.SEC.Tags[])```

Having done so, you will discover that the following indices are available.

##Available indices
IndexTagS&P 500SP500Dow 30DOW30Fortune 100FORTUNE100Providence Journal's Impact 50PJI##The SECXBRL.info REST API for companies

For people without developer background, we provide a REST API that allows you to look up companies and, say, import them into an Excel spreadsheet. The API is documentedhere

###Retrieve a company

You can retrieve:


        *
All companies with[http://secxbrl.xbrl.io/api/entities.jq](http://secxbrl.xbrl.io/api/entities.jq)

        *
One or several companies by CIK with thecikparameter, like so:


[http://secxbrl.xbrl.io/api/entities.jq?cik=1412090&cik=4962](http://secxbrl.xbrl.io/api/entities.jq?cik=1412090&cik=4962)

        *
Companies by (one or several) tag with thetagparameter, like so:


[http://secxbrl.xbrl.io/api/entities.jq?tag=DOW30](http://secxbrl.xbrl.io/api/entities.jq?tag=DOW30)

        *
One or several companies by ticker with thetickerparameter, like so:


[http://secxbrl.xbrl.io/api/entities.jq?ticker=AAPL&ticker=GOOG](http://secxbrl.xbrl.io/api/entities.jq?ticker=AAPL&ticker=GOOG)



###Select a format

You can choose the format in which you would like to retrieve company information. By default, JSON will be output.


        *
In JSON with thejsonparameter, like so:


[http://secxbrl.xbrl.io/api/entities.jq?tag=DOW30&format=json](http://secxbrl.xbrl.io/api/entities.jq?tag=DOW30&format=json)

        *
In XML with thexmlparameter, like so:


[http://secxbrl.xbrl.io/api/entities.jq?tag=DOW30&format=xml](http://secxbrl.xbrl.io/api/entities.jq?tag=DOW30&format=xml)

        *
In CSV (comma-separated values, which you can open in good old Excel) with thecsvparameter, like so:


[http://secxbrl.xbrl.io/api/entities.jq?tag=DOW30&format=csv](http://secxbrl.xbrl.io/api/entities.jq?tag=DOW30&format=csv)



