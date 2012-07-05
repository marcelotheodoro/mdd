# -*- encoding : utf-8 -*-

module MDD
  module Layout

    class Base

      # singleton class
      class << self
      
        attr_accessor :routes_table

        # Define layout mappings.
        # For example:
        # 
        # map '/*', 'layout_padraozao'
        # map '/administrator/*', 'layout_administrator'
        # map '/a/administrator/*', 'layout_a_administrador'
        # map 'controller#*', 'layout_controller'
        # map '/administrator/controller#*', 'layout_administrator_controller'
        #     
        # map '/administrator/controller#action', 'layout1' 
        # map 'controller#action', 'layout2'
        def config
          @routes_table = {}
          yield @routes_table if block_given?
        end
        
        # returns the corresponding layout of the current route
        def select_layout(route)
          # if route is namespaced, corrects the request
          if !route.rindex('/').nil? and route[0] != '/'
            route = "/#{route}"
          end
          return layout(route)
        end

        private

          def layout(route)        
            layout = @routes_table[route]
            if !layout.nil?
              return layout
            end
            
            return default_for route
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

        end # class << self
    end # class LayoutBase

  end # module Layout
end # module Mdd