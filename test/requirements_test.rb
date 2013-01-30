# -*- encoding : utf-8 -*-
require 'mdwa/dsl'

require 'minitest/spec'
require 'minitest/autorun'

describe MDWA::DSL::Entity do
  
  before do 
    MDWA::DSL.requirements.register do |r|
      r.summary = 'Manage Projects'

      r.description = %q{Detailed description of the requirement.}
      r.entities    = ['ProjectGroup', 'Project', 'Task', 'Milestone']
      r.users       = ['Administrator', 'TeamMember']
    end
    
    MDWA::DSL.requirements.register 'Manage clients' do |r|
    end
  end
  
  it 'should store data correctly' do
    requirement = MDWA::DSL.requirement(:manage_projects)
    requirement.summary.must_equal 'Manage Projects'
    requirement.description.must_equal 'Detailed description of the requirement.'
    requirement.entities.count.must_equal 4
    requirement.entities[0].must_equal 'ProjectGroup'
    requirement.entities[1].must_equal 'Project'
    requirement.entities[2].must_equal 'Task'
    requirement.entities[3].must_equal 'Milestone'
    requirement.users.count.must_equal 2
    requirement.users[0].must_equal 'Administrator'
    requirement.users[1].must_equal 'TeamMember'
    
    requirement_client = MDWA::DSL.requirement(:manage_clients)
    requirement_client.nil?.must_equal false
    requirement_client.summary.must_equal 'Manage clients'
    requirement_client.alias.must_equal :manage_clients
    
  end
  
end
