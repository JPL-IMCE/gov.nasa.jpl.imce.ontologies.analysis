name '02 interface census'

query %q{

  <%= @namespace_defs %>

  SELECT DISTINCT ?c ?v
  WHERE {
    ?c rdfs:subClassOf+ mission:Interface .
    OPTIONAL {
      ?c rdfs:label ?v
    }
    FILTER (
      REGEX(STR(?c),
        "http://europa.jpl.nasa.gov/projects/EuropaClipper/DesignCapture/"
      )
    )
  }
}
