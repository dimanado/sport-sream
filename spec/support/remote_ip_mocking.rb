module ActionDispatch
  class Request

    def remote_ip_with_mocking
      test_ip = ENV['RAILS_TEST_IP_ADDRESS']
      test_ip.present? ? test_ip : remote_ip_without_mocking
    end

    alias_method_chain :remote_ip, :mocking

  end
end
