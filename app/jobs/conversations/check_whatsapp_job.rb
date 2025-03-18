class Conversations::CheckWhatsappJob < ApplicationJob
  queue_as :critical

  def perform(contact)
    require 'net/http'
    result = Net::HTTP.get(URI.parse('https://penguin.thenoisyplace.com/check/'+contact.phone_number))

    if(result == "1")
      contact.update(custom_attributes: contact.custom_attributes.merge({"whatsapp": "1"}))
    end
  end

end
