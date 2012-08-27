require 'mdwa/dsl'
class Mdwa::RequirementsController < Mdwa::MDWAController
  
  def index
    require_all MDWA::DSL::REQUIREMENTS_PATH
    @requirements = MDWA::DSL.requirements.all
  end
  
end