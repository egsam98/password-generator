module Api
  module Controllers
    module Password
      class Index
        include Api::Action

        params { required(:length).filled(:int?) }

        def call(params)
          self.format = :json
          unless params.valid?
            self.status = 400
            return self.body = params.errors.to_json
          end

          GeneratePassword.new.call(length: params[:length].to_i) do |type|
            type.success { |result| self.body = result.to_json }

            type.failure :words_exist? do |err|
              self.status = 500
              Hanami::Logger.new.error err
            end

            type.failure do |err|
              self.status = 400
              self.body = { error: err }.to_json
            end
          end
        end
      end
    end
  end
end
