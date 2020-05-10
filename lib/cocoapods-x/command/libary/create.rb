require 'cocoapods-x/extension/sandbox'

module Pod
    class Command
        class X < Command
            class Lib < X
                class Create < Lib

                    extend Executable
                    executable :rm

                    self.summary = 'Creates a new project'
                    self.description = <<-DESC
                    Creates a scaffold for the development of a new project named `NAME`.
                    DESC

                    self.arguments = [
                        CLAide::Argument.new('NAME', true),
                    ]

                    def initialize(argv)
                        @name = argv.shift_argument
                        super
                    end

                    def run
                        project_name = @name
                        target_url = File.join(Dir::pwd, project_name)
                        configure_url = Pod::X::Sandbox::workspace::template::configure
                        template_url = Pod::X::Sandbox::workspace::template::ios_template
                        if Dir::exist?(target_url) && !Dir::empty?(target_url)
                            UI.puts "fatal: destination path '#{project_name}' already exists and is not an empty directory.".red
                        else
                            rm! ['-rf', target_url]
                            if !template_url.exist? 
                                Pod::X::Sandbox::update!
                            end
                            UI.section("Configuring #{project_name} template.") do
                                system('ruby', configure_url.to_s, template_url.to_s, target_url.to_s, project_name.to_s)
                            end
                        end

                    end
                    
                end
            end
        end
    end
end