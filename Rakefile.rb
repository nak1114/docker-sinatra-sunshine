if ENV['RACK_ENV']
#in docker

else
#in host

  name=File.basename(Dir.pwd)
  docker_run=%(docker run --rm -it -v "#{Dir.pwd}":/myapp -e RACK_ENV=development -e RUBYOPT=-EUTF-8 #{name})
  def get_images(name) `docker images #{name}`.scan(/^#{name}\s+(\S+)\s+(\S+)/).map{|v| v[0]}; end
  def get_new_version(name) (get_images(name).delete_if{|v| v=='latest'}.map{|v| Gem::Version.create(v)}.max || Gem::Version.create('0.0.0')).segments.tap{|v| v[-1]+=1}.join('.'); end

  desc "build new docker image"
  task :build , ['tag']  do |task, args|
    tag=args[:tag] || get_new_version(name)
    touch('Gemfile.lock') unless File.exists?('Gemfile.lock')
    sh("docker build -t #{name}:#{tag} .")
    sh("docker tag #{name}:#{tag} #{name}:latest")
    sh("#{docker_run} cp -pf /tmp/Gemfile.lock /myapp")
  end

  desc "run app in docker"
  task :run  do |task, args|
    sh("#{docker_run.sub('docker run','docker run -p 3000:3000')}")
  end

  desc "run 'bash' in docker"
  task :bash  do |task, args|
    sh("#{docker_run} /bin/bash")
  end

  desc "run 'pry' in docker"
  task :pry do
    sh("#{docker_run} bundle exec pry")
  end

end
