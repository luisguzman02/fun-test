class PdfController < ApplicationController
  before_action :set_document, only: :signature

  def create
    doc = Document.new(document_params.merge(text: render_to_string(partial: '/home/billing')))
    doc.generate_pdf!
    if doc.save
      redirect_to signature_pdf_path(id: doc.id)
    else
      redirect_to root_path, message: 'Failed to generate pdf'
    end
  end

  def signature
    Rails.logger.info params
  end

  private
  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(users_attributes: [:name, :email, :tax_id])
  end
end
