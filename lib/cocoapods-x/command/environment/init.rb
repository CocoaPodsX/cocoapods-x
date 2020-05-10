require 'cocoapods-x/extension/environment'

module Pod
    class Command
        class X < Command
            class Env < X
                class Init < Env

                    self.summary = 'Init project X environment.'
                    self.description = 'Init project X environment.'
    
                    def initialize(argv)
                        super
                    end
    
                    def run
                        begin
                            UI.puts "Initing X environment."
                            project = Pod::X::Environment::init!

                            UI.puts "Pod::X '#{project.project_name}' initialization complete!".green
                        rescue => exception
                            puts "[!] Pod::X #{exception}".red
                        end
                    end
                end
            end
        end
    end
end