require "rails_helper"

RSpec.describe PractitionersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/practitioners").to route_to("practitioners#index")
    end

    it "routes to #new" do
      expect(get: "/practitioners/new").to route_to("practitioners#new")
    end

    it "routes to #show" do
      expect(get: "/practitioners/1").to route_to("practitioners#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/practitioners/1/edit").to route_to("practitioners#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/practitioners").to route_to("practitioners#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/practitioners/1").to route_to("practitioners#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/practitioners/1").to route_to("practitioners#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/practitioners/1").to route_to("practitioners#destroy", id: "1")
    end
  end
end
