name '01 component census'

query %q{

  <%= @namespace_defs %>

  PREFIX europa: <http://europa.jpl.nasa.gov/projects/EuropaClipper/DesignCapture/vocabularyExtensions/MEL_PEL_TEL/europa#>
  PREFIX MEL_PEL_TEL: <http://europa.jpl.nasa.gov/projects/EuropaClipper/DesignCapture/vocabularyExtensions/MEL_PEL_TEL#>

  SELECT DISTINCT ?iri ?name ?hardware ?thermal ?power
  WHERE {

    ?iri rdfs:subClassOf+ mission:Component .

    OPTIONAL {
      ?iri rdfs:subClassOf [ owl:onProperty base:hasCanonicalName ; owl:hasValue ?name ] 
    }

    bind(exists { ?iri rdfs:subClassOf europa:HardwareComponent } as ?hardware)
    bind(exists { ?iri rdfs:subClassOf MEL_PEL_TEL:ThermalLoadProduct } as ?thermal)
    bind(exists { ?iri rdfs:subClassOf europa:PowerLoadComponent } as ?power)

    FILTER (
      REGEX(STR(?iri),
        "http://europa.jpl.nasa.gov/projects/EuropaClipper/DesignCapture/"
      )
    )
  }
}
