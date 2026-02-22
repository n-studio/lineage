class PractitionersController < ApplicationController
  before_action :authenticate_user!, only: %i[new edit create update destroy]
  before_action :set_practitioner, only: %i[ show edit update destroy ]

  # GET /practitioners or /practitioners.json
  def index
    query =
      if params[:search].present?
        Practitioner.where_name_is_like(params[:search])
      else
        Practitioner.all
      end

    query = query
      .where(public_figure: true)
      .order(created_at: :desc)
      .includes(:styles_learned, :styles_taught)

    @pagy, @practitioners = pagy(query)
    @pagy_metadata = @pagy.data_hash
  end

  # GET /practitioners/1 or /practitioners/1.json
  def show
    respond_to do |format|
      # TODO: fix: turbo_stream not called
      format.turbo_stream { render turbo_stream: turbo_stream.update(:practitioner_info, partial: "practitioners/profile", locals: { practitioner: @practitioner }) }
      format.html { build_tree }
      format.json { build_tree }
    end
  end

  # GET /practitioners/new
  def new
    @practitioner = Practitioner.new(public_figure: true)
  end

  # GET /practitioners/1/edit
  def edit
    render_unauthorized and return unless can? :edit, @practitioner
  end

  # POST /practitioners or /practitioners.json
  def create
    created_style = Style.find_by(name: practitioner_params.delete(:created_style))
    @practitioner = Practitioner.new(practitioner_params.merge(created_style: created_style))
    @practitioner.added_by = current_user
    @practitioner.user = current_user if params[:practitioner][:me] == "1" && current_user.practitioner.blank?

    respond_to do |format|
      if @practitioner.save
        format.html { redirect_to practitioner_url(@practitioner), notice: "Practitioner was successfully created." }
        format.json { render :show, status: :created, location: @practitioner }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @practitioner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /practitioners/1 or /practitioners/1.json
  def update
    render_unauthorized and return unless can? :edit, @practitioner

    created_style_id_or_name = practitioner_params.delete(:created_style)
    created_style =
      if created_style_id_or_name.blank?
        nil
      elsif created_style_id_or_name.to_i > 0
        Style.find(created_style_id_or_name)
      else
        Style.find_or_create_by(name: created_style_id_or_name)
      end

    @practitioner.user = current_user if params[:practitioner][:me] == "1" && current_user.practitioner.blank?
    @practitioner.assign_attributes(practitioner_params.merge(created_style: created_style))

    respond_to do |format|
      if @practitioner.save
        format.html { redirect_to practitioner_url(@practitioner), notice: "Practitioner was successfully updated." }
        format.json { render :show, status: :ok, location: @practitioner }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @practitioner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /practitioners/1 or /practitioners/1.json
  def destroy
    render_unauthorized and return unless can? :delete, @practitioner

    @practitioner.destroy

    respond_to do |format|
      format.html { redirect_to practitioners_url, notice: "Practitioner was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_practitioner
    @practitioner = Practitioner.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def practitioner_params
    params.require(:practitioner).permit(
      :name,
      :created_style,
      :country_code,
      :public_figure,
    )
  end

  def build_tree
    @mode = params[:mode]&.to_sym
    @mode ||= @practitioner.created_style.present? ? :root : :leaves
    @style = Style.find_by(name: params[:style]) if params[:style]
    @style ||= begin
      if @mode == :leaves
        @practitioner.styles.first
      else
        @practitioner.created_style || @practitioner.styles.first
      end
    end
    @tree =Lineage::TreeBuilder.new(practitioners: [@practitioner], style: @style, mode: @mode).call
  end
end
