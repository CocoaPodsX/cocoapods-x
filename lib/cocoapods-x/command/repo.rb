module Pod
    class Command
        class X < Command
            class Repo < X

                self.summary = 'Opens pods dir.'
                self.description = <<-DESC
                Opens pods.
                DESC

                self.arguments = [
                    CLAide::Argument.new('NAME', true),
                ]

                def self.options
                    [
                        ['--terminal', 'Use terminal open pod']
                    ].concat(super)
                end

                def initialize(argv)
                    @name = argv.shift_argument
                    @wipe_terminal = argv.flag?('terminal')
                    super
                end

                def run
                    pods = Pod::X::Sandbox::workspace::all_pods
                    if !@name.nil? && @name.size > 0
                        pods = pods.select{ |pod| pod.name == @name }
                    end
                    open_pods pods
                end

                private

                extend Executable
                executable :open

                def open_pods pods
                    return if (pods.nil? || pods.size <= 0)

                    choices = Array::new
                    pods.each do |pod|
                        choice = pod.name
                        unless pod.branch.nil?
                            choice += " (#{pod.branch})".red
                        end
                        unless pod.project.nil?
                            choice += " => project: #{pod.project}"
                        end
                        choice += " => path: #{pod.location_url}"
                        choices << choice
                    end

                    begin
                        if choices.size == 1
                            index = 0
                        else
                            index = UI.choose_from_array(choices, 'Which item do you?')
                        end
                        url = pods[index].location_url
                        open_url! url
                    rescue => exception
                        UI.puts '[!] Pod::X '.blue + "#{exception}".red
                    end

                end

                def open_url! url 
                    ter = sel_ter
                    if @wipe_terminal && ter
                        open! ['-a', ter, url]
                    else
                        open! [url]
                    end
                end

                def sel_ter
                    ters = ['/Applications/iTerm.app', '/System/Applications/Utilities/Terminal.app']
                    ters.each do |t|
                        path = Pathname(t)
                        return path if path.exist?
                    end
                    nil
                end

            end
        end
    end
end