module PiholeApi
  class Client
    include ::PiholeApi::Constants

    # Endpoints
    include ::PiholeApi::UnauthorisedEndpoints

    attr_reader :password, :base_path, :port

    def initialize(base_path:, password:, port: 80)
      @password = password
      @base_path = base_path
      @port = port
    end

    def self.compatible_api_version
      'v3'
    end

    # This is the version of the API docs this client was built off-of
    def self.api_version
      'v2 2023-01-21'
    end

    private

    def authorise_and_send(http_method:, command:, payload: {}, params: {})
      start_time = micro_second_time_now

      if params.nil? || params.empty?
        params = {}
      end

      response = HTTParty.send(
        http_method.to_sym,
        construct_base_path(command, params),
        body: payload,
        headers: {
          'Access-Token': @access_token,
          'Content-Type': 'application/json',
          "Accept": 'application/json',
          "X-Pi-hole-Authenticate": password
        },
        port: port,
        format: :json
      )

      end_time = micro_second_time_now
      construct_response_object(response, path, start_time, end_time)
    end

    def construct_response_object(response, path, start_time, end_time)
      {
        'body' => parse_body(response, path),
        'headers' => response.headers,
        'metadata' => construct_metadata(response, start_time, end_time)
      }
    end

    def construct_metadata(response, start_time, end_time)
      total_time = end_time - start_time

      {
        'start_time' => start_time,
        'end_time' => end_time,
        'total_time' => total_time,
        'cursor' => response.dig('cursor')
      }
    end

    def body_is_present?(response)
      !body_is_missing?(response)
    end

    def body_is_missing?(response)
      response.body.nil? || response.body.empty?
    end

    def parse_body(response, path)
      parsed_response = JSON.parse(response.body) # Purposely not using HTTParty
      parsed_response[path.to_s] || parsed_response
    rescue JSON::ParserError => _e
      response.body
    end

    def micro_second_time_now
      (Time.now.to_f * 1_000_000).to_i
    end

    def construct_base_path(command, params)
      constructed_path = "#{base_path}/#{API_PATH}?#{command}"

      if params == {}
        constructed_path
      else
        "#{constructed_path}&#{process_params(params)}"
      end
    end

    def process_params(params)
      params.keys.map { |key| "#{key}=#{params[key]}" }.join('&')
    end

    def process_cursor(cursor, params: {})
      unless cursor.nil? || cursor.empty?
        params['cursor'] = cursor
      end

      params
    end
  end
end
