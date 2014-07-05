#Filings
In the former chapter, we explained how to deal with companies. We now go into the details of the filings that these companies submitted to the SEC.

Physically, companies submit XBRL instances, possibly together with an extension taxonomy.

The XBRL connector abstracts from this by grouping the instance and the DTS (us-gaap taxonomy + extension) into what is called an archive.

The XBRL connector provides two modules for working with filings. One of them is generic, the other one offers functionality that is specific to the SEC. In this case:
```jsoniq
http://xbrl.io/modules/bizql/archives
http://xbrl.io/modules/bizql/profiles/sec/filings```


##Looking Up Filings
Let us begin with a very simple query that just lists the SEC filings. It is generic, so it uses the archives module:


 Example - All filings

```jsoniq
import module namespace archives =
    "http://xbrl.io/modules/bizql/archives";
archives:archives()```
In the XBRL connector, a filing is represented by a JSON object, like so (in this case, Coca Cola's report for Q1 2013):


 Example - A filing in JSON format

```jsoniq
{
  "_id" : "0000021344-13-000017", 
  "Entity" : "http://www.sec.gov/CIK 0000021344", 
  "InstanceURL" : "http://www.sec.gov/Archives/edgar/data/21344/
000002134413000017/ko-20130329.xml", 
  "Profiles" : {
    "SEC" : {
      "Name" : "SEC", 
      "FormType" : "10-Q", 
      "FilingDate" : "04/25/2013", 
      "FileNumber" : "001-02217", 
      "AcceptanceDatetime" : "20130425115725", 
      "Period" : "20130329", 
      "AssistantDirector" : "9", 
      "SECFilingPage" : "http://www.sec.gov/Archives/edgar/data/
21344/000002134413000017/0000021344-13-000017-index.htm", 
      "DocumentPeriodEndDate" : "2013-03-29", 
      "Fiscal" : {
        "DocumentFiscalPeriodFocus" : "Q1", 
        "DocumentFiscalYearFocus" : 2013
      }, 
      "Generator" : "WebFilings"
    }
  }, 
  "Namespaces" : {
    "link" : "http://www.xbrl.org/2003/linkbase", 
    "ko" : "http://www.thecoca-colacompany.com/20130329", 
    "xbrli" : "http://www.xbrl.org/2003/instance", 
    "xs" : "http://www.w3.org/2001/XMLSchema", 
    "us-gaap" : "http://fasb.org/us-gaap/2012-01-31", 
    "nonnum" : "http://www.xbrl.org/dtr/type/non-numeric", 
    "xbrldt" : "http://xbrl.org/2005/xbrldt", 
    "num" : "http://www.xbrl.org/dtr/type/numeric", 
    "dei" : "http://xbrl.sec.gov/dei/2012-01-31", 
    "iso4217" : "http://www.xbrl.org/2003/iso4217"
  }, 
  "Statistics" : {
    "NumHypercubes" : 25, 
    "NumNetworks" : 86, 
    "NumDistinctExplicitDimensions" : 21, 
    "NumDistinctDomains" : 22, 
    "NumDistinctMembers" : 93, 
    "NumDistinctConcretePrimaryItemsInHypercubes" : 244, 
    "NumDistinctAbstractPrimaryItemsInHypercubes" : 58, 
    "NumDistinctConcretePrimaryItemsNotInHypercubes" : 60, 
    "NumDistinctAbstractPrimaryItemsNotInHypercubes" : 160, 
    "Profiles" : {
      "SEC" : {
        "Name" : "SEC", 
        "NumExtensionConcepts" : 73, 
        "NumExtensionAbstracts" : 80, 
        "NumDistinctReportElementNamesEndingWithTable" : 17, 
        "NumDistinctReportElementNamesEndingWithAxis" : 21, 
        "NumDistinctReportElementNamesEndingWithDomain" : 22, 
        "NumDistinctReportElementNamesEndingWithMember" : 71, 
        "NumDistinctReportElementNamesEndingWithLineItems" : 19, 
        "NumDistinctReportElementNamesEndingWithAbstract" : 53, 
        "NumDistinctReportElementNamesEndingWithAnythingElse" : 
319, 
        "NumExtensionFacts" : 217
      }
    }, 
    "NumFacts" : 990, 
    "NumFootnotes" : 1, 
    "NumComponents" : 53
  }
}```
Some of the information in here is not specific to the SEC: the reporting entity, the URL to the physical XBRL instance, the namespaces to which prefixes (used in facts) correspond, and some statistics (number of facts, of hypercubes, etc).

Just like companies, filing objects also have SEC-specific information that is embedded in a Profiles.SEC subobject. It contains, for example, the SEC form type, the filing date, the reported fiscal period, etc. There are also SEC-specific statistics.

You can ask the filings submitted by a given company with the `filings:filings-for-companies` function:


 Example - American Express's filings

```jsoniq
import module namespace companies =
    "http://xbrl.io/modules/bizql/profiles/sec/companies";
import module namespace filings =
    "http://xbrl.io/modules/bizql/profiles/sec/filings";

let $amex := companies:companies(4962)
return filings:filings-for-companies($amex)```
As always, any sequence is accepted as input:


 Example - All filings by American Express and Walt Disney

```jsoniq
import module namespace companies =
    "http://xbrl.io/modules/bizql/profiles/sec/companies";
import module namespace filings =
    "http://xbrl.io/modules/bizql/profiles/sec/filings";

let $amex := companies:companies(4962)
let $disney := companies:companies(1001039)
return filings:filings-for-companies( ($amex, $disney) )```
For convenience, you can always pass a CIK instead of the company object, which greatly simplifies the query. This applies to all functions taking a sequence of companies as a parameter.


 Example - Filings by Amex and Disney in a single call

```jsoniq
import module namespace filings =
    "http://xbrl.io/modules/bizql/profiles/sec/filings";

filings:filings-for-companies( (4962, 1001039) )```
If you are looking for a specific fiscal period or year, the fiscal module can help.


 Example - Filings by Amex and Disney, FY 2011 and FY 2012

```jsoniq
import module namespace fiscal =
    "http://xbrl.io/modules/bizql/profiles/sec/fiscal/core";

fiscal:filings-for-entities-and-fiscal-periods-and-years(
    (4962, 1001039),
    "FY",
    (2011, 2012)
)```
##Diving into a filing
Once you have one or more filing objects, you can query them. There are two main ways to do it:


1. Using JSONiq navigation (with dots and square brackets). Using functions.For example, if you would like to use the statistics to count the facts in FY 2011 and 2012 filings by Apple and Google:


```jsoniq
import module namespace fiscal =
    "http://xbrl.io/modules/bizql/profiles/sec/fiscal/core";

let $filings :=
  fiscal:filings-for-entities-and-fiscal-periods-and-years(
      (4962, 1001039),
      "FY",
      (2011, 2012) )
return sum($filings.Statistics.NumFacts)
```


Some of the fields are available, for convenience, with functions (in this case, the archive ID as well as the fiscal period and year):


 Example - Discover Amex's filings by fiscal year and period

```jsoniq
import module namespace archives =
    "http://xbrl.io/modules/bizql/archives";

import module namespace companies =
    "http://xbrl.io/modules/bizql/profiles/sec/companies";
import module namespace filings =
    "http://xbrl.io/modules/bizql/profiles/sec/filings";

import module namespace fiscal =
    "http://xbrl.io/modules/bizql/profiles/sec/fiscal/core";

let $amex := companies:companies(4962)
for $filing in filings:filings-for-companies($amex)
return {
  AID: archives:aid($filing),
  Period: fiscal:fiscal-period($filing),
  Year: fiscal:fiscal-year($filing)
}
```
##The SECXBRL.info REST API for filings
We also provide a REST API that allows you to look up filings and, say, import them into an Excel spreadsheet. The API is documentedhere

###Retrieve a filing
You can retrieve a filing given the CIKs of (one or several) companies with the `cik` parameter like so:

 [http://secxbrl.xbrl.io/api/filings.jq?cik=320193&cik=1288776](http://secxbrl.xbrl.io/api/filings.jq?cik=320193&cik=1288776)

If you do not know the CIK of the company you are looking for, you can also use the `tag` or `ticker` parameter like in the entities API. Or you can use the entities REST API, explained in the former chapter.

You can retrieve specify a fiscal period or year with the `fiscalPeriod` and `fiscalYear` parameters like so:

 [http://secxbrl.xbrl.io/api/filings.jq?cik=320193&fiscalYear=2012&fiscalPeriod=Q1&fiscalPeriod=Q2](http://secxbrl.xbrl.io/api/filings.jq?cik=320193&fiscalYear=2012&fiscalPeriod=Q1&fiscalPeriod=Q2)

You can use fiscalYear=LATEST to retrieve the latest year.

###Select a format
You can also choose the format in which you would like to retrieve filing information, like in the entities API.

For example, for Excel:

 [http://secxbrl.xbrl.io/api/filings.jq?cik=320193&cik=1288776&format=csv](http://secxbrl.xbrl.io/api/filings.jq?cik=320193&cik=1288776&format=csv)

