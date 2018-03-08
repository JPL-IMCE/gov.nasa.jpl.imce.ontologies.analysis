name '05 component suppliers'

query %q{

  <%= @namespace_defs %>

  SELECT DISTINCT ?wp ?wp_name ?comp ?comp_name
  WHERE {

    ?wp rdfs:subClassOf [
      owl:onProperty project:supplies ;
      owl:someValuesFrom ?comp 
    ] .
    OPTIONAL {
      ?wp rdfs:label ?wp_name
    }
    OPTIONAL {
      ?comp rdfs:label ?comp_name
    }

    FILTER (
      REGEX(STR(?wp),
        "http://europa.jpl.nasa.gov/projects/EuropaClipper/DesignCapture/"
      )
      &&
      REGEX(STR(?comp),
        "http://europa.jpl.nasa.gov/projects/EuropaClipper/DesignCapture/"
      )
    )
  }
}
