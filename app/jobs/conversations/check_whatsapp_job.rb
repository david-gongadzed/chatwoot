class Conversations::CheckWhatsappJob < ApplicationJob
  queue_as :critical

  def perform(contact)
    require 'net/http'
    result = Net::HTTP.get(URI.parse('http://95.179.151.239/check/'+contact.phone_number))

    if(result == "1")
      contact.update(custom_attributes: contact.custom_attributes.merge({"whatsapp": "1"}))
    end
  end

end
