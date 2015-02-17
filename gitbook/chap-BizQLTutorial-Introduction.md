#Introduction
Just a few years ago, most companies were generating internal or external reports using text processors and spreadsheets. This was extremely inefficient and expensive: Excel and Word files were flowing from mailbox to mailbox, information was rekeyed on the fly, copied over, reorganized manually. In addition to the amount of time spent on these processes, this was very error-prone. For a few years now, the XBRL standard has been gaining importance, allowing reports to be made in a unified format. Some regulating authorities such as the SEC even made it mandatory.

In business life, standardization matters more than perfection. While XBRL is not perfect, it is now a standard, and it does a fine job doing what it was designed for.

While this is a cost-sinking revolution, it is also a revolution about access to information: using latest database technologies, XBRL reports can be made *queryable* . In particular, it is possible to *validate* that the reports do not contain a certain number of errors, to *impute* non-submitted information, but also to *derive* new information using data at an unprecedented scale (across potentially all XBRL reports in the world, and much beyond).

##State of the art
Many XBRL services providers store XBRL data in a relational database. However, very soon, the limits of homogeneous, flat tables are reached and slow down requests. Other services leverage the fact that the XBRL syntax is based on XML and store it, as is, in an XML database. Yet the raw XBRL format is not suitable for querying, or at least, for querying with reasonable performance: while XBRL uses the XML syntax, its data model is significantly different from that of XML, in at least the two following ways. If you leave tuples aside, there is nothing flatter than a physical fact. Networks that have no directed cycles (i.e., directed acyclic graphs, often even trees) can be stored in more optimal ways than raw XML.

##Cell stores
Cell stores are a new paradigm of databases. It is decoupled from XBRL and has a data model of its own, yet it natively support XBRL as a file format to exchange data between cell stores.
Traditional relational databases are focused on tables. Document stores are focused on trees. Triple stores are focused on graphs. Well, cell stores are focused on cells. Cells are units of data and also called facts, measures, etc. Think of taking an Excel spreadsheet and a pair of scissors, and of splitting the sheet into its cells. Put these cells in a bag. Pour some more cells that come from other spreadsheets. Many. Millions of cells. Billions of cells. Trillions of cells. You have a cell store.

Cell stores are very good at reconstructing tables in the presence of highly dimensional data. The idea behind this is based on hypercubes and is called NoLAP (NoSQL Online Analytical Processing). NoLAP extends the OLAP paradigm by removing hypercube rigidity and letting users generate their own hypercubes on the fly on the same pool of cells.

For business users, all of this is completely transparent and hidden. The look and feel of a cell store, in the end, is that of a spreadsheet like Excel. If you are familiar with the pivot table functionality of Excel, cell stores will be straightforward to understand. Also the underlying XBRL is hidden. I mean, seriously, how many of us have tried to unzip and open an Excel file with a text editor for any other reason than mere curiosity?

##The JSONiq language
JSONiq is the language used by 28msec's Virtual Database platform, 28.io. It is a NoSQL query language that deals with heterogeneous, arborescent data. It comes with a number of connectors that make it convenient to access, simultaneously, many data sources (MongoDB databases, traditional relational databases, S3 storage on Amazon, Graph Databases, Cloudant and many more) and combine them seamlessly to extract information. Cell stores were implemented 100% with JSONiq, and developers can also use JSONiq on 28.io. If they prefer to use a different language, they can also access the cell store via an agnostic REST API.

Business users do not need to learn anything about JSONiq (except, maybe, that it is a totally awesome language and that we love it) or REST (which is cool as well).

##Available repositories
We provide various repositories containing data from reporting authorities (SEC for various subsets of fiscal reports filed by American companies, FSA in Japan, Chile, ...). This tutorial will be based on SEC data, however the ideas are the same for any other kind of data. If you are interesting in setting up a repository with any other kind of data, do not hesitate and contact us. We are here for you at hello@28.io and would love to help.

##How to run the queries
All queries shown in this tutorial can be run directly on our platform. You are encouraged to register and get your own token. Private usage is free and we only bill for commercial use.

##Organization of the tutorial
XBRL is about submitting *facts* . Facts are reported by companies

In real life though, facts are not reported one by one, but are submitted to an authority like the SEC in *archives* . A bit like you don't buy pop corn one chunk at a time, but in a pop corn package. You can think of an archive as an Excel file.

An archive is made of facts, but also contains metainformation on these facts. This metainformation is called taxonomy, while the data part is called an instance. It contains, from an abstract perspective (we don't go into the low-level details of networks, etc):

1. Report elements. These are the building blocks for displaying a report in a fancy, spreadsheet-like front-end as well to nicely display the facts.
2. Components. They organize the report elements in a meaningful way. With components, it is possibly to know exactly what cells are relevant to the filing and how they are grouped. For example, a balance sheet can be a component, and an income statement another component. You can think of each component in a filing as an Excel sheet.
3. User-friendly labels for the concepts, to be able to display the data beautifully to business users and in the language they want.
4. Formulas, that can be used to either validate the reported facts (example: the assets match the equities and liabilities) or to compute new, non reported facts. Formulas are like Excel formulas.
