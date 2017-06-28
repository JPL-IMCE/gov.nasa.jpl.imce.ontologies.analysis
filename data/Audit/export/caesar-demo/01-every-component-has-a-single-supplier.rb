name 'every component has a single supplier'

  query %q{
  
  <%= @namespace_defs %>

  select distinct ?component ?at_least_one ?exactly_one

  <%= @from_clauses_by_group['named'] %>
  <%= @from_clauses_by_group['imported'] %>
  <%= @from_clauses_by_group_by_type['named']['ClassEntailments'] %>
  <%= @from_clauses_by_group_by_type['imported']['ClassEntailments'] %>
  <%= @from_clauses_by_group_by_type['named']['PropertyEntailments'] %>
  <%= @from_clauses_by_group_by_type['imported']['PropertyEntailments'] %>
  <%= @from_clauses_by_group_by_type['named']['InstanceEntailments'] %>
  <%= @from_clauses_by_group_by_type['imported']['InstanceEntailments'] %>

  where {
    
    # find all components in the named ontologies
    
    ?component rdf:type mission:Component

    # find up to two suppliers

    optional {
      ?supplier1 project:supplies ?component .
      optional {
        ?supplier2 project:supplies ?component .
        filter(?supplier1 != ?supplier2)
      }
    }

    # set success/failure indicators

    bind(bound(?supplier1) as ?at_least_one)
    bind(bound(?supplier1) && !bound(?supplier2) as ?exactly_one)
  }
}

# Identify each test case by its IRI.

case_name { |r| r.component.to_qname(@namespace_by_prefix) }
  
# Explain success or failure

predicate do |r|
  if r.exactly_one.true?
    [true, nil]
  elsif r.at_least_one.true?
    [false, 'multiple suppliers']
  else
    [false, 'no supplier']
  end
end
