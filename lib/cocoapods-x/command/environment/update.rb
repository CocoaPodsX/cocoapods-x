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
                            UI.puts 'Pod::X '.blue + "Updating X environment."
                            Pod::X::Environment::update!
                            UI.puts 'Pod::X '.blue + "Env installation complete!".green
                        rescue => exception
                            UI.puts '[!] Pod::X '.blue + "#{exception}".red
                        end
                    end

                end
            end
        end
    end
end