require 'rails_helper'

RSpec.describe Document, type: :model do

  context "with pdf info" do
    let!(:document) { Document.new(text: 'some text') }

    it "generates pdf from text" do
      pdf = Prawn::Document.new(text: 'some text')
      document.generate_pdf!
      expect(document.pdf).not_to be_nil
      expect(document.hsh).not_to be_nil
    end

    it "sends pdf to mifiel" do
      document.generate_pdf!
      document.send_pdf
      expect(document.widget_id).not_to be_nil
    end
  end
end
