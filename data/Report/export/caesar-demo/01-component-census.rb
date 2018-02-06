name '01 component census'

query %q{

  <%= @namespace_defs %>

  SELECT ?c ?v
  WHERE {
    ?c rdfs:subClassOf mission:Component .
    OPTIONAL {
      ?c rdfs:subClassOf [ owl:onProperty base:hasCanonicalName ; owl:hasValue ?v ] 
    }
    FILTER (
      REGEX(STR(?c),
        "http://europa.jpl.nasa.gov/projects/EuropaClipper/DesignCapture/"
      )
    )
  }
}
