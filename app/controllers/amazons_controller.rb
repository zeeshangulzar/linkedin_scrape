class AmazonsController < ApplicationController
  before_action :set_amazon, only: %i[ show edit update destroy ]

  # GET /amazons or /amazons.json
  def index
    @amazons = Amazon.all
  end

  # GET /amazons/1 or /amazons/1.json
  def show
  end

  # GET /amazons/new
  def new
    @amazon = Amazon.new
  end

  # GET /amazons/1/edit
  def edit
  end

  # POST /amazons or /amazons.json
  def create
    @amazon = Amazon.new(amazon_params)

    respond_to do |format|
      if @amazon.save
        format.html { redirect_to amazon_url(@amazon), notice: "Amazon was successfully created." }
        format.json { render :show, status: :created, location: @amazon }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @amazon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /amazons/1 or /amazons/1.json
  def update
    respond_to do |format|
      if @amazon.update(amazon_params)
        format.html { redirect_to amazon_url(@amazon), notice: "Amazon was successfully updated." }
        format.json { render :show, status: :ok, location: @amazon }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @amazon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /amazons/1 or /amazons/1.json
  def destroy
    @amazon.destroy

    respond_to do |format|
      format.html { redirect_to amazons_url, notice: "Amazon was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_amazon
      @amazon = Amazon.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def amazon_params
      params.fetch(:amazon, {})
    end
end
