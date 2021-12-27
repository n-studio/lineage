class DemoController < ApplicationController
  def index
    case params[:example]
    when "2"
      example_2
    else
      example_1
    end
  end

  def static_index
  end

  private

  def example_1
    @style = Style.first
    @root_practitioner = Practitioner.includes(:disciples).find_by(name: "Ng Mui")
    @tree = TreeBuilder.new(practitioners: [@root_practitioner], style: @style, mode: :root).call
  end

  def example_2
    @style = Style.first
    @leaf_practitioner = Practitioner.includes(:disciples).find_by(name: "Chu Shong Tin")
    @tree = TreeBuilder.new(practitioners: [@leaf_practitioner], style: @style, mode: :leaves).call
  end
end
