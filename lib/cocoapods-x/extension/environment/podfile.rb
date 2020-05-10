
module Pod
    class Podfile
        module DSL

            xold_pod_method = instance_method(:pod)
            define_method(:pod) do |name, *requirements|
                environment = Pod::X::Environment::environment
                if environment.runing?
                    version = requirements.first
                    version ||= ''
                    version = version.is_a?(String) ? version : '';

                    options = requirements.last
                    options ||= Hash::new
                    options = options.is_a?(Hash) ? options : Hash::new(nil);

                    if options[:path].nil?
                        podinfo = environment.podinfo?(name, version)
                        if !podinfo.nil? && !podinfo.repo_url.nil?
                            path = environment.pod_path? podinfo
                            UI.puts "pod '#{name}', :path => '#{path}'".green
                            xold_pod_method.bind(self).(name, :path => path)
                        elsif !podinfo.nil? && podinfo.repo_url.nil?
                            UI.puts "Pod::X You must specify a repository to clone for `#{name}`.".yellow
                            xold_pod_method.bind(self).(name, *requirements)
                        else 
                            xold_pod_method.bind(self).(name, *requirements)
                        end
                    else
                        xold_pod_method.bind(self).(name, *requirements)
                    end
                else
                    xold_pod_method.bind(self).(name, *requirements)
                end
            end

        end
    end
end