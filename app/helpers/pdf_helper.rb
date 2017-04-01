module PdfHelper

  def files_received?(document)
    File.exists?(document.pdf_path) && File.exists?(document.xml_path)
  end
end
