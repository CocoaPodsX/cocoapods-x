require 'cocoapods-x/extension/sandbox'

module Pod
    module X
        class Configurator

            def self.find_conf? project_url
                projects = Pod::X::Sandbox::workspace::projects
                for project_debug_url in Dir.glob(projects::root + '*') do
                    conf = Pod::X::Configurator::new project_url, project_debug_url
                    if conf.verify?
                        break
                    end
                end
                if conf.nil? || !conf.verify?
                    conf = nil
                end
                conf
            end

            def self.create_conf! project_url
                index = 0
                name = File.basename(project_url)
                projects = Pod::X::Sandbox::workspace::projects
                begin 
                    project_debug_url = projects::root + "#{name}@#{index}"
                    index += 1
                end while project_debug_url.exist?
                Pod::X::Configurator::new project_url, project_debug_url
            end

            attr_reader :conf

            def initialize project_url, project_debug_url
                @conf = { 'project_url' => project_url.to_s, 'project_debug_url' => project_debug_url.to_s }
            end

            def url
                File.join(project_debug_url, '.conf')
            end

            def project_url
                @conf['project_url']
            end

            def project_debug_url
                @conf['project_debug_url']
            end

            def verify?
                valid = false
                unless url.nil? || project_url.nil? || project_debug_url.nil?
                    if File.exist?(url) && File.exist?(project_url) && File.exist?(project_debug_url)
                        begin json = JSON.parse(File.read(url))
                        rescue => exception 
                        end
                        valid = @conf == json
                    end
                end
                valid
            end

            def sync
                begin json = JSON.parse(File.read(url))
                rescue => exception
                end
                unless json.nil?
                    @conf = json.merge(@conf)
                end
            end

            def save!
                return nil if verify?
                File.write(url, @conf.to_json)
            end

        end
    end
end