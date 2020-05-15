require 'cocoapods-x/extension/sandbox/protocol'

module Pod
    module X
        class Sandbox
            class Workspace < Pod::Sandbox

                include Pod::X::Sandbox::Protocol

                Repo = Struct::new(:name, :domain, :project, :location_url, :branch)

                attr_reader :repos, :template, :projects

                def initialize
                    super File.join(File.expand_path('~'), '.cocoapods/x')
                    @repos = Pod::X::Sandbox::Repos::new root
                    @template = Pod::X::Sandbox::Template::new root
                    @projects = Pod::X::Sandbox::Projects::new root
                end

                def install!
                    @repos.install!
                    @template.install! 
                    @projects.install!

                    unless source_file.exist?
                        cp! [@template::source_file, source_file]
                    end
                end

                def update!
                    @repos.update!
                    @template.update!
                    @projects.update!
                    
                    rm! ['-rf', source_file]
                    cp! [@template::source_file, source_file]
                end

                def source_file
                    root + 'sources'
                end

                def all_pods
                    all_pods = Array::new
                    for url in Dir.glob(@repos::root + '*/*') do
                        pod_url = Pathname(url)
                        if pod_url.directory?
                            domain_url = Pathname(pod_url.dirname)
                            branch = git_branch(pod_url)
                            all_pods << Repo::new(pod_url.basename.to_s, domain_url.basename.to_s, nil, pod_url.to_s, branch)
                        end
                    end
                    for url in Dir.glob(@projects::root + '*/repos/*/*') do
                        pod_url = Pathname(url)
                        if pod_url.directory?
                            domain_url = Pathname(pod_url.dirname)
                            project_url = Pathname(Pathname(domain_url.dirname).dirname)
                            branch = git_branch(pod_url)
                            all_pods <<Repo::new(pod_url.basename.to_s, domain_url.basename.to_s, project_url.basename.to_s, pod_url.to_s, branch)
                        end
                    end
                    all_pods
                end

                private 

                def git_branch url
                    branch = nil
                    Dir.chdir(url) do
                        begin
                            branch = git! ['rev-parse', '--abbrev-ref', 'HEAD']
                            branch = branch.chomp
                        rescue => exception
                            branch = nil
                        end
                    end
                    branch
                end
                
            end
        end
    end
end