module Sellsy
  class Attachment
    attr_accessor :file

    def create
      command = {
          'method' => 'Briefcases.uploadFile',
          'params' => {
              'linkedtype' => 'third',
              'linkedid' => '22757971'
          }
      }

      response = MultiJson.load(Sellsy::Api.request(command, file))
      @id = response['response']
      response['status'] == 'success'
    end
  end
end