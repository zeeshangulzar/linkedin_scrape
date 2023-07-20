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

    browser = Watir::Browser.new
    browser.goto 'https://aliexpress.com'
    sleep 5
    browser.input(name: 'SearchText').send_keys(params[:express][:title], :return)

    pages = []
    loop do
      if pages.present?
        sleep 3
        browser.scroll.from(8, 11).by(0, 5200)
        if browser.li(class: "next-next").present?
          browser.li(class: "next-next").click!
        else
          loop_break = true
        end
        pages += browser.html
      else
        sleep 1
        browser.scroll.from(8, 11).by(0, 5200)
        pages = browser.html
      end
      break if loop_break
    end

    data=Nokogiri::HTML.parse(pages)

    products = data.css("a.manhattan--container--1lP57Ag")
    temp = []
    products.each do |product|
      sleep 1
      @price = product.css(".manhattan--price--WvaUgDY").text.gsub('PKR', '').gsub(',', '').strip
      @image = product.css(".manhattan--image--1p6LxVV img").attr("src")&.text
      @title = product.css(".manhattan--titleText--WccSjUS").text
      if @image.present?
        @express = Express.new(express_params)
        @express.title = @title if @title.present?
        @express.price = @price if @price.present?
        @express.image = @image if @image.present?
        temp << @express.save
      end
    end

    respond_to do |format|
      if temp
        format.html { redirect_to expresses_url, notice: "Express was successfully created." }
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
      params.require(:express).permit(:title, :price, :image)
    end
end
