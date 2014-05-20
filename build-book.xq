xquery version "3.0";

import module namespace file = "http://expath.org/ns/file";

declare namespace xi = "http://www.w3.org/2001/XInclude";
declare namespace an = "http://zorba.io/annotations";

declare variable $base := "tutorial/en-US/";

declare function local:expand($book as element()) as element() {
   copy $expanded := $book
   modify for $include in $expanded//xi:include
          return replace node $include with if(ends-with($include/@href, ".xml")) then
                                                local:expand(doc($base || $include/@href)/*)
                                            else
                                                <programlisting>{{unparsed-text($base || $include/@href)}}</programlisting>
   return $expanded
};

declare %an:sequential function local:build-summary($book as element(book)) as empty-sequence() {
    let $text := "#" || $book/bookinfo/title/text() || "

" || string-join(for $chapter in $book/chapter return "* [" || $chapter/title/text() || "](gitbook/" || $chapter/@id || ".md)", "
")
    return file:write-text("SUMMARY.md", $text);
};

declare %an:sequential function local:build-chapter($chapter as element(chapter)) as empty-sequence() {
    let $text := local:docbook-to-markdown($chapter) 
    return file:write-text("gitbook/" || $chapter/@id || ".md", $text)
};

declare function local:docbook-to-markdown($element as element()) as xs:string {
    string-join(local:docbook-to-markdown($element, 1), "")
};

declare function local:docbook-to-markdown($element as node(), $level as xs:integer) as xs:string* {
   typeswitch($element)
   case element(title) return string-join((1 to $level) ! "#", "") || $element/text() || "
"
   case element(emphasis) return " *" || string-join(for $child in $element/node() return local:docbook-to-markdown($child, $level), "") || "* "
   case element(uri) return " [" || $element/text() || "](" || $element/text() || ")"
   case element(section) return for $child in $element/node() return local:docbook-to-markdown($child, $level + 1)
   case element(inlinegraphic) return "![" || $element/@fileref || "](../tutorial/en-US/" || $element/@fileref || ")"
   case element(orderedlist) return for $item in $element/listitem return string-join(((1 to ($level - 1)) ! "    "), "") || "-" || string-join(for $child in $item/node() return local:docbook-to-markdown($child, $level + 1), "")
   case element(itemizedlist) return for $item in $element/listitem return string-join(((1 to ($level - 1)) ! "    "), "") || "*" || string-join(for $child in $item/node() return local:docbook-to-markdown($child, $level + 1), "")
   case element(example) return "
 Example - " || $element/title/text() || "
" || string-join(for $child in $element/node()[local-name(.) != 'title'] return local:docbook-to-markdown($child, $level), "")
   case element(programlisting) return "
```jsoniq
" || $element/text() || "```
"
   case text() return normalize-space(string($element))
   case element(para) return string-join(for $child in $element/node() return local:docbook-to-markdown($child, $level), "") || "

"
   default return string-join(for $child in $element/node() return local:docbook-to-markdown($child, $level), "")
};

let $book := doc($base || "SECTutorial.xml")/book
let $book := local:expand($book)
return {
    local:build-summary($book);
    for $chapter in $book/chapter
    return local:build-chapter($chapter);
    $book
}
