(: code snippets to manually add/update an xbrl datasource
import module namespace credentials = "http://www.28msec.com/modules/credentials";

credentials:add-credentials("MongoDB", "xbrl", {
  "conn-string" : "",
  "db" : "",
  "user" : "",
  "pass" : ""
})

credentials:update-credentials("MongoDB", "xbrl", (), (), {
  "conn-string" : "",
  "db" : "",
  "user" : "",
  "pass" : ""
})

:)

()
