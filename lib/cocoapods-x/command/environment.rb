require 'cocoapods-x/command/environment/init'
require 'cocoapods-x/command/environment/install'
require 'cocoapods-x/command/environment/update'

module Pod
    class Command
        class X < Command
            class Env < X

                self.abstract_command = true
                self.summary = 'Cocoapods X Environment.'

            end
        end
    end
end
  