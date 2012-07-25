require "spec_helper"

describe <%= @model.controller_name %>Controller do
  describe "routing" do

    it "routes to #index" do
      get("/<%= @model.to_route_url %>").should route_to("<%= @model.to_route_url %>#index")
    end

    it "routes to #new" do
      get("/<%= @model.to_route_url %>/new").should route_to("<%= @model.to_route_url %>#new")
    end

    it "routes to #show" do
      get("/<%= @model.to_route_url %>/1").should route_to("<%= @model.to_route_url %>#show", :id => "1")
    end

    it "routes to #edit" do
      get("/<%= @model.to_route_url %>/1/edit").should route_to("<%= @model.to_route_url %>#edit", :id => "1")
    end

    it "routes to #create" do
      post("/<%= @model.to_route_url %>").should route_to("<%= @model.to_route_url %>#create")
    end

    it "routes to #update" do
      put("/<%= @model.to_route_url %>/1").should route_to("<%= @model.to_route_url %>#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/<%= @model.to_route_url %>/1").should route_to("<%= @model.to_route_url %>#destroy", :id => "1")
    end

  end
end