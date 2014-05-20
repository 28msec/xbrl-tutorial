declare namespace xi = "http://www.w3.org/2001/XInclude";

declare variable $base := "tutorial/en-US/";

declare function local:expand($book as element(book)) as element(book) {
   copy $expanded := $book
   modify for $include in $book//xi:include
          return replace node $include with doc($base || $include/@href)/*
   return $book
};

let $book := doc($base || "SECTutorial.xml")/book
let $book := local:expand($book)
return $book 
