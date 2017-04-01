class PdfController < ApplicationController
  before_action :set_document, only: [:signature, :download]

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
    if check_signatures
      return render 'document'
    end
  end

  def download
    path = "#{Rails.root}/public/data/document-#{@document.id}.#{params[:format]}"
    send_file path, type: "application/pdf", x_sendfile: true
  end

  private
  def set_document
    @document = Document.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path if @document.nil?
  end

  def document_params
    params.require(:document).permit(users_attributes: [:name, :email, :tax_id])
  end

  def check_signatures
    mf_document = Mifiel::Document.find(@document.widget_id)
    mf_document.signed || !mf_document.status.first.zero?
  end
end
