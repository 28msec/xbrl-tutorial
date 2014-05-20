import module namespace entities = "http://xbrl.io/modules/bizql/entities";

for $e in entities:entities()
let $s := $e.Profiles.SEC.Sector
group by $s
return {
    sector : $s,
    entities : [ $e.Profiles.SEC.CompanyName ]
 }