module PaginationHelper
  
  def pagination_footer var
    html = []
    html.push '<div id="pagination">'
    html.push will_paginate var
    html.push '</div></div>'
    
    return html.join('').html_safe
  end
  
end