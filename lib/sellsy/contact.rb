require 'multi_json'

module Sellsy
  class Contact
    attr_accessor :id, :title, :name, :first_name, :last_name, :third_id, :email, :telephone, :mobile, :fax, :website,
                  :role, :birth_date

    def create
      command = {
          'method' => 'Peoples.create',
          'params' => {
              'people' => to_params
          }
      }

      response = MultiJson.load(Sellsy::Api.request command)

      @id = response['response']['id'] if response['response']

      response['status'] == 'success'
    end

    def self.find(people_id)
      command = {
          'method' => 'Peoples.getOne',
          'params' => {
              'id' => people_id
          }
      }

      response = MultiJson.load(Sellsy::Api.request command)
      contact = Contact.new

      if response['response']
        value = response['response']
        contact.id = value['id']
      end

      contact
    end

    def self.find_by_contact(contact_id)
      command = {
          'method' => 'Peoples.getOne',
          'params' => {
              'thirdcontactid' => contact_id
          }
      }

      response = MultiJson.load(Sellsy::Api.request command)
      contact = Contact.new

      if response['response']
        value = response['response']
        contact.id = value['id']
      end

      contact
    end

    def to_params
      {
        'civil' => civil_enum(@title),
        'name' => @last_name || @name,
        'forename' => @first_name,
        'email' => @email,
        'tel' => @telephone,
        'fax' => @fax,
        'mobile' => @mobile,
        'web' => @website,
        'position' => @role,
        'birthdate' => @birth_date.blank? ? '' : Date.parse(@birth_date).to_datetime.to_i,
        'thirdids' => @third_id.blank? ? nil : [@third_id]
      }
    end

    def get_addresses
      command = {
          'method' => 'Peoples.getAddresses',
          'params' => {
              'id' => id
          }
      }

      response = MultiJson.load(Sellsy::Api.request command)
      client = Contact.new

      if response['response']
        value = response['response']
        client.id = value['id']
      end

      client
    end

    private

    def civil_enum(val)
      case val
      when 'M.'
        'man'
      when 'Mme'
        'woman'
      else
        nil
      end
    end
  end
end
