#Fact tables

When you have a network, you can ask for all facts that it contains. This is called a fact table.


Once you have your hands on a network, it's very easy to ask for the fact table, with the sec-networks:facts() function.

##Facts

XBRL is about reporting facts. A fact is a reporting atom, meaning that it's the smallest chunk that can be reported. For example, a fact can be that Apricot Inc. owns 30 billion dollars in assets on december 31st, 2012, that a HAL stock was worth 31.41$ on this day, or that Mr. Sugarmountain lived in Palo Alto between 2004 and 2012.


A fact has a certain number of properties:


    *
A value: the meat of the fact. It can a string, a number, etc.

    *
A concept: it's*what*this fact is about. For example: assets, or revenues, etc.

    *
A unit: it's*of what*if it is a number (example: USD/share for a dividend, etc)

    *
An entity: it's*who*reported this fact. For example, Apricot Inc.

    *
A period: it's*when*this fact applies. A period can be an instance (like May 4th, 2013) or a duration (January 1st thru December 31st, 2013).

    *
A number of further characterizing dimensions, such as a region of the world, a company department, etc.



##Looking up a fact table for an SEC network

As we said earlier, facts are not alone: in the wild, they live in tables. Let us get back to the balance sheet of Coca Cola for FY 2012, and ask for the fact table.


 Example - The fact table for a balance sheet by Coca Cola

```jsoniq
import module namespace fiscal =
    "http://xbrl.io/modules/bizql/profiles/sec/fiscal/core";
import module namespace sec-networks =
    "http://xbrl.io/modules/bizql/profiles/sec/networks";

let $filing :=
    fiscal:filings-for-entities-and-fiscal-periods-and-years(
      21344,
      "FY",
      2012
    )
let $network :=
    sec-networks:networks-for-filings-and-disclosures(
      $filing,
      $sec-networks:BALANCE_SHEET
    )
return sec-networks:facts($network)
```

Below is an example of fact.


 Example - The fact object format

```jsoniq
{
  "Archive" : "0000021344-13-000007", 
  "_id" : "68a552aa-ff68-4fb0-be34-c4507b1fbc00", 
  "IsInDefaultHypercube" : true, 
  "Aspects" : {
    "xbrl:Concept" : "ko:AvailableForSaleSecuritiesAndCostMethod
Investments", 
    "xbrl:Entity" : "http://www.sec.gov/CIK 0000021344", 
    "xbrl:Period" : "2012-12-31", 
    "xbrl:Unit" : "iso4217:USD", 
    "us-gaap:StatementScenarioAxis" : "us-gaap:ScenarioUnspecifi
edDomain"
  }, 
  "Profiles" : {
    "SEC" : {
      "Name" : "SEC", 
      "Fiscal" : {
        "Period" : "FY", 
        "Year" : 2012
      }, 
      "DocEndDate" : "2012-12-31", 
      "Accepted" : "20130227122203", 
      "IsExtension" : true
    }
  }, 
  "Type" : "NumericValue", 
  "Value" : 1232000000, 
  "Decimals" : -6, 
  "AuditTrails" : [ {
    "Data" : {
      "Dimension" : "us-gaap:StatementScenarioAxis", 
      "Member" : "us-gaap:ScenarioUnspecifiedDomain"
    }, 
    "Type" : "hypercubes:dimension-default", 
    "Label" : "Default dimension value"
    }
  ]
}
```

Note the Profiles.SEC section which also exists for facts, like companies, filings and networks. This section mostly contains the fiscal period and year against which the yearly or quaterly report was reported, as well as the end date of the report, the acceptance date by SEC, and a boolean that indicates whether the concept exists for all companies (often prefixed with us-gaap:), or was made up by the company reporting this fact.


The fact also contains an audit trail, that we will detail more in the hypercube section.

##The SECXBRL.info REST API for fact tables

We also provide a REST API that allows you to look up fact tables and, say, import them into an Excel spreadsheet. The API is documentedhere

###Retrieve the fact table associated with a network

You can retrieve the fact table of a components using thecidparameter.


[http://secxbrl.xbrl.io/api/facttable-for-component.jq?cid=66887390-ee56-44a7-a897-62eefe944476](http://secxbrl.xbrl.io/api/facttable-for-component.jq?cid=66887390-ee56-44a7-a897-62eefe944476)


You can also use the parameters from the components API: For example, the fact table for Coca Cola's balance sheet for FY 2012 can be retrieved with


[http://secxbrl.xbrl.io/api/facttable-for-component.jq?](http://secxbrl.xbrl.io/api/facttable-for-component.jq?)[_method=POST&format=xml&cik=21344&fiscalYear=2012](_method=POST&format=xml&cik=21344&fiscalYear=2012)[&fiscalPeriod=FY&disclosure=BalanceSheet](&fiscalPeriod=FY&disclosure=BalanceSheet)


The format parameter is also available as usual.

