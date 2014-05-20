
  #Report schemas
  For convenience, there are report schemas which provide convenient querying hypercubes, and more.

  By default, your project contains no report schema. In this tutorial, we provide one that you can download
    under http://facs.28.io/process-report-schema.jq. JSONiq is powerful enough to do this for you with
    just one click (to 28.io, the Web is nothing but yet another data source...).

  
 Example - Download the report schema with the Fundamental Accounting Concepts.

    
    
```jsoniq
```

  
  (Yes, JSONiq can do updates and side effects, but, ssssshhhh! don't tell anybody we showed you that).

  
    ##Fundamental Accounting Concepts
    Querying across multiple filings, even across companies, is not easy. This is because companies might not report their data in the same way.
The Fundamental Accounting Concepts report schema provides an easy way to do so.

    The report schema module is named [http://xbrl.io/modules/bizql/report-schemas](http://xbrl.io/modules/bizql/report-schemas)

    
 Example - Asking for the FAC report schema

      
      
```jsoniq
import module namespace report-schemas =
    "http://xbrl.io/modules/bizql/report-schemas";

report-schemas:report-schemas("FundamentalAccountingConcepts")
```

    
    A report schema looks very much like a network, except that it is not bound to any filing. In particular, it also has a model structure.

    
 Example - Asking for the FAC report schema

      
      
```jsoniq
import module namespace report-schemas = "http://xbrl.io/modules/bizql/report-schemas";
import module namespace sec-networks =
    "http://xbrl.io/modules/bizql/profiles/sec/networks";

let $schema := report-schemas:report-schemas("FundamentalAccountingConcepts")
return sec-networks:model-structures($schema)
```

    
    But they have more than that. They may define their own concepts (beginning with the fac: prefix) and map them to real concepts with a so-called
concept map.

    
 Example - Asking for American Express's assets with the mapped fac:Assets concept

      
      
```jsoniq
import module namespace hypercubes =
    "http://xbrl.io/modules/bizql/hypercubes";
import module namespace sec =
    "http://xbrl.io/modules/bizql/profiles/sec/core";
import module namespace fiscal =
    "http://xbrl.io/modules/bizql/profiles/sec/fiscal/core";

let $hypercube := hypercubes:dimensionless-hypercube()
let $filing := fiscal:filings-for-entities-and-fiscal-periods-and-years(
    4962,
    "FY",
    2012
)
return sec:facts-for-archives-and-concepts(
    $filing,
    "fac:Assets",
    {
        Hypercube: $hypercube,
        concept-maps: "FundamentalAccountingConcepts"
    }
)

```

    
    For convenience, if you directly would like to retrieve all facts for a schema, you can use sec:facts-for-schema with the name of the
      desired schema, and the archive for which you would like the facts.

    
 Example - Asking for Amex' FACs

      
      
```jsoniq
import module namespace sec =
    "http://xbrl.io/modules/bizql/profiles/sec/core";
import module namespace fiscal =
    "http://xbrl.io/modules/bizql/profiles/sec/fiscal/core";

let $filing :=
    fiscal:filings-for-entities-and-fiscal-periods-and-years(
      4962,
      "FY",
      2012 )
return sec:facts-for-schema(
    "FundamentalAccountingConcepts",
    $filing
)
```

    
    You can also ask for them across several archives.

    
 Example - Asking for the FACs of Amex and Disney

      
      
```jsoniq
import module namespace sec =
    "http://xbrl.io/modules/bizql/profiles/sec/core";
import module namespace fiscal =
    "http://xbrl.io/modules/bizql/profiles/sec/fiscal/core";

let $filing :=
    fiscal:filings-for-entities-and-fiscal-periods-and-years(
      (4962, 1001039),
      "FY",
      2012 )
return sec:facts-for-schema(
    "FundamentalAccountingConcepts",
    $filing
)
```

    
  
  
    ##The SECXBRL.info REST API for concept maps
    We also provide a REST API that allows you to look up mapped concepts and, say, import them into an Excel
      spreadsheet. The API is documented here

    
      ###Retrieve a fact with a concept map
      You can use a concept map with the facts API using the map parameter, together with the name of the containing report schema, like so:
      

      [http://secxbrl.xbrl.io/api/facts.jq?concept=fac:Assets](http://secxbrl.xbrl.io/api/facts.jq?concept=fac:Assets)
        [&tag=DOW30&map=FundamentalAccountingConcepts](&tag=DOW30&map=FundamentalAccountingConcepts)

    
  
