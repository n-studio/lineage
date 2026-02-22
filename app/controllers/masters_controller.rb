class MastersController < ApplicationController
  before_action :authenticate_user!

  def new
    @practitioner = Practitioner.find(params[:practitioner_id])
    @master = Practitioner.new
    @styles = Style.all.order(practitioners_count: :desc).limit(10)
  end

  def create
    Practitioner.transaction do
      @practitioner = Practitioner.find(params[:practitioner_id])
      @master =
        if master_params[:name].to_i > 0
          Practitioner.find(master_params[:name])
        else
          Practitioner.create!(name: master_params[:name], public_figure: master_params[:public_figure], added_by: current_user)
        end

      @style =
        if master_params[:style].to_i > 0
          Style.find(master_params[:style])
        else
          Style.find_or_create_by!(name: master_params[:style])
        end
      @practitioner.disciple_of!(@master, style: @style)
    end

    respond_to do |format|
      format.html { redirect_to practitioner_url(@practitioner), notice: "Master was successfully added." }
      format.json { head :no_content }
    end
  rescue ActiveRecord::RecordInvalid => e
    @master ||= Practitioner.new(name: master_params[:name])
    @styles = Style.all.order(practitioners_count: :desc).limit(10)

    respond_to do |format|
      format.turbo_stream do
        flash.now[:alert] = e.message
        render turbo_stream: [
          turbo_stream.replace("flash", partial: "alert"),
          turbo_stream.replace("practitioner_info", partial: "masters/form"),
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

  def master_params
    params.require(:practitioner)
      .permit(:name, :style, :public_figure)
  end
end
