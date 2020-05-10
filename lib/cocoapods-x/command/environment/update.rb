require 'cocoapods-x/extension/environment'

module Pod
    class Command
        class X < Command
            class Env < X
                class Update < Env

                    self.summary = 'Update X environment.'
                    self.description = 'Update X environment.'
    
                    def initialize(argv)
                        super
                    end
    
                    def run
                        begin
                            UI.puts "Updating X environment."
                            Pod::X::Environment::update!
                            UI.puts "Pod::X Env installation complete!".green
                        rescue => exception
                            puts "[!] Pod::X #{exception}".red
                        end
                    end

                end
            end
        end
    end
end