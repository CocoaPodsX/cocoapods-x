require 'cocoapods-x/extension/sandbox'
require 'cocoapods-x/extension/environment'

module Pod
    class Command
        class X < Command
            class Edit < X

                self.summary = 'Cocoapods X Edit.'
                self.description = <<-DESC
                NAME is 'pods' edit pods file,\n
                NAME is 'sources' edit source file,\n
                NAME is 'podfile' edit Podfile file.
                DESC

                self.arguments = [
                   CLAide::Argument.new('NAME', true),
                ]

                def initialize(argv)
                    @name = argv.shift_argument
                    super
                end

                def run
                    if @name == 'pods'
                        open_pods!
                    elsif @name == 'sources'
                        open_source!
                    elsif @name == 'Podfile'
                        open_podfile!
                    else
                        self.help!
                    end
                end

                private

                extend Executable
                executable :open

                def open_pods!
                    project = Pod::X::Environment::init!
                    open_ide! project.pods_file
                end

                def open_source!
                    workspace = Pod::X::Environment::install!
                    open_ide! workspace.source_file
                end

                def open_podfile!
                    project_url = Pathname(Dir.pwd)
                    podfile = Pod::X::Sandbox::podfile_exists! project_url
                    open_ide! podfile
                end

                private

                def open_ide! url 
                    ide = sel_ide
                    if ide
                        open! ['-a', ide, url]
                    else
                        open! [url]
                    end
                end

                def sel_ide
                    ides = ['/Applications/Visual Studio Code.app', '/Applications/Sublime Text.app', '/Applications/Xcode.app']
                    ides.each do |i|
                        path = Pathname(i)
                        return path if path.exist?
                    end
                    nil
                end

            end
        end
    end
end