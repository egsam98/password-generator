module Api
  module Controllers
    module Password
      class Index
        include Api::Action

        def call(_)
          result = GeneratePassword.new.call
          self.format = :json
          self.body = { password: result.password }.to_json
        end
      end
    end
  end
end
