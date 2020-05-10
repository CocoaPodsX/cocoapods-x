module Pod
    class Command
        class X < Command
            class XC < X
                class Open < XC

                    self.summary = 'Open current dir xcodeproj or xcworkspace.'

                    self.description = 'Open current dir xcodeproj or xcworkspace.'

                    def initialize(argv)
                        super
                    end

                    def run 
                        urls_w = Dir[File.join(Dir.pwd, "*.xcworkspace")] 
                        urls_p = Dir[File.join(Dir.pwd, "*.xcodeproj")]
                        urls = urls_w + urls_p
                        if urls_w.size == 1
                            openxc(urls_w[0])
                        elsif urls_p.size == 1
                            openxc(urls_p[0])
                        elsif urls.size > 0
                            choices = urls.map { |l| File.basename(l) }
                            begin
                                index = UI.choose_from_array(choices, 'Which file do you want to open?')
                                openxc(urls[index])
                            rescue => exception
                                UI.puts "[!] #{exception}".red
                            end
                        else
                            openxc('/Applications/Xcode.app')
                        end
                    end

                    private

                    extend Executable
                    executable :open
    
                    def openxc url
                        UI.section("Opening #{File.basename(url)}.") do
                            open! [url]
                        end
                    end

                end
            end
        end
    end
end