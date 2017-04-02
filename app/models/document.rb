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
    return unless widget_id.nil?
    # TODO Add to background job
    mf_document = Mifiel::Document.create(
      hash: hsh,
      name: 'document.pdf',
      callback_url: Rails.application.secrets.mifiel_callback_url,
      signatories: users_params
    )
    self.widget_id = mf_document.widget_id
    self.document_id = mf_document.id
  end

  def users_params
    # Test widget integration without real info
    # users_set = users.select(:name, :email, :tax_id)
    # ary = JSON.parse(users_set.to_json)
    # ary.map{|e| e.delete_if{|k, v| k == 'id'} }
    [
      {
        name: 'Luis',
        email: 'luisguzman02@hotmail.com'
      },
      {
        name: 'Luis',
        email: 'luisguzman@outlook.com'
      }
    ]
  end

  %w(xml pdf).each do |action|
    define_method "#{action}_path" do
      Rails.root.join("public/data/document-#{id}.#{action}")
    end
  end
end
