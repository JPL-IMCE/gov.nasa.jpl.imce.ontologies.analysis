name '02 interface census'

query %q{

  <%= @namespace_defs %>

  SELECT DISTINCT ?iri ?name
  FROM <urn:x-arq:UnionGraph>
  WHERE {

    ?iri rdfs:subClassOf mission:Interface .

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
