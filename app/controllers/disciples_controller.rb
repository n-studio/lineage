class DisciplesController < ApplicationController
  before_action :authenticate_user!

  def new
    @practitioner = Practitioner.find(params[:practitioner_id])
    @disciple = Practitioner.new
    @styles = Style.all.order(practitioners_count: :desc).limit(10)
  end

  def create
    Practitioner.transaction do
      @practitioner = Practitioner.find(params[:practitioner_id])
      @disciple =
        if disciple_params[:name].to_i > 0
          Practitioner.find(disciple_params[:name])
        else
          Practitioner.create!(name: disciple_params[:name], added_by: current_user)
        end

      @style =
        if disciple_params[:style].to_i > 0
          Style.find(disciple_params[:style])
        else
          Style.find_or_create_by!(name: disciple_params[:style])
        end
      @practitioner.master_of!(@disciple, style: @style)
    end

    respond_to do |format|
      format.html { redirect_to practitioners_url, notice: "Disciple was successfully added." }
      format.json { head :no_content }
    end
  rescue ActiveRecord::RecordInvalid => e
    @disciple ||= Practitioner.new(name: disciple_params[:name])
    @styles = Style.all.order(practitioners_count: :desc).limit(10)

    respond_to do |format|
      format.turbo_stream do
        flash.now[:alert] = e.message
        render turbo_stream: [
          turbo_stream.replace("flash", partial: "alert"),
          turbo_stream.replace("practitioner_info", partial: "disciples/form"),
          turbo_stream.replace("after-stream-render", partial: "after_stream_render"),
        ]
      end
      format.html do
        flash.now[:alert] = e.message
        render :new
      end
    end
  end

  private

  def disciple_params
    params.require(:practitioner)
      .permit(:name, :style)
  end
end
