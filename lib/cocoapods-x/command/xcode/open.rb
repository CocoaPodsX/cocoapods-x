require 'cocoapods-x/extension/xcode/open'

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
                        xcopen = Pod::X::Xcode::Open::new
                        xcopen.run!
                    end

                end
            end
        end
    end
end