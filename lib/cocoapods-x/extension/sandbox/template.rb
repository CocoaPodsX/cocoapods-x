require 'cocoapods-x/extension/sandbox/protocol'

module Pod
    module X
        class Sandbox
            class Template < Pod::Sandbox

                include Pod::X::Sandbox::Protocol

                def initialize url
                    super File.join(url, '.template')
                end

                def install!
                    unless verify_files
                        update!
                    end
                end

                def update!
                    rm! ['-rf', root]
                    clone_template! root
                end

                def source_file
                    root + 'Projects/podfile/sources'
                end

                def pods_file
                    root + 'Projects/podfile/pods'
                end

                def ios_template
                    root + 'Projects/ios'
                end

                def xcbuild
                    root + 'Projects/xcbuild'
                end

                def configure
                    root + 'configure'
                end

                private

                def verify_files 
                    valid = true
                    if !source_file.exist?
                        valid = false
                    elsif !pods_file.exist?
                        valid = false
                    elsif !ios_template.exist? || ios_template.empty?
                        valid = false
                    elsif !configure.exist?
                        valid = false
                    elsif !(root + '.git').exist? || (root + '.git').empty?
                        valid = false
                    end
                    valid
                end

                def clone_template! to
                    repo_url = 'https://github.com/CocoaPodsX/project-template.git'
                    UI.section('Pod::X '.blue + "Cloning `#{repo_url}`.") do
                        git! ['clone', '--depth=1', repo_url, to]
                    end
                    
                    unless verify_files
                        raise Informative, "Clone failed."
                    end
                end
                
            end
        end
    end
end
