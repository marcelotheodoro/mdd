class LayoutBase
  
  attr_accessor :routes_table

  # Define os mapeamentos do layout.
  # Exemplo de utilização:
  # 
  # map '/*', 'layout_padraozao'
  # map '/administrator/*', 'layout_administrator'
  # map '/a/administrator/*', 'layout_a_administrador'
  # map 'controller#*', 'layout_controller'
  # map '/administrator/controller#*', 'layout_administrator_controller'
  #     
  # map '/administrator/controller#action', 'layout1' 
  # map 'controller#action', 'layout2'
  def initialize
    @routes_table = Hash.new
    self.mapping
  end
  
  def layout_from_split_elements( params )
    puts "/#{params[:namespace]}/#{params[:controller]}##{params[:action]}" if !params[:namespace].nil? and !params[:controller].nil?
    puts "#{params[:controller]}##{params[:action]}" if params[:namespace].nil? and !params[:action].nil?
  end
  
  # Retorna o layout da rota específica
  def layout route
    
    layout = @routes_table[route]
    if !layout.nil?
      return layout
    end
    
    return default_for route
     
  end
  
  # Faz o mapeamento entre uma rota e um layout
  private
    def map(route, layout)
      @routes_table[route] = layout
    end
    
    def default_for(route)
      
      # salva o layout padrão como sendo o 'application'
      if route == '/*'
        @routes_table['/*'] = 'application' if @routes_table['/*'].nil?
        return @routes_table['/*']
      end
      
      # caminho completo passado 'a/b#c'
      if route.rindex('*').nil?
        # substitui tudo depois do '#'
        route_split = route.split('#')
        if route_split.count > 1
          # busca 'a/b#*'
          route = route_split.first(route_split.count - 1).join('') + '#*'
          return layout(route)
        else 
          return layout( '/*' )
        end
      else
      # caminho padrão com *
      
        # busca 'a/b/c#*' e transforma em 'a/b/c/*'
        route_split = route.split('#')
        if route_split.count > 1
           route = route_split.first(route_split.count - 1).join('')
           route_split = route.split('/').slice(0..-2)
           route = route_split.join('/') + '/*'
           return layout(route)
        else
          # busca 'a/b/*'
          route_split = route.split('/')
          if route_split.count > 1
            route = route_split.first(route_split.count - 1).join('')
            route_split = route.split('/').slice(0..-2)
            route = route_split.join('/') + '/*'
            return layout(route)
          else
            return layout( '/*' )
          end
        end
      
      end
      
    end
end