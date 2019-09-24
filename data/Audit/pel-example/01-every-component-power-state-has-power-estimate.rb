name 'every component power state has an estimated power usage'

  query %q{
  
  PREFIX owl:   <http://www.w3.org/2002/07/owl#>
  PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>
  PREFIX analysis: <http://imce.jpl.nasa.gov/foundation/analysis/analysis#>
  PREFIX mission: <http://imce.jpl.nasa.gov/foundation/mission/mission#>
  PREFIX behavior: <http://imce.jpl.nasa.gov/foundation/behavior/behavior#>
  PREFIX pel: <http://imce.jpl.nasa.gov/discipline/power/pel#>
  PREFIX base:  <http://imce.jpl.nasa.gov/foundation/base/base#>
  PREFIX iso-80000-4: <http://iso.org/iso-80000-4#>
  PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
  SELECT DISTINCT ?cmp_state ?has_power_cbe
  FROM <urn:x-arq:UnionGraph>
  WHERE
  {
    ?subSys base:aggregates ?c .
    ?c a mission:Component .
    FILTER NOT EXISTS { ?c base:aggregates+ ?d }
  
    ?powerMode analysis:characterizes ?c .

    ?powerMode a behavior:StateVariable .
    ?powerMode behavior:hasCodomain ?codomain .

    ?codomain a behavior:CompoundCodomain .
    ?codomain behavior:hasElement ?cmp_state .
    
    OPTIONAL {
      ?powerUsage a behavior:StateVariable .
      ?powerUsage behavior:hasCodomain ?powerUsageCodomain .

      ?powerUsageCodomain a pel:WattCodomain .

      ?const analysis:characterizes ?cmp_state .
      ?const a behavior:Constraint .
      ?const behavior:constrains ?powerUsage .
    }
  
    BIND(bound(?const) AS ?has_power_cbe)
  }
}

# Identify each test case by its IRI.

case_name { |r| r.cmp_state.to_qname(@namespace_by_prefix) }
  
# Explain success or failure

predicate do |r|
  if r.has_power_cbe.true?
    [true, nil]
  else
    [false, 'no power estimate']
  end
end