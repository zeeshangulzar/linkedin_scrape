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
    browser = Watir::Browser.new
    browser.goto 'https://amazon.com/'
    browser.input(name: 'field-keywords').send_keys(params[:amazon][:title], :return)

    pages = []
    loop do
      if pages.present?
        sleep 3
        browser.scroll.from(8, 11).by(0, 4200)
        if browser.a(class: "s-pagination-next").present?
          browser.a(class: "s-pagination-next").click!
        else
          loop_break = true
        end
        sleep 2
        pages += browser.html
      else
        sleep 1
        pages = browser.html
      end
      break if loop_break
    end

    data=Nokogiri::HTML.parse(pages)
    products = data.css(".s-card-container")

    temp = []
    products.each do |product|
      sleep 3
      @price = product.css(".a-price")&.children&.first&.text&.gsub(/[$,]/, '')
      @image = product.css(".s-list-col-left img").attr("src").text
      @title =  product.css(".a-text-normal").text
      if @image.present?
        @amazon = Amazon.new(amazon_params)
        @amazon.title = @title if @title.present?
        @amazon.price = @price if @price.present?
        @amazon.image = @image if @image.present?
        temp << @amazon.save
      end
    end

    respond_to do |format|
      if temp
        format.html { redirect_to amazons_url, notice: "Amazon was successfully created." }
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
      params.require(:amazon).permit(:title, :price, :image)
    end
end
