require 'cocoapods-x/extension/sandbox/project'
require 'cocoapods-x/extension/sandbox/projects'
require 'cocoapods-x/extension/sandbox/protocol'
require 'cocoapods-x/extension/sandbox/repos'
require 'cocoapods-x/extension/sandbox/template'
require 'cocoapods-x/extension/sandbox/workspace'

module Pod
    module X
        class Sandbox

            include Pod::X::Sandbox::Protocol

            def self.workspace
                @@workspace ||= Pod::X::Sandbox::Workspace::new
                @@workspace
            end

            def self.install!
                Pod::X::Sandbox::workspace::install!
            end

            def self.update!
                Pod::X::Sandbox::workspace::update!
            end

            def self.podfile_exists! dir
                podfile = Pod::X::Sandbox::find_podfile(dir)
                if podfile.nil?
                    raise Informative, "No `Podfile' found in the project directory."
                end
                podfile
            end

            def self.find_podfile dir
                PODFILE_NAMES.each do |filename|
                    candidate = dir + filename
                    if candidate.file?
                        return candidate
                    end
                end
                nil
            end

            def self.xcode_cachefiles
                XCODE_POD_CACHEFILE
            end

            PODFILE_NAMES = [
                'CocoaPods.podfile.yaml',
                'CocoaPods.podfile',
                'Podfile',
                'Podfile.rb',
            ].freeze

            XCODE_POD_CACHEFILE = {
                'Pods' => File.join(Dir.pwd, 'Pods'),
                'Podfile.lock' => File.join(Dir.pwd, 'Podfile.lock'),
                'DerivedData' => File.join(File.expand_path('~'), 'Library/Developer/Xcode/DerivedData'),
            }.freeze
            
        end
    end
end