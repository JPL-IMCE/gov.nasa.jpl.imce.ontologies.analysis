name 'every component has a single supplier'

  query %q{
  
  <%= @namespace_defs %>

  select distinct ?component ?at_least_one ?exactly_one

  <%= @from_named_clauses_by_group['named'] %>
  <%= @from_clauses_by_group['named'] %>
  <%= @from_clauses_by_group['imported'] %>
  <%= @from_clauses_by_group_by_type['named']['ClassEntailments'] %>
  <%= @from_clauses_by_group_by_type['imported']['ClassEntailments'] %>

  where {
    
    # find all mission:Components in the named ontologies
    
    graph ?graph { ?component rdf:type <http://imce.jpl.nasa.gov/discipline/mass_management#MComponent> }
    
    optional {
      ?supplier1 project:supplies ?component .
      optional {
        ?supplier2 project:supplies ?component .
        filter(?supplier1 != ?supplier2)
      }
    }

    bind(bound(?supplier1) as ?at_least_one)
    bind(bound(?supplier1) && !bound(?supplier2) as ?exactly_one)
  }
}

# Identify each test case by its IRI.

case_name { |r| r.component.to_qname(@namespace_by_prefix) }
  
# Include the work package name in the failure text.

predicate do |r|
  if r.exactly_one.true?
    [true, nil]
  elsif r.at_least_one.true?
    [false, 'multiple suppliers']
  else
    [false, 'no supplier']
  end
end
