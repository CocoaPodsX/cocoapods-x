require 'cocoapods-x/command/edit'
require 'cocoapods-x/command/environment'
require 'cocoapods-x/command/install'
require 'cocoapods-x/command/libary'
require 'cocoapods-x/command/repos'
require 'cocoapods-x/command/update'
require 'cocoapods-x/command/xcode'

module Pod
    class Command
        class X < Command

            self.abstract_command = true
            self.summary = 'Cocoapods Extension X.'

        end
    end
end