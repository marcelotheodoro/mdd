# -*- encoding : utf-8 -*-

require 'rails/generators'
require 'rails/generators/migration'

module Mdd
  module Generators
    class AssociationGenerator < Rails::Generators::Base
      
      include Rails::Generators::Migration

      ACCEPTED_RELATIONS = [:has_many, :belongs_to, :has_and_belongs_to_many, :nested_many, :nested_one, :has_one]
      
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

        @model1 = Generators::Model.new( model1 )
        @model2 = Generators::Model.new( model2 )

        # validation
        print_usage unless @model1.valid?
        print_usage unless @model2.valid?
        print_usage unless ACCEPTED_RELATIONS.include? @relation.to_sym

        # active record generates join tables alphabetically
        @ordered_models = [@model1, @model2].sort! {|a,b| a.plural_name <=> b.plural_name}
      end
      

      def model
        case @relation.to_sym 
        when :belongs_to
          inject_into_class "app/models/#{@model1.space}/#{@model1.singular_name}.rb", @model1.klass.classify.constantize do
            ret = []
            ret << "\n\tbelongs_to :#{@model2.singular_name}, :class_name => '#{@model2.klass}'"
            ret << "\tattr_accessible :#{@model2.singular_name.foreign_key}"
            ret.join("\n")
          end
        when :has_one
          inject_into_class "app/models/#{@model1.space}/#{@model1.singular_name}.rb", @model1.klass.classify.constantize do
            "\n\thas_one :#{@model2.singular_name}, :class_name => '#{@model2.klass}'\n"
          end
        when :has_many
          inject_into_class "app/models/#{@model1.space}/#{@model1.singular_name}.rb", @model1.klass.classify.constantize do
            "\n\thas_many :#{@model2.plural_name}, :class_name => '#{@model2.klass}'\n"
          end
        when :has_and_belongs_to_many
          inject_into_class "app/models/#{@model1.space}/#{@model1.singular_name}.rb", @model1.klass.classify.constantize do
            "\n\thas_and_belongs_to_many :#{@model2.plural_name}, :join_table => :#{many_to_many_table_name}\n"
          end
          inject_into_class "app/models/#{@model2.space}/#{@model2.singular_name}.rb", @model2.klass.classify.constantize do
            "\n\thas_and_belongs_to_many :#{@model1.plural_name}, :join_table => :#{many_to_many_table_name}\n"
          end
        when :nested_one
          inject_into_class "app/models/#{@model1.space}/#{@model1.singular_name}.rb", @model1.klass.classify.constantize do
            # belongs_to
            # attr_accessible attributes
            # attr_nested_attributes 
            "\n\tbelongs_to :#{@model2.singular_name}, :class_name => '#{@model2.klass}'\n\tattr_accessible :#{@model2.singular_name}_attributes, :#{@model2.singular_name.foreign_key}\n\taccepts_nested_attributes_for :#{@model2.singular_name}, :allow_destroy => true\n"
          end
        when :nested_many
          inject_into_class "app/models/#{@model1.space}/#{@model1.singular_name}.rb", @model1.klass.classify.constantize do
            # belongs_to
            # attr_accessible attributes
            # attr_nested_attributes 
            "\n\thas_many :#{@model2.plural_name}, :class_name => '#{@model2.klass}', :dependent => :destroy\n\tattr_accessible :#{@model2.plural_name}_attributes\n\taccepts_nested_attributes_for :#{@model2.plural_name}, :allow_destroy => true\n"
          end
        end

      end
      
      def migrate
        unless options.skip_migrations
          
          @pending_migrations = true
          case @relation.to_sym 
          when :belongs_to, :nested_one
            @table = @model1
            @field = @model2
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
          if @relation == 'belongs_to' and (options.with_opposite or ( options.ask and yes?("#{@model1.name} belongs to #{@model2.singular_name}. Create has_many association?") ))
            generate "mdd:association #{@model2.raw} has_many #{@model1.raw} #{'--force' if options.force}"
          end

          # has_many
          if @relation == 'has_many' and (options.with_opposite or ( options.ask and yes?("#{@model1.name} has many #{@model2.plural_name}. Create belongs_to association?") ))
            generate "mdd:association #{@model2.raw} belongs_to #{@model1.raw} #{'--force' if options.force}"
          end
          
          # has_one
          if @relation == 'has_one' and (options.with_opposite or ( options.ask and yes?("#{@model1.name} has one #{@model2.singular_name}. Create belongs_to association?") ))
            generate "mdd:association #{@model2.raw} belongs_to #{@model1.raw} #{'--force' if options.force}"
          end

          # nested_many
          if @relation == 'nested_many' and (options.with_opposite or ( options.ask and yes?("#{@model1.name} has many (nested) with #{@model2.plural_name}. Create belongs_to association?") ))
            generate "mdd:association #{@model2.raw} belongs_to #{@model1.raw} #{'--force' if options.force}"
          end

          # nested_one          
          if @relation == 'nested_one' and (options.with_opposite or ( options.ask and yes?("#{@model1.name} belongs nested to #{@model2.singular_name}. Create has_one association?") ))
            generate "mdd:association #{@model2.raw} has_one #{@model1.raw} #{'--force' if options.force}"
          end

        end
      end

      # Implement the required interface for Rails::Generators::Migration.
      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S").to_s
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end

      private 
        def many_to_many_table_name
          "#{@ordered_models.first.plural_name}_#{@ordered_models.last.plural_name}"
        end


    end
  end
end