require 'mdwa/dsl'
class Mdwa::RequirementsController < Mdwa::MDWAController
  
  def index
    # reload the requirements
    MDWA::DSL.requirements.clear 
    
    Dir.glob("#{MDWA::DSL::REQUIREMENTS_PATH}/*.rb").each { |file| load file }
    @requirements = MDWA::DSL.requirements.all
  end
  
end