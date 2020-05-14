module Pod
    module X
        class Xcode
            class Open

                extend Executable
                executable :open

                def initialize
                    @urls_w = Dir[File.join(Dir.pwd, "*.xcworkspace")] 
                    @urls_p = Dir[File.join(Dir.pwd, "*.xcodeproj")]
                    @urls = @urls_w + @urls_p
                    super
                end

                def run!
                    if @urls_w.size == 1
                        openxc!(@urls_w[0])
                    elsif @urls_p.size == 1
                        openxc!(@urls_p[0])
                    elsif @urls.size > 0
                        choices = @urls.map { |l| File.basename(l) }
                        begin
                            index = UI.choose_from_array(choices, 'Which file do you want to open?')
                            openxc!(urls[index])
                        rescue => exception
                            UI.puts '[!] Pod::X '.blue + "#{exception}".red
                        end
                    else
                        openxc!('/Applications/Xcode.app')
                    end

                end

                def openxc! url
                    UI.section('Pod::X '.blue + "Opening #{File.basename(url)}.") do
                        open! [url]
                    end
                end

            end
        end
    end
end