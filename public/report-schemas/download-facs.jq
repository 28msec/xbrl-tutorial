import module namespace http-client =
    "http://zorba.io/modules/http-client";

let $schema := parse-json(http-client:get-text(
    "http://facs.28.io/process-report-schema.jq"
).body.content)
return
if(is-available-collection("reportschemas"))
then {
    truncate("reportschemas");
    insert("reportschemas", $schema);
}
else
    create("reportschemas", $schema);

"Schema successfully added."
