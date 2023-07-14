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
    browser = Watir::Browser.new
    browser.goto 'https://daraz.pk'
    sleep 5
    browser.input(name: 'q').send_keys(params[:daraz][:title], :return)
    last = browser.elements(class: "ant-pagination-item").last.title.to_i

      pages = []
      (1..last).each do |num|
        if pages.present?
          sleep 5
          browser.li(title: "Next Page").click!  if browser.li(title: "Next Page").present?
          pages += browser.html
        else
          sleep 1
          pages = browser.html
        end
      end

      data=Nokogiri::HTML.parse(pages)

      products = data.css(".gridItem--Yd0sa")
      temp = []
      products.each do |product|
        @price = product.css(".price--NVB62")&.text.gsub('Rs.', '').gsub(',', '').strip
        @image = product.css(".mainPic--ehOdr img").attr("src")&.text
        @title = product.css(".title--wFj93 a")&.text
        if @price.to_i < params[:daraz][:price].to_i
          @daraz = Daraz.new(daraz_params)
          @daraz.title = @title if @title.present?
          @daraz.price = @price if @price.present?
          @daraz.images = @image if @image.present?
          temp << @daraz.save
        end
      end

    respond_to do |format|
      if temp
        format.html { redirect_to darazs_url, notice: "Daraz was successfully created." }
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
