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
                            UI.puts "Pod::X Installing X environment."
                            Pod::X::Environment::install!
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