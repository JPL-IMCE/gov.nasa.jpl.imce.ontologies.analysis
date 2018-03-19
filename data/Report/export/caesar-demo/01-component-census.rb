name '01 component census'

query %q{

  <%= @namespace_defs %>

  SELECT DISTINCT ?iri ?name ?hardware ?thermal ?power
  FROM <urn:x-arq:UnionGraph>
  WHERE {

    ?iri rdfs:subClassOf+ mission:Component .

    OPTIONAL {
      ?iri rdfs:label ?name
    }

    bind(exists { ?iri rdfs:subClassOf [ rdfs:label "europa:HardwareComponent" ] } as ?hardware)
    bind(exists { ?iri rdfs:subClassOf [ rdfs:label "Thermal Load Product" ] } as ?thermal)
    bind(exists { ?iri rdfs:subClassOf [ rdfs:label "europa:PowerLoadComponent" ] } as ?power)

    FILTER (
      REGEX(STR(?iri),
        "http://europa.jpl.nasa.gov/user-model/generated/md"
      )
    )
  }
}
