class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create

    if params[:post][:username].present? &&  params[:post][:password].present?
      browser = Watir::Browser.new
      browser.goto 'https://www.linkedin.com/login'
      browser.input(name: 'session_key').send_keys(params[:post][:username], :return)
      browser.input(name: 'session_password').send_keys(params[:post][:password], :return)
      sleep(1.minutes)

      pages = []
      (1..20).each do |num|
        if pages.present?
          sleep 2
          browser.scroll.from(1, 750).by(0, 10000)
          pages += browser.html
          browser.button(value: 'See new posts').click
        else
          sleep 1
          pages = browser.html
        end
      end
    end

    data=Nokogiri::HTML.parse(pages)
    temp = []
    total_pages = data.css(".scaffold-layout__main")
    total_pages.each do |cards|
      cards.css(".feed-shared-update-v2").each do |card|
        @post = Post.new(post_params)
        @title = card&.css(".update-components-actor__title")&.css(".update-components-actor__name span")&.first&.text
        @content = card.css(".update-components-text").css(".break-words span").first&.text
        @image = card.css(".ivm-image-view-model").css(".ivm-view-attr__img--centered").last.attr("src")
        @video = card.css(".media-player").css("video").attr("src")&.value
        @iframe = card.css("iframe").attr("src")&.value

        @post.title = @title if @title.present?
        @post.content = @content if @content.present?
        @post.image = @image if @image.present?
        @post.name = @video if @video.present?
        temp << @post.save
      end
    end

    respond_to do |format|
      if temp
        format.html { redirect_to posts_url, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:name, :title, :content, :image)
    end
end
