require 'cocoapods-x/extension/sandbox'

module Pod
    class Command
        class X < Command
            class XC < X
                class Clean < XC

                    self.summary = 'Remove the cache for xcode.'

                    self.description = <<-DESC
                        Remove 'Pods' 'Podfile.lock' 'DerivedData'.
          
                        If there is multiple cache for various versions of the requested item,
                        you will be asked which one to clean. Use `--all` to clean them all.
                    DESC
            
                    def self.options
                        [
                            ['--all', 'Remove all the cached without asking']
                        ].concat(super)
                    end

                    def initialize(argv)
                        @cache_files = Pod::X::Sandbox::xcode_cachefiles
                        @wipe_all = argv.flag?('all')
                        super
                    end

                    def run
                        if @wipe_all
                            remove_files ['Pods', 'Podfile.lock', 'DerivedData']
                        else
                            begin
                                choices = ['Pods', 'Podfile.lock', 'Pods and Podfile.lock', 'DerivedData', 'All']
                                index = UI.choose_from_array(choices, 'Which item do you want to remove?')
                                case index
                                when 0
                                    remove_files ['Pods']
                                when 1
                                    remove_files ['Podfile.lock']
                                when 2
                                    remove_files ['Pods', 'Podfile.lock']
                                when 3
                                    remove_files ['DerivedData']
                                when 4
                                    remove_files ['Pods', 'Podfile.lock', 'DerivedData']
                                end
                            rescue => exception
                                UI.puts "[!] #{exception}".red
                            end
                        end
                    end
                    
                    private 

                    extend Executable
                    executable :rm
                    
                    def remove_files files
                        files.each do |file| 
                            url = @cache_files[file]
                            unless url.nil?
                                UI.section("Removing #{file} => #{url}.") do
                                    rm! ['-rf', url]
                                end
                            end
                        end
                    end

                end
            end
        end
    end
end