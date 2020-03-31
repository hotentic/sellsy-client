require 'multi_json'

module Sellsy
  class Contact
    attr_accessor :id, :title, :name, :first_name, :last_name, :third_ids, :email, :telephone, :mobile, :fax, :website,
                  :role, :birth_date, :linked_type, :linked_id

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

    def update
      command = {
          'method' => 'Peoples.update',
          'params' => {
              'id' => @id,
              'people' => to_params
          }
      }

      response = MultiJson.load(Sellsy::Api.request command)
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

    def self.search(name, b_date)
      contacts = []

      unless name.blank? || b_date.blank?
        command = {
            'method' => 'Peoples.getList',
            'params' => {
                'search' => {
                    'contains' => name,
                    'birthdate' => b_date.blank? ? nil : Date.parse(b_date).to_datetime.to_i,
                }
            }
        }

        response = MultiJson.load(Sellsy::Api.request command)

        if response['response']
          response['response']['result'].each do |key, value|
            contact = Contact.new
            contact.id = key
            contact.linked_type = value['linkedtype']
            contact.linked_id = value['linkedid']
            contact.name = value['name']
            contact.first_name = value['forename']
            contact.third_ids = ((value['prospectList'] || []) + (value['thirdList'] || []) + (value['supplierList'] || [])).map {|e| e['id']}
            contacts << contact
          end
        end
      end

      contacts
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
        'thirdids' => @third_ids.blank? ? nil : @third_ids
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
