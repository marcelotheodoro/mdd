module PaginationHelper
  
  def pagination_footer var
    html = []
    html.push '<div class="footer"><div id="paginacao">'
    html.push will_paginate var
    html.push '</div></div>'
    
    return html.join('').html_safe
  end
  
end