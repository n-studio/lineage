class DemoController < ApplicationController
  def index
    @root_practitioner = Practitioner.order(:id).first
    @already_listed_practitioners = []
  end
end
