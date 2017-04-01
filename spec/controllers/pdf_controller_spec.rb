require 'rails_helper'

RSpec.describe PdfController, type: :controller do
  let(:users_attributes) { { users_attributes: [name: 'Tester', email: 'tester@tests.com', tax_id: 'AAA010101AAA'] } }
  let(:document_params) { { document: users_attributes } }
  describe "POST create" do
    it "creates pdf from partial" do
      post :create, params: document_params
      expect(Document.count).to eq(1)
    end

    it "redirects to document signatures" do
      post :create, params: document_params
      doc = Document.first
      expect(response).to redirect_to(signature_pdf_path(id: doc))
    end
  end

  describe "GET signature" do
    let(:document) do
      doc = Document.new(users_attributes.merge(text: 'some text'))
      doc.generate_pdf!
      doc.save
      doc
    end
    context "when document is not signed" do
      it "assigns @document" do
        get :signature, params: { id: document.id }
        expect(assigns(:document)).to eq(document)
      end

      it "renders signature view" do

        get :signature, params: { id: document.id }
        expect(response).to render_template("signature")
      end
    end
  end

  # def document_params
  #   { document: { users_attributes: [name: 'Tester', email: 'tester@tests.com', tax_id: 'AAA010101AAA'] } }
  # end
end
