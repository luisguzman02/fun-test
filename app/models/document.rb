class Document < ApplicationRecord

  attr_accessor :text

  def generate_pdf!
    pdf_file = Prawn::Document.new
    pdf_file.text self.text
    self.pdf = Base64.urlsafe_encode64(pdf_file.render)
    self.hsh = Digest::SHA256.hexdigest pdf_file.render
    send_pdf
  end

  def send_pdf
    mf_document = Mifiel::Document.create(
      hash: hsh,
      name: 'document.pdf',
      callback_url: 'http://fun.wero.ultrahook.com',
      signatories: [
        {
          name: 'Luis Guzman',
          email: 'luisguzman02@hotmail.com'
        },
        {
          name: 'Alberto Acosta',
          email: 'luisguzman@outlook.com'
        }
      ]
    )
    self.widget_id = mf_document.widget_id
  end
end
