class StylesController < ApplicationController
  def index
    query =
      if params[:search].present?
        Style.where_name_is_like(params[:search])
      else
        Style.all
      end

    query = query
      .order(name: :asc)

    @pagy, @styles = pagy(query)
    @pagy_metadata = @pagy.data_hash
  end
end
