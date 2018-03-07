name '03 authority census'

query %q{

  <%= @namespace_defs %>

  SELECT DISTINCT ?iri ?name
  WHERE {

    ?iri rdfs:subClassOf project:Authority .

    OPTIONAL {
      ?iri rdfs:label ?name
    }

    FILTER (
      REGEX(STR(?iri),
        "http://caesar.imce.jpl.nasa.gov/demos/ICARUS/models/authorities"
      )
    )
  }
}
