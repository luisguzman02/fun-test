class HooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def mifiel
    hook = Hooks::Mifiel.new(params)
    hook.fetch_files!
    hook.merge_files!
    head hook.head
  end
end
