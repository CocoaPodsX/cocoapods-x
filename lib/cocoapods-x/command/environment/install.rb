require 'cocoapods-x/extension/environment'

module Pod
    class Command
        class X < Command
            class Env < X
                class Install < Env

                    self.summary = 'Install X environment.'
                    self.description = 'Install X environment.'
    
                    def initialize(argv)
                        super
                    end
    
                    def run
                        begin
                            UI.puts 'Pod::X '.blue + "Installing X environment."
                            Pod::X::Environment::install!
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