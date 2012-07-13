# -*- encoding : utf-8 -*-
MDWA::DSL.entities.register "<%= name.singularize.camelize %>" do |e|
  
  <%- unless options.no_comments -%>
  # e.purpose   = %q{To-do} # what this entity does?
  # e.resource  = true      # should it be stored like a resource?
  # e.ajax      = true      # scaffold with ajax?
  # e.scaffold_name = 'a/<%= name.singularize.underscore %>' # mdwa sandbox specific code?

  ##
  ## Define entity attributes
  ##
  # e.attribute do |attr|
  #   attr.name = 'name'
  #   attr.type = 'string'
  # end
  # e.attribute do |attr|
  #   attr.name = 'category'
  #   attr.type = 'integer'
  # end
  
  ##
  ## Define entity associations
  ##
  # e.association do |a|
  #   a.destination = 'Category' # entity name
  #   a.type = 'many_to_one'
  #   a.description = 'Category association. Indicates that this entity belongs to a category.'
  # end
  # 
  # e.association do |a|
  #   a.name = 'address'
  #   a.destination = 'Address' 
  #   a.type = 'one_to_one'
  #   a.composition = true
  #   a.description = 'This entity has a composite address.'
  # end
  <%- end -%>
  
end