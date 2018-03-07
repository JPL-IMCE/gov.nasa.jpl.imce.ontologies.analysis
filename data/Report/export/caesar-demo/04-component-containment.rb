name '04 component containment'

query %q{

  <%= @namespace_defs %>

  SELECT DISTINCT ?super ?super_name ?sub ?sub_name
  WHERE {

    ?super rdfs:subClassOf [ owl:onProperty base:contains;
                             owl:someValuesFrom ?sub ] .

    ?super rdfs:subClassOf mission:Component .
    OPTIONAL {
      ?super rdfs:label ?super_name
    }

    ?sub rdfs:subClassOf mission:Component .
    OPTIONAL {
      ?sub rdfs:label ?sub_name
    }

    FILTER (
      REGEX(STR(?super),
        "http://caesar.imce.jpl.nasa.gov/demos/ICARUS/models/authorities"
      )
      &&
      REGEX(STR(?sub),
        "http://caesar.imce.jpl.nasa.gov/demos/ICARUS/models/authorities"
      )
    )
  }

    ORDER BY ?super ?sub
}
