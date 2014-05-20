#Hypercube Querying

In the former section, we showed how to get the fact table associated with an SEC network. You may have seen at several place occurrences of the word "Hypercube". The facts in an SEC network are actually organized in a hypercubic structure. We now go more into detais on this, and eventually show how you can build your own hypercubes and query for fact tables, outside of any SEC network.

##Hypercubes

Concepts, entities, periods, units, as well as further dimensions are called`aspects`. It is possible to organize facts along`hypercubes`, the dimensions of which are these aspects. Usually, there will be either zero or one fact for each possible tuple of aspects. If there is more, it often indicates an inconsistency in the submission.


For example, if we stick to the USD unit, you can imagine a cube whose width represents concepts (Assets, Revenues), the height of which represents entities (Amex, Disney) and the depth of which represents periods (year 2012, year 2013, year 2014). This hypercube potentially contains 2 x 2 x 3 = 12 facts.


Note: From a practical perspective, it is disputed whether units are considered aspects, or whether they "stick" to the value.

##Building your own hypercube

The simplest hypercube you can imagine is made of four "standard" aspects: concept, entity, period and unit. It does not restrict the value of any of these aspects. It is called dimensionless, because in the XBRL universe, the four basic aspects are not considered XBRL dimensions.


 Example - The dimensionless hypercube

```jsoniq
```

The result of this query shows you the object representation of a hypercube.


 Example - The object format of hypercubes

```jsoniq
{
  "Name" : "xbrl:DimensionlessHypercube", 
  "Label" : "Dimensionless Hypercube", 
  "Aspects" : {
    "xbrl:Concept" : {
      "Name" : "xbrl:Concept", 
      "Label" : "Implicit XBRL Concept Dimension"
    }, 
    "xbrl:Period" : {
      "Name" : "xbrl:Period", 
      "Label" : "Implicit XBRL Period Dimension"
    }, 
    "xbrl:Entity" : {
      "Name" : "xbrl:Entity", 
      "Label" : "Implicit XBRL Entity Dimension"
    }, 
    "xbrl:Unit" : {
      "Name" : "xbrl:Unit", 
      "Label" : "Implicit XBRL Unit Dimension", 
      "Default" : "xbrl:NonNumeric"
    }
  }
}```

The facts in a hypercube can be queried with the functionsec:facts-for-hypercube. There is a very high number of facts in this hypercube: all those without extra dimensions. Hundreds of thousands of them. Very often, when you query for facts against this dimensionless hypercube, you are asking for specifing archives. The function sec:facts-for-hypercube allows you to do so with its optional second parameter (the first being the hypercube).


Let's count all those facts that are in a given archive (here 1423).


 Example - Retrieving the facts in the dimensionless hypercube for some filings

```jsoniq
```

Instead of looking at a single archive, you can look across archives, for concepts likeus-gaap:Assetsandus-gaap:Equity. In order to do so, you need to modify the dimensionless hypercube add filter on these two concepts. There are over 70k such facts.


```jsoniq
```

You can also build your own hypercube. To restrict a dimension, just add a field (One ofConcepts,Entities,Periods,Units) with an array of values. Below we show you how to make a restriction on DOW30 companies with just a small modification of the dimensionless hypercube function call.


```jsoniq
```

If you begin to query across archives, and attempt to filter on periods, you will very soon notice that it is hard, because fiscal years differ from company to company. Technically, fiscal years and periods (FY, Q1, Q2, Q3) are not hypercube dimensions, but you can still filter for them using this Profiles.SEC.Fiscal part that annotates objects using the second parameter ofsec:facts-for-hypercube. For example, here is how to get all assets and equities (no extra dimensions) for FY 2012 (6847 of them)


```jsoniq
```

What was done for the basic four dimensions (like xbrl:Equity) applies to extra dimensions as well. There is a more elaborate version ofhypercubes:dimensionless-hypercubecalledhypercubes:user-defined-hypercubethat allows you to add any number of dimensions, as well as restrict on them or add default values. Here you can ask for facts reported against theus-gaap:DividendsCommonStockconcept, with a dimensionus-gaap:StatementEquityComponentsAxisrestricted on a value ofus-gaap:CommonStockMember. There are 513 of them.


```jsoniq
```

Finally, you can combine extra dimensions, restricting several dimensions, filtering on fiscal years, etc. Let's ask for the companies that submitted, for FY 2011, a fact against theus-gaap:DividendsCommonStockconcept, with a dimensionus-gaap:StatementEquityComponentsAxisthat has a value ofus-gaap:CommonStockMember. There's only one and it's Walt Disney. And it takes less than one second to ask for this.


```jsoniq
```

The SEC modules provide many functions that just wrap these queries in nicer code, and there are more to come. The documentation is there for you to find them.

##The SECXBRL.info REST API for user-defined hypercubes

We also provide a REST API that allows you to build your hypercubes and ask for fact tables and, say, import them into an Excel spreadsheet. The API is documentedhere

###Build your hypercube with the REST API

You can build your own hypercube by using dimension names as fields in the query string, along with one or several values. For example, "xbrl:Concept=us-gaap:Goodwill" will filter for concepts named us-gaap:Goodwill.


For the entity dimension, for convenience, you can use the same parameters as in the companies API: cik, ticker, tag, etc -- instead of "xbrl:Entity".


For the concept dimension, use the more convenient "concept" parameter name. For example:[http://secxbrl.xbrl.io/api/facts.jq?concept=us-gaap:Goodwill&cik=4962](http://secxbrl.xbrl.io/api/facts.jq?concept=us-gaap:Goodwill&cik=4962)


For requiring a dimension, without restriction, use a value of "ALL". For example:[http://secxbrl.xbrl.io/api/facts.jq?concept=us-gaap:DividendsCommonStock&tag=DOW30&us-gaap:StatementEquityComponentsAxis=ALL](http://secxbrl.xbrl.io/api/facts.jq?concept=us-gaap:DividendsCommonStock&tag=DOW30&us-gaap:StatementEquityComponentsAxis=ALL)


You can specify a default dimension value using "dimensionname:default", like so:[http://secxbrl.xbrl.io/api/facts.jq?concept=us-gaap:DividendsCommonStock&tag=DOW30&us-gaap:StatementEquityComponentsAxis=ALL&us-gaap:StatementEquityComponentsAxis:default=sec:myDefault](http://secxbrl.xbrl.io/api/facts.jq?concept=us-gaap:DividendsCommonStock&tag=DOW30&us-gaap:StatementEquityComponentsAxis=ALL&us-gaap:StatementEquityComponentsAxis:default=sec:myDefault)


The last query in the former section corresponds to[http://secxbrl.xbrl.io/api/facts.jq?concept=us-gaap:DividendsCommonStock&tag=DOW30&us-gaap:StatementEquityComponentsAxis=us-gaap:CommonStockMember&fiscalYear=2012&fiscalPeriod=FY](http://secxbrl.xbrl.io/api/facts.jq?concept=us-gaap:DividendsCommonStock&tag=DOW30&us-gaap:StatementEquityComponentsAxis=us-gaap:CommonStockMember&fiscalYear=2012&fiscalPeriod=FY)

