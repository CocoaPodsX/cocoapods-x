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
                            UI.puts 'Pod::X '.magenta + "Initing X environment."
                            project = Pod::X::Environment::init!
                            UI.puts 'Pod::X '.magenta + "'#{project.project_name}' initialization complete!".green
                        rescue => exception
                            UI.puts '[!] Pod::X '.magenta + "#{exception}".red
                        end
                    end
                end
            end
        end
    end
end