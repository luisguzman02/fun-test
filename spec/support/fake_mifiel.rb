require 'sinatra/base'

class FakeMifiel < Sinatra::Base

  post '/api/v1/documents' do
    content_type :json
    status 200
    document.to_json
  end

  get '/api/v1/documents/:id' do
    json_response 200, 'document.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
    # document.to_json
  end

  def document(signed = false, status = [0, "Esperando firmas"])
    {
      "id": "29f3cb01-744d-4eae-8718-213aec8a1678",
      "original_hash": "e1a580c27d22b4...c537bf90282a6889da",
      "file_file_name": "test-pdf.pdf",
      "signed_by_all": true,
      "signed": signed,
      "signed_at": "",
      "status": status,
      "widget_id": "29f3cb01-744d-4eae-8718-213aec8a1678",
      "owner": {
        "email": "signer1@email.com",
        "name": "Jorge Morales"
      },
      "callback_url": "https://www.example.com/webhook/url",
      "file": "/api/v1/documents/.../file",
      "file_download": "/api/v1/documents/.../file?download=true",
      "file_signed": "/api/v1/documents/.../file_signed",
      "file_signed_download": "/api/v1/documents/.../file_signed?download=true",
      "file_zipped": "/api/v1/documents/.../zip",
      "signatures": [{
        "email": "signer1@email.com",
        "signed": true,
        "signed_at": "2016-01-19T16:34:37.887Z",
        "certificate_number": "20001000000200001410",
        "tax_id": "AAA010101AAA",
        "signature": "77cd5156779c..4e276ef1056c1de11b7f70bed28",
        "user": {
          "email": "signer1@email.com",
          "name": "Jorge Morales"
        }
      }]
    }
  end
end
