# -*- encoding : utf-8 -*-

require 'rails/generators'
require 'rails/generators/migration'

require 'mdwa/dsl'

module Mdwa
  module Generators
    class TemplatesGenerator < Rails::Generators::Base
      
      include Rails::Generators::Migration
      
      source_root File.expand_path("../templates", __FILE__)
      
      attr_accessor :entities
      
      argument :entities, :type => :array, :banner => 'Entities to transform', :default => []
      
      #
      # Constructor
      # Require all entities to load the DSL of the application
      def initialize(*args, &block)
        super
        
        # include files with entities
        # select entities that will be generated
        inside Rails.root do
          require_all MDWA::DSL::STRUCTURAL_PATH unless Dir.glob("#{MDWA::DSL::STRUCTURAL_PATH}/*.rb").count.zero?
        end
        
        # select entities that will be generated
        if entities.count.zero?
          @entities = MDWA::DSL.entities.all 
        else
          @entities = entities.collect{ |e| MDWA::DSL.entity(e) }
        end
      end
      
      
      def general_files
        template 'general/routes.rb', "#{MDWA::DSL::TEMPLATES_PATH}routes.rb"
      end
      
      def entities_scaffold
        
        @entities.each do |entity|
          
          model = entity.generator_model
          
          puts '--------------------------------------'
          puts "- Templates for: #{entity.name} -"
          puts '--------------------------------------'
        
          copy_with_header 'scaffold/controller.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}controller.erb", entity.name
          copy_with_header 'scaffold/helper.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}helper.erb", entity.name
          copy_with_header 'scaffold/model.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}model.erb", entity.name
          
          # views
          copy_with_header 'scaffold/views/_form_fields.html.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}views/_form_fields.html.erb", entity.name
          copy_with_header 'scaffold/views/_form.html.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}views/_form.html.erb", entity.name
          copy_with_header 'scaffold/views/_list.html.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}views/_list.html.erb", entity.name
          copy_with_header 'scaffold/views/create.js.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}views/create.js.erb", entity.name
          copy_with_header 'scaffold/views/destroy.js.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}views/destroy.js.erb", entity.name
          copy_with_header 'scaffold/views/edit.html.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}views/edit.html.erb", entity.name
          copy_with_header 'scaffold/views/index.html.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}views/index.html.erb", entity.name
          copy_with_header 'scaffold/views/index.xls.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}views/index.xls.erb", entity.name
          copy_with_header 'scaffold/views/index.js.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}views/index.js.erb", entity.name
          copy_with_header 'scaffold/views/new.html.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}views/new.html.erb", entity.name
          copy_with_header 'scaffold/views/show.html.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}views/show.html.erb", entity.name
          copy_with_header 'scaffold/views/update.js.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}views/update.js.erb", entity.name
        end
      end
        
        
      def entity_actions
        
        puts '--------------------------------------'
        puts "- Generating actions -"
        puts '--------------------------------------'
        
        @entities.each do |entity|
          # next iteration if entity doesn't have specifications
          next if entity.actions.actions.count.zero?

          model = entity.generator_model

          path_to_controller  = "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}controller.erb"
          controller_string   = File.read("#{Rails.root}/#{path_to_controller}")

          # hooks for code generations
          controller_hook = '#===controller_init==='
          test_hook = '#===test_init==='

          # insert in controller
          insert_into_file path_to_controller, :after => controller_hook do 
            actions = []
            entity.actions.generate_controller.each do |action_name, generation_string|
              # write the generated code only if it is not declared in the controller
              actions << "\n\n#{generation_string}" unless controller_string.include? "def #{action_name}"
            end
            actions.join
          end
          
          # generate the corresponding files
          entity.actions.actions.values.select{ |a| !a.resource? }.each do |action|
            action.template_names.each do |request, file_name|          
              case request.to_sym
              when :modalbox, :html
                copy_with_header 'actions/view.html.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}views/#{file_name}", entity unless File.exist?("#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/views/#{file_name}")
              when :ajax
                copy_with_header 'actions/view.js.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}views/#{file_name}", entity unless File.exist?("#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/views/#{file_name}")
              when :ajax_js
                copy_with_header 'actions/view.json.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}views/#{file_name}", entity unless File.exist?("#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/views/#{file_name}")
              else
                copy_with_header 'actions/view.custom.erb', "#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/#{model.space + '/'}views/#{file_name}", entity unless File.exist?("#{MDWA::DSL::TEMPLATES_PATH}#{entity.file_name}/views/#{file_name}")
              end
            end
          end

          # inject routes testing
          # if File.exist?(Rails.root + "/spec/routing/#{model.space}/#{model.plural_name}_routing_spec.rb")
          #   insert_into_file "spec/routing/#{model.space}/#{model.plural_name}_routing_spec.rb", :after => 'describe "routing" do' do
          #     routes = []
          #     entity.actions.actions.values.select {|a| !a.resource}.each do |action|
          #       routes << "\n\n\t\tit 'routes to ##{action.name}' do"
          #       routes << "\n\t\t\t#{action.method.to_s}('#{action.entity.generator_model.to_route_url}/#{'1/' if action.member?}#{action.name}').should route_to('#{action.entity.generator_model.to_route_url}##{action.name}' #{', :id => "1"' if action.member?})"
          #       routes << "\n\t\tend"
          #     end
          #     routes.join
          #   end
          # end

        end # @entities loop
        
      end
      
      def tests
      end
      
      
      private
      
        def copy_with_header(source, destination, entity)
          if !File.exist?(Rails.root + destination) or options.force
            copy_file source, destination
            gsub_file destination, '===entity_code===', "<%- \n@entity = MDWA::DSL.entity('#{entity}') \n@model = @entity.generator_model \n-%>", {:verbose => false}
          end
        end
      
    end
  end
end
