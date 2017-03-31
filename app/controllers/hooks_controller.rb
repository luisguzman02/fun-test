class HooksController < ApplicationController

  def mifiel
    Rails.logger.info params
  end
end
