#Networks

A filing contains a lot of information. It makes sense to split this information in smaller components. For example a quarterly report has a balanced sheet, an income statement, some generic information about the filing, etc. In the SEC world, these are called *networks* .


Physically, companies submit XBRL instances, possibly together with an extension taxonomy.


The XBRL connector provides two modules for working with SEC networks. One of them is generic, the other one offers functionality that is specific to the SEC. In this case:
```jsoniq
http://xbrl.io/modules/bizql/components
http://xbrl.io/modules/bizql/profiles/sec/networks```



However, the networks module is the most useful for working with SEC data, because of all the specificities of Edgar filings.

##Looking Up Networks

Let us begin with a very simple query that just lists the SEC networks contained in a filing, say, Coca Cola's Q1 for 2012.


 Example - The various components in Coca Cola's Q1 2012 filing.

```jsoniq
import module namespace fiscal =
    "http://xbrl.io/modules/bizql/profiles/sec/fiscal/core";
import module namespace sec-networks =
    "http://xbrl.io/modules/bizql/profiles/sec/networks";

let $filing :=
    fiscal:filings-for-entities-and-fiscal-periods-and-years(
      21344,
      "Q1",
      2012
    )
return sec-networks:networks-for-filings($filing)```

In the XBRL connector, a network is represented by a JSON object. This object contains complex XBRL machinery to deal with factual structures (XBRL hypercubes, presentation networks, etc). Normally, you do not need to look into it, apart maybe from the statistics section that is similar to those of filings.


A much more useful, SEC-specific representation of the network is called the model structure and we explain later how to access it.


A certain number of networks are common to all filings, and stamped with a disclosure. Here is, for example, how to retrieve the balance sheet in the above filing.



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
return sec-networks:networks-for-filings-and-disclosures(
    $filing,
    $sec-networks:BALANCE_SHEET
)
```



Other examples of available disclosures include the balance sheet, the income statement, the cash flow statement, document and entity information.

##The Model Structure


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
let $balance-sheet := sec-networks:networks-for-filings-and-disclosures(
    $filing,
    $sec-networks:BALANCE_SHEET
)
return sec-networks:model-structures($balance-sheet)
```



A model structure is just a hierarchy of so-called *SEC report elements* of different kinds. In that case:



```jsoniq
{
  "Kind" : "Abstract", 
  "Name" : "us-gaap:StatementOfFinancialPositionAbstract", 
  "Label" : "Statement of Financial Position [Abstract]", 
  "Children" : [ {
    "Kind" : "Table", 
    "Name" : "us-gaap:StatementTable", 
    "Label" : "Statement [Table]", 
    "Children" : [ {
      "Kind" : "LineItems", 
      "Name" : "us-gaap:StatementLineItems", 
      "Label" : "Statement [Line Items]", 
      "Children" : [ {
        "Kind" : "Abstract", 
        "Name" : "us-gaap:AssetsAbstract", 
        "Label" : "Assets [Abstract]", 
        "Children" : [ {
          "Kind" : "Concept", 
          "Name" : "us-gaap:Assets", 
          "Label" : "Assets", 
          "IsNillable" : true, 
          "IsAbstract" : false, 
          "PeriodType" : "instant", 
          "Balance" : "debit", 
          "SubstitutionGroup" : "xbrli:item", 
          "DataType" : "xbrli:monetaryItemType", 
          "BaseType" : "xbrli:monetary", 
          "ClosestSchemaBuiltinType" : "xs:decimal", 
          "IsTextBlock" : false
        }, ... ]
      }, ... ]
    }, {
      "Kind" : "Axis", 
      "Name" : "us-gaap:StatementScenarioAxis", 
      "Label" : "Scenario [Axis]", 
      "Children" : [ {
        "Kind" : "Member", 
        "Name" : "us-gaap:ScenarioUnspecifiedDomain", 
        "Label" : "Scenario, Unspecified [Domain]"
      } ]
    } ]
  } ]
}```



Here is a list of all reports elements (which form the model structure) used by SEC:

##Report elements
Report ElementWhat it isTableThis is a "container" for all facts in this component. While it is called table, *hypercube* would be a more precise terminology because it can have much more than two dimensions.LineItemsThis is the top-level element for the "rows" of the table.AbstractThese are virtual rows, i.e., no facts are reported against them. They help organize concepts.ConceptThese are rows against which facts get reported.AxisSeveral facts can be reported for the same concept, but in different contexts. Axes help organize this. For example, an axis can be used to delimit a region of the world to which the fact applies.MemberA member is an axis value. Members can be organized in hierarchies as well (which is easy to understand if you think of regions of the world for example).##The SECXBRL.info REST API for networks

We also provide a REST API that allows you to look up networks and, say, import them into an Excel spreadsheet. The API is documentedhere

###Retrieve a network

You can retrieve the networks (components) in a filing using theaidparameter, like so:


 [http://secxbrl.xbrl.io/api/components.jq?aid=0000021344-13-000017](http://secxbrl.xbrl.io/api/components.jq?aid=0000021344-13-000017)


If you do not know the AIDs of the filings, you can use the same parameters as in the filings API (cik,tag,ticker,fiscalYear,fiscalPeriod), or use the filings REST API to retrieve it.

###Select a format

You can also choose the format in which you would like to retrieve network information, like in the entities and filings APIs.


For example, for Excel:


 [http://secxbrl.xbrl.io/api/components.jq?aid=0000021344-13-000017&format=csv](http://secxbrl.xbrl.io/api/components.jq?aid=0000021344-13-000017&format=csv)

