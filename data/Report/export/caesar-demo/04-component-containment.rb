name '04 component containment'

query %q{

  <%= @namespace_defs %>

  SELECT DISTINCT ?super ?super_name ?sub ?sub_name
  FROM <urn:x-arq:UnionGraph>
  WHERE {

    ?super rdfs:subClassOf [ owl:onProperty base:contains;
                             owl:someValuesFrom ?sub ] .

    ?super rdfs:subClassOf+ mission:Component .
    OPTIONAL {
      ?super rdfs:label ?super_name
    }

    ?sub rdfs:subClassOf+ mission:Component .
    OPTIONAL {
      ?sub rdfs:label ?sub_name
    }

    FILTER (
      REGEX(STR(?super),
        "http://europa.jpl.nasa.gov/projects/EuropaClipper/DesignCapture/"
      )
      &&
      REGEX(STR(?sub),
        "http://europa.jpl.nasa.gov/projects/EuropaClipper/DesignCapture/"
      )
    )
  }
}
