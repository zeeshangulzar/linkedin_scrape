class DarazsController < ApplicationController
  before_action :set_daraz, only: %i[ show edit update destroy ]

  # GET /darazs or /darazs.json
  def index
    @darazs = Daraz.all
  end

  # GET /darazs/1 or /darazs/1.json
  def show
  end

  # GET /darazs/new
  def new
    @daraz = Daraz.new
  end

  # GET /darazs/1/edit
  def edit
  end

  # POST /darazs or /darazs.json
  def create
    @daraz = Daraz.new(daraz_params)

    respond_to do |format|
      if @daraz.save
        format.html { redirect_to daraz_url(@daraz), notice: "Daraz was successfully created." }
        format.json { render :show, status: :created, location: @daraz }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @daraz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /darazs/1 or /darazs/1.json
  def update
    respond_to do |format|
      if @daraz.update(daraz_params)
        format.html { redirect_to daraz_url(@daraz), notice: "Daraz was successfully updated." }
        format.json { render :show, status: :ok, location: @daraz }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @daraz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /darazs/1 or /darazs/1.json
  def destroy
    @daraz.destroy

    respond_to do |format|
      format.html { redirect_to darazs_url, notice: "Daraz was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_daraz
      @daraz = Daraz.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def daraz_params
      params.require(:daraz).permit(:title, :body, :price, :images)
    end
end
