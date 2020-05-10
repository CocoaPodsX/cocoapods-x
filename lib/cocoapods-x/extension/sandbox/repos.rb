require 'cocoapods-x/extension/sandbox/protocol'

module Pod
    module X
        class Sandbox
            class Repos < Pod::Sandbox

                include Pod::X::Sandbox::Protocol

                def initialize url
                    super File.join(url, 'repos')
                end

                def install!
                    
                end

                def update!
                    
                end

                def pod_path! name, version, share, repo_url
                    host = hostname(repo_url)
                    to = root + "#{host}/#{name}"
                    to
                end

                def pod_path_clone! name, version, share, repo_url
                    to = pod_path!(name, version, share, repo_url)
                    rm! ['-rf', to]
                    pod_clone!(name, repo_url, to)
                    to
                end

                private

                def pod_clone! name, repo_url, to
                    UI.section("Pod::X Cloning #{name}.".green) do
                        git! ['clone', repo_url, to]
                    end
                    unless (to + '.git').exist?
                        raise Informative, "Clone failed."
                    end
                end

                def hostname source
                    if source.start_with? 'git@'
                        source = source.gsub ':', '/'
                        source = source.gsub 'git@', 'https://'
                    end
                    URI(source).hostname
                end

            end
        end
    end
end
