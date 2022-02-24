module.exports = function () {
  return `SELECT DISTINCT ?item ?itemLabel ?startDate ?endDate
               (STRAFTER(STR(?mem), '/statement/') AS ?psid)
        WHERE {
          ?item p:P463 ?mem .
          ?mem ps:P463 wd:Q110700815 .
          FILTER NOT EXISTS { ?mem wikibase:rank wikibase:DeprecatedRank }

          OPTIONAL {
            ?mem pqv:P580 [ wikibase:timeValue ?startV ; wikibase:timePrecision ?startP ]
            BIND(COALESCE(
              IF(?startP = 11, SUBSTR(STR(?startV), 1, 10), 1/0),
              IF(?startP = 10, SUBSTR(STR(?startV), 1, 7), 1/0),
              IF(?startP = 9,  SUBSTR(STR(?startV), 1, 4), 1/0),
              IF(?startP = 8,  CONCAT(SUBSTR(STR(?startV), 1, 4), "s"), 1/0),
              ""
            ) AS ?startDate)
          }
          OPTIONAL {
            ?mem pqv:P582 [ wikibase:timeValue ?endV ; wikibase:timePrecision ?endP ]
            BIND(COALESCE(
              IF(?endP = 11, SUBSTR(STR(?endV), 1, 10), 1/0),
              IF(?endP = 10, SUBSTR(STR(?endV), 1, 7), 1/0),
              IF(?endP = 9,  SUBSTR(STR(?endV), 1, 4), 1/0),
              IF(?endP = 8,  CONCAT(SUBSTR(STR(?endV), 1, 4), "s"), 1/0),
              ""
            ) AS ?endDate)
          }

          SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
        }
        # ${new Date().toISOString()}
        ORDER BY ?startDate ?itemLabel ?psid`
}
