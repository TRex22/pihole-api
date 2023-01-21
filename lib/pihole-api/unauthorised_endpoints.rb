module PiholeApi
  module UnauthorisedEndpoints
    # These endpoints dont need to be authorised
    # https://discourse.pi-hole.net/t/pi-hole-api/1863

    def type
      command = 'type'
    end

    def version
      command = 'version'
    end

    def summary_raw
      command = 'summaryRaw'
    end

    def summary(params: {})
      command = 'summary'
      authorise_and_send(http_method: :get, command: command, params: params)
    end

    def over_time_data_10_mins
      command = 'overTimeData10mins'
    end
  end
end
