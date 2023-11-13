class HomeController < ApplicationController

  def index

  end

  def compair
   @amazons = Amazon.last(1)
   @expresses = Express.last(1)
  end
end
