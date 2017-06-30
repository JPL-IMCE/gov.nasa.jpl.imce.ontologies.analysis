name 'every component has a single supplier'

  query %q{
  
  <%= @namespace_defs %>

  select distinct ?component ?at_least_one ?at_least_two

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
    bind(bound(?supplier2) as ?at_least_two)
  }
}

# Identify each test case by its IRI.

case_name { |r| r.component.to_qname(@namespace_by_prefix) }
  
# Explain success or failure

predicate do |r|
  if r.at_least_two.true?
    [false, 'multiple suppliers']
  elsif r.at_least_one.true?
    [true, nil]
  else
    [false, 'no supplier']
  end
end
