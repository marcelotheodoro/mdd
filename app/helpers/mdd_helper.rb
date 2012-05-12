module MddHelper
  
  def pagination_footer( object_list )
    html = []
    html.push '<div id="pagination">'
    html.push will_paginate object_list
    html.push '</div></div>'
    
    return html.join('').html_safe
  end

  def encode_results_to_autocomplete(results, field_name)
    return results.collect{ |c| "{label: '#{c.send field_name}', value: '#{c.id}'}"  }.join( ',' )
  end
  
end