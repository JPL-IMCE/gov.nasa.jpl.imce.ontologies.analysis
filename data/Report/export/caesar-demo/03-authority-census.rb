name '03 authority census'

query %q{

  <%= @namespace_defs %>

  SELECT ?c ?v
  WHERE {
    ?c rdfs:subClassOf project:Authority .
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
