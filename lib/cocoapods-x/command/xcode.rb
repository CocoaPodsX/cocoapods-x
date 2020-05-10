require 'cocoapods-x/command/xcode/clean'
require 'cocoapods-x/command/xcode/open'

module Pod
    class Command
        class X < Command
            class XC < X

                self.abstract_command = true
                self.summary = 'Cocoapods X Xcode.'

            end
        end
    end
end