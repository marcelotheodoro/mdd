# -*- encoding : utf-8 -*-
require 'mdwa/dsl'

require 'minitest/autorun'

describe MDWA::DSL::Workflow do
  
  before do 
    MDWA::DSL.workflow.register 'Manage projects' do |p|

      # The process start point for every user role
      # Params: :user_role, alias or entity listing
      p.start_for 'ProjectManager', 'new_project_group'
      p.start_for 'TeamMember', 'new_task'

      p.detail 'New Project Group' do |d|
        d.user_roles = ['ProjectManager']
        d.action 'project_group', 'new'
        d.next_action 'create_project_group', :method => :post
      end

      p.detail "Create project group" do |d|

        d.user_roles = ['ProjectManager', 'TeamMember']
        d.action 'project_group', 'create'

        d.next_action 'new_project_group', :when => 'save failed'
        d.next_action 'project_group_list', :redirect => true, :when => 'save ok'
        d.next_action 'new_project', :when => 'clicked save & new project'

      end

    end
  end
  
  
  it "should store data correctly" do 
    MDWA::DSL.workflow.all.count.must_equal 1
    p = MDWA::DSL.process 'manage_projects'
    
    p.nil?.must_equal false
    p.start_for_roles.count.must_equal 2
    p.start_for_roles['ProjectManager'].must_equal 'new_project_group'
    p.start_for_roles['TeamMember'].must_equal 'new_task'
    
    p.details.count.must_equal 2
    p.details[:new_project_group].must_be_instance_of MDWA::DSL::ProcessDetail
    p.details[:new_project_group].description.must_equal 'New Project Group'
    p.details[:new_project_group].user_roles.count.must_equal 1
    p.details[:new_project_group].user_roles.first.must_equal 'ProjectManager'
    p.details[:new_project_group].detail_action.entity.must_equal 'project_group'
    p.details[:new_project_group].detail_action.action.must_equal 'new'
    p.details[:new_project_group].next_actions.count.must_equal 1
    p.details[:new_project_group].next_actions.first.must_be_instance_of MDWA::DSL::ProcessDetailNextAction

    p.details[:create_project_group].must_be_instance_of MDWA::DSL::ProcessDetail
    p.details[:create_project_group].description.must_equal 'Create project group'
    p.details[:create_project_group].user_roles.count.must_equal 2
    p.details[:create_project_group].user_roles.first.must_equal 'ProjectManager'
    p.details[:create_project_group].user_roles.last.must_equal 'TeamMember'
    p.details[:create_project_group].detail_action.entity.must_equal 'project_group'
    p.details[:create_project_group].detail_action.action.must_equal 'create'
    p.details[:create_project_group].next_actions.count.must_equal 3
    p.details[:create_project_group].next_actions[0].must_be_instance_of MDWA::DSL::ProcessDetailNextAction
    p.details[:create_project_group].next_actions[1].must_be_instance_of MDWA::DSL::ProcessDetailNextAction
    p.details[:create_project_group].next_actions[2].must_be_instance_of MDWA::DSL::ProcessDetailNextAction    
    
    # next actions
    p.details[:new_project_group].next_actions.first.alias.must_equal :create_project_group
    p.details[:new_project_group].next_actions.first.method.must_equal :post
    p.details[:new_project_group].next_actions.first.request.must_equal :html
    
    p.details[:create_project_group].next_actions[0].alias.must_equal :new_project_group
    p.details[:create_project_group].next_actions[0].when.must_equal 'save failed'
    p.details[:create_project_group].next_actions[0].redirect.must_equal false
    p.details[:create_project_group].next_actions[1].alias.must_equal :project_group_list
    p.details[:create_project_group].next_actions[1].when.must_equal 'save ok'
    p.details[:create_project_group].next_actions[1].redirect.must_equal true
    p.details[:create_project_group].next_actions[2].alias.must_equal :new_project
    p.details[:create_project_group].next_actions[2].when.must_equal 'clicked save & new project'
    p.details[:create_project_group].next_actions[2].redirect.must_equal false
  
  end
  
end
