module Sellsy
  class Attachment
    attr_accessor :id, :entity_id, :entity_type, :file

    def create
      command = {
          'method' => 'Briefcases.uploadFile',
          'params' => {
              'linkedtype' => @entity_type,
              'linkedid' => @entity_id
          }
      }

      response = MultiJson.load(Sellsy::Api.request(command, file))
      @id = response['response']
      response['status'] == 'success'
    end
  end
end