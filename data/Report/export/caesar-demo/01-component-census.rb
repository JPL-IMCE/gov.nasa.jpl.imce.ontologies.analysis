name '01 component census'

query %q{

  <%= @namespace_defs %>

  SELECT DISTINCT ?iri ?name
  WHERE {

    ?iri rdfs:subClassOf mission:Component .

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
