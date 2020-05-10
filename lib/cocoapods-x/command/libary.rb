require 'cocoapods-x/command/libary/build'
require 'cocoapods-x/command/libary/create'

module Pod
    class Command
        class X < Command
            class Lib < X

                self.abstract_command = true
                self.summary = 'Cocoapods Extension X Lib.'

            end
        end
    end
end
  