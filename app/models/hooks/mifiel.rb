module Hooks
  class Mifiel
    attr_accessor :response, :head, :document

    def initialize(params)
      self.response = params
      default_head
    end

    def default_head
      self.head = { status: 200, content_type: "text/plain" }
    end

    def fetch_files!
      self.document = Document.find_by_document_id(response.fetch(:id))
      # TODO add requests to background jobs
      mf_document = ::Mifiel::Document.find(document.document_id)
      mf_document.save_xml(document.xml_path)
      mf_document.save_file_signed(document.pdf_path)
    end

    def merge_files!
      merge_xml
      merge_pdf
    end

    def merge_xml
      doc = File.read(document.xml_path)
      xml = Nokogiri.XML(doc)
      xml.at(:file).content = document.pdf
      File.open(document.xml_path, 'w') { |f| f.puts xml.to_xml }
    end

    def merge_pdf
      File.open(document.pdf_path.to_s.gsub(/.pdf/, '-orig.pdf'), "wb") do |f|
        f.write(Base64.urlsafe_decode64(document.pdf))
      end
      doc = File.read(document.pdf_path)
      Prawn::Document.generate(document.pdf_path, template: document.pdf_path.to_s.gsub(/.pdf/, '-orig.pdf')) do |pdf|
        pdf.go_to_page(pdf.page_count)
        pdf.start_new_page(template: document.pdf_path)
      end
    end
  end
end
