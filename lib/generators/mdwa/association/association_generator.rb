# -*- encoding : utf-8 -*-

require 'rails/generators'
require 'rails/generators/migration'

require 'mdwa/generators'

module Mdwa
  module Generators
    class AssociationGenerator < Rails::Generators::Base
      
      include Rails::Generators::Migration
      
      source_root File.expand_path("../templates", __FILE__)

      attr_accessor :model1, :attribute, :model2, :pending_migrations

      argument :model1, :type => :string, :banner => "First part of relation"
      argument :relation, :type => :string, :banner => "has_many, belongs, has_one, nested_many, nested_one..."
      argument :model2, :type => :string, :banner => "Second part of relation"

      class_option :with_opposite, :desc => 'Generate the opposite relation too. For example, the oposite of belongs_to is has_many.', :type => :boolean, :default => false
      class_option :skip_rake_migrate, :desc => 'Skips rake db:migrate', :type => :boolean, :default => false
      class_option :skip_migrations, :desc => 'Skips migration files', :type => :boolean, :default => false
      class_option :ask, :desc => 'Asks if the opposite should be generated.', :type => :boolean, :default => false

      def initialize(*args, &block)

        super
        
        @association = MDWA::Generators::ModelAssociation.new(model1, model2, relation)

      end
      

      def model
        if @association.belongs_to?
          inject_into_class "app/models/#{@association.model1.space}/#{@association.model1.singular_name}.rb", @association.model1.model_class do
            ret = []
            ret << "\n\tbelongs_to :#{@association.model2.singular_name}, :class_name => '#{@association.model2.klass}'"
            ret << "\tattr_accessible :#{@association.model2.singular_name.foreign_key}"
            ret.join("\n")
          end
        end
        if @association.has_one?
          inject_into_class "app/models/#{@association.model1.space}/#{@association.model1.singular_name}.rb", @association.model1.model_class do
            "\n\thas_one :#{@association.model2.singular_name}, :class_name => '#{@association.model2.klass}'\n"
          end
        end
        if @association.has_many?
          inject_into_class "app/models/#{@association.model1.space}/#{@association.model1.singular_name}.rb", @association.model1.model_class do
            "\n\thas_many :#{@association.model2.plural_name}, :class_name => '#{@association.model2.klass}'\n"
          end
        end
        if @association.has_and_belongs_to_many?
          inject_into_class "app/models/#{@association.model1.space}/#{@association.model1.singular_name}.rb", @association.model1.model_class do
            "\n\thas_and_belongs_to_many :#{@association.model2.plural_name}, :join_table => :#{many_to_many_table_name}\n"
          end
          inject_into_class "app/models/#{@association.model2.space}/#{@association.model2.singular_name}.rb", @association.model2.model_class do
            "\n\thas_and_belongs_to_many :#{@association.model1.plural_name}, :join_table => :#{many_to_many_table_name}\n"
          end
        end
        if @association.nested_one?
          inject_into_class "app/models/#{@association.model1.space}/#{@association.model1.singular_name}.rb", @association.model1.model_class do
            # belongs_to
            # attr_accessible attributes
            # attr_nested_attributes 
            "\n\tbelongs_to :#{@association.model2.singular_name}, :class_name => '#{@association.model2.klass}'\n\tattr_accessible :#{@association.model2.singular_name}_attributes, :#{@association.model2.singular_name.foreign_key}\n\taccepts_nested_attributes_for :#{@association.model2.singular_name}, :allow_destroy => true\n"
          end
        end
        if @association.nested_many?
          inject_into_class "app/models/#{@association.model1.space}/#{@association.model1.singular_name}.rb", @association.model1.model_class do
            # has_many
            # attr_accessible attributes
            # attr_nested_attributes 
            "\n\thas_many :#{@association.model2.plural_name}, :class_name => '#{@association.model2.klass}', :dependent => :destroy\n\tattr_accessible :#{@association.model2.plural_name}_attributes\n\taccepts_nested_attributes_for :#{@association.model2.plural_name}, :allow_destroy => true\n"
          end
        end

      end
      
      def migrate
        unless options.skip_migrations
          
          @pending_migrations = true
          case @association.relation.to_sym 
          when :belongs_to, :nested_one
            @table = @association.model1
            @field = @association.model2
            migration_template 'migrate/one_field.rb', "db/migrate/add_#{@field.singular_name.foreign_key}_to_#{@table.plural_name}.rb"
          when :has_and_belongs_to_many
            migration_template 'migrate/many_to_many.rb', "db/migrate/create_#{many_to_many_table_name}.rb"
          else
            @pending_migrations = false
          end
          
        end

      end

      def run_rake_db_migrate
        rake('db:migrate') if !options.skip_rake_migrate and @pending_migrations and yes? 'Run rake db:migrate?'
      end

      def opposite

        if options.with_opposite or options.ask
          # belongs_to
          if @association.belongs_to? and (options.with_opposite or ( options.ask and yes?("#{@association.model1.name} belongs to #{@association.model2.singular_name}. Create has_many association?") ))
            generate "mdwa:association #{@association.model2.raw} has_many #{@association.model1.raw} #{'--force' if options.force}"
          end

          # has_many
          if @association.has_many? and (options.with_opposite or ( options.ask and yes?("#{@association.model1.name} has many #{@association.model2.plural_name}. Create belongs_to association?") ))
            generate "mdwa:association #{@association.model2.raw} belongs_to #{@association.model1.raw} #{'--force' if options.force}"
          end
          
          # has_one
          if @association.has_one? and (options.with_opposite or ( options.ask and yes?("#{@association.model1.name} has one #{@association.model2.singular_name}. Create belongs_to association?") ))
            generate "mdwa:association #{@association.model2.raw} belongs_to #{@association.model1.raw} #{'--force' if options.force}"
          end

          # nested_many
          if @association.nested_many? and (options.with_opposite or ( options.ask and yes?("#{@association.model1.name} has many (nested) with #{@association.model2.plural_name}. Create belongs_to association?") ))
            generate "mdwa:association #{@association.model2.raw} belongs_to #{@association.model1.raw} #{'--force' if options.force}"
          end

          # nested_one          
          if @association.nested_one? and (options.with_opposite or ( options.ask and yes?("#{@association.model1.name} belongs nested to #{@association.model2.singular_name}. Create has_one association?") ))
            generate "mdwa:association #{@association.model2.raw} has_one #{@association.model1.raw} #{'--force' if options.force}"
          end

        end
      end

      # Implement the required interface for Rails::Generators::Migration.
      def self.next_migration_number(dirname) #:nodoc:
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end

      private 
        def many_to_many_table_name
          "#{@association.ordered.first.plural_name}_#{@association.ordered.last.plural_name}"
        end


    end
  end
end
