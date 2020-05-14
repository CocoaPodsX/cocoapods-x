require 'cocoapods-x/extension/sandbox/protocol'

module Pod
    module X
        class Sandbox
            class Repos < Pod::Sandbox

                include Pod::X::Sandbox::Protocol

                Repo = Struct::new(:name, :repo_url, :location_url)

                def initialize url
                    super File.join(url, 'repos')
                end

                def install!
                    
                end

                def update!
                    
                end

                def self.Repo name, pod_argv, source_argv, workspace, project
                    return nil if pod_argv.nil?

                    location_url = pod_argv[:path]
                    return Repo::new(name, nil, location_url) unless location_url.nil?

                    repo_url = pod_argv[:source]
                    return Repo::new(name, repo_url, LocationUrl(name, repo_url, pod_argv, workspace, project)) unless repo_url.nil?

                    return Repo::new(name, nil, nil) if source_argv.nil?                    

                    git_name = source_argv[:git]
                    return Repo::new(name, nil, nil) if git_name.nil?

                    group_name = source_argv[:group]
                    return Repo::new(name, nil, nil) if group_name.nil?

                    domain_name = source_argv[:domain]
                    return Repo::new(name, nil, nil) if domain_name.nil?
                    
                    if domain_name.start_with? "git@"
                        repo_url = RepoGitUrl(domain_name, group_name, git_name)
                    else
                        repo_url = RepoHttpUrl(domain_name, group_name, git_name)
                    end

                    Repo::new(name, repo_url, LocationUrl(name, repo_url, pod_argv, workspace, project))
                end
                
                private

                def self.LocationUrl name, repo_url, pod_argv, workspace, project
                    hostname = Hostname(repo_url)
                    root = pod_argv[:share] ? workspace::repos::root : project::repos::root
                    (root + "#{hostname}/#{name}").to_s
                end

                def self.Hostname repo_url
                    url = repo_url
                    if url.start_with? 'git@'
                        url = url.gsub ':', '/'
                        url = url.gsub 'git@', 'https://'
                    end
                    URI(url).hostname
                end

                def self.RepoGitUrl domain_name, group_name, git_name
                    "#{domain_name}:#{group_name}/#{git_name}"
                end

                def self.RepoHttpUrl domain_name, group_name, git_name
                    "#{domain_name}/#{group_name}/#{git_name}"
                end

            end
        end
    end
end