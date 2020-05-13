require 'cocoapods-x/extension/sandbox/protocol'

module Pod
    module X
        class Sandbox
            class Repos < Pod::Sandbox

                include Pod::X::Sandbox::Protocol

                Repo = Struct::new(:name, :argv, :pod, :source, :repo_url, :hostname, :share)

                def initialize url
                    super File.join(url, 'repos')
                end

                def install!
                    
                end

                def update!
                    
                end

                def self.repo name, argv, pod, source 
                    domain = source[:domain]
                    group = source[:group]
                    git = source[:git]

                    puts group
                    puts group.class
                    puts source
                    puts source.class
                    if domain.start_with? "git@"
                        repo_url = source_git(domain, group, git)
                    else
                        repo_url = source_http(domain, group, git)
                    end
                    hostname = hostname(repo_url)
                    Repo::new(name, argv, pod, source, repo_url, hostname, pod[:share])
                end

                def pod_path repo
                    return Pathname(repo.pod[:path]) unless repo.pod[:path].nil?
                    root + "#{repo.hostname}/#{repo.name}"
                end

                def pod_clone! repo
                    path = pod_path(repo)
                    rm! ['-rf', path]
                    git_clone!(repo.name, repo.repo_url, path)
                end
                
                private

                def git_clone! name, repo_url, to
                    UI.section("Pod::X Cloning `#{name}` into #{repo_url}.".green) do
                        git! ['clone', repo_url, to]
                    end
                    unless (to + '.git').exist?
                        raise Informative, "Clone failed."
                    end
                end

                def self.hostname repo_url
                    url = repo_url
                    if url.start_with? 'git@'
                        url = url.gsub ':', '/'
                        url = url.gsub 'git@', 'https://'
                    end
                    URI(url).hostname
                end
                
                def self.repo_url name, argv, pod, source
                    return pod[:source] unless pod[:source].nil?

                    domain = source[:domain]
                    group = source[:group]
                    git = source[:git]

                    if domain.start_with? "git@"
                        repo_url = source_git(domain, group, git)
                    else
                        repo_url = source_http(domain, group, git)
                    end
                    repo_url
                end

                def self.source_git(domain, group, git)
                    "#{domain}:#{group}/#{git}"
                end

                def self.source_http(domain, group, git)
                    "#{domain}/#{group}/#{git}"
                end

            end
        end
    end
end