require 'multi_json'

module Sellsy
  class Opportunity
    attr_accessor :id
    attr_accessor :name, :type, :joindate, :email

    #   def create
    #     command = {
    #         'method' => 'Client.create',
    #         'params' => {
    #             'third' => {
    #                 'name'			=> @name,
    #                 'joindate'	    => @joindate,
    #                 'type'			=> @type,
    #                 'email'			=> @email
    #             }
    #         }
    #     }

    #     response = MultiJson.load(Sellsy::Api.request command)

    #     @id = response['response']['client_id'] if response['response']

    #     return response['status'] == 'success'
    #   end

    #   def update

    #   end
    # end

    # class Opportunities
    # def self.find(id)
    #   command = {
    #       'method' => 'Client.getOne',
    #       'params' => {
    #           'clientid' => id
    #       }
    #   }

    #   response = MultiJson.load(Sellsy::Api.request command)

    #   client = Client.new

    #   if response['response']
    #     value = response['response']['client']
    #     client.id = value['id']
    #     client.name = value['name']
    #     client.joindate = value['joindate']
    #     client.type = value['type']
    #   end

    #   return client
    # end

    def self.search(params)
      command = {
          'method' => 'Opportunities.getList',
          'params' => params
      }

      response = MultiJson.load(Sellsy::Api.request command)

      opportunities = []
      if response['response']
        response['response']['result'].each do |key, value|
          opportunity = Opportunity.new
          opportunity.id = key
          opportunity.status = value['status']
          opportunity.name = value['name']
          opportunity.ident = value['ident']
          opportunity.signed = value['signed']
          opportunity.linkedid = value['linkedid']
          opportunities << opportunity
        end
      end

      opportunities
    end

    def self.all
      command = {
          'method' => 'Opportunities.getList',
          'params' => {}
      }

      response = MultiJson.load(Sellsy::Api.request command)

      opportunities = []
      if response['response']
        response['response']['result'].each do |key, value|
          opportunity = Opportunity.new
          opportunity.id = key
          opportunity.status = value['status']
          opportunity.name = value['name']
          opportunity.ident = value['ident']
          opportunity.signed = value['signed']
          opportunity.linkedid = value['linkedid']
          opportunities << opportunity
        end
      end

      opportunities
    end
  end
end
