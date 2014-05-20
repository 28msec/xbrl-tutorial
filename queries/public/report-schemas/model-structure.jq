import module namespace report-schemas = "http://xbrl.io/modules/bizql/report-schemas";
import module namespace sec-networks = "http://xbrl.io/modules/bizql/profiles/sec/networks";

let $schema := report-schemas:report-schemas("FundamentalAccountingConcepts")
return sec-networks:model-structures($schema)