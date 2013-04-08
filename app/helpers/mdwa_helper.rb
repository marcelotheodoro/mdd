# -*- encoding : utf-8 -*-
module MdwaHelper
  
  def pagination_footer( object_list )

    html = []
    html << '<div id="pagination">'
    html << '<span class="exibir">Exibir</span>'
    html << select_tag(:per_page, options_for_select([[10, 10], [50,50], [100,100], ['- Todos -', object_list.count]], params[:per_page]), :local_url => local_url(request, params))
    html << will_paginate(object_list)
    html << '</div>'
    
    return html.join('').html_safe
  end

  def local_url(request, params)
    glue = !request.url.include?("?") ? "?" : "&"
    return (request.url + glue + params.select{|k,v| k != :per_page}.collect {|k, v| "#{k}=#{v}"}.join('&'))
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
