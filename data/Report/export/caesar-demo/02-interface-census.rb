name '02 interface census'

query %q{

  <%= @namespace_defs %>

  SELECT ?c ?v
  WHERE {
    ?c rdfs:subClassOf mission:Interface .
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
