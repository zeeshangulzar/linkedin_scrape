class ExpressesController < ApplicationController
  before_action :set_express, only: %i[ show edit update destroy ]

  # GET /expresses or /expresses.json
  def index
    @expresses = Express.all
  end

  # GET /expresses/1 or /expresses/1.json
  def show
  end

  # GET /expresses/new
  def new
    @express = Express.new
  end

  # GET /expresses/1/edit
  def edit
  end

  # POST /expresses or /expresses.json
  def create
    @express = Express.new(express_params)

    respond_to do |format|
      if @express.save
        format.html { redirect_to express_url(@express), notice: "Express was successfully created." }
        format.json { render :show, status: :created, location: @express }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @express.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expresses/1 or /expresses/1.json
  def update
    respond_to do |format|
      if @express.update(express_params)
        format.html { redirect_to express_url(@express), notice: "Express was successfully updated." }
        format.json { render :show, status: :ok, location: @express }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @express.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expresses/1 or /expresses/1.json
  def destroy
    @express.destroy

    respond_to do |format|
      format.html { redirect_to expresses_url, notice: "Express was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_express
      @express = Express.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def express_params
      params.fetch(:express, {})
    end
end
