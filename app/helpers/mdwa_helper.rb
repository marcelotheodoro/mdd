# -*- encoding : utf-8 -*-
module MdwaHelper
  
  def pagination_footer( object_list )
    html = []
    html.push '<div id="pagination">'
    html.push will_paginate object_list
    html.push '</div></div>'
    
    return html.join('').html_safe
  end

  def encode_results_to_autocomplete(results, field_name)
    results.collect{ |c| "{label: \"#{c.send(field_name).html_safe}\", value: \"#{c.id}\"}"  }.join( ',' ).html_safe
  end
  
  def file_icon_path( file_name, size = 'medium' )
    exts = [ "bmp", "css", "csv", "doc", "docx", "eps", "gif", "html", "ico", "jpg", "js", "json", "mp3", "pdf", "php", "png", "ppt", "pptx", "psd", "svg", "swf", "tiff", "txt", "wav", "xls", "xlsx", "xml" ]
    path = "mdwa/documents"

    # recuperando a extensão do arquivo
    file_name = file_name.split( "." )
    # Caso não tenha extensão, ícone padrão é o de txt
    # Caso não exista o ícone da extensão, icone padrão é o do txt
    if file_name.length.eql?(1) or !exts.include?(file_name[ file_name.length - 1])
      ext = "txt"
    else
      ext = file_name[ file_name.length - 1]
    end

    return "#{path}/#{size}/#{ext}_file.png"
  end
  
end
