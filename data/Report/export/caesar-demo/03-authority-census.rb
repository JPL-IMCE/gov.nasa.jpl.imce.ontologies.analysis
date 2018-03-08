name '03 authority census'

query %q{

  <%= @namespace_defs %>

  SELECT DISTINCT ?c ?v
  WHERE {
    ?c rdfs:subClassOf+ project:Authority .
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
