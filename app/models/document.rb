class Document < ApplicationRecord

  attr_accessor :text

  has_many :users, through: :signatures
  has_many :signatures
  accepts_nested_attributes_for :users, allow_destroy: true

  before_save :send_pdf

  def generate_pdf!
    pdf_file = Prawn::Document.new
    pdf_file.text self.text
    self.pdf = Base64.urlsafe_encode64(pdf_file.render)
    self.hsh = Digest::SHA256.hexdigest pdf_file.render
  end

  def send_pdf
    mf_document = Mifiel::Document.create(
      hash: hsh,
      name: 'document.pdf',
      callback_url: 'http://fun.wero.ultrahook.com',
      signatories: JSON.parse(users.select(:name, :email, :tax_id).to_json)
    )
    self.widget_id = mf_document.widget_id
  end
end
