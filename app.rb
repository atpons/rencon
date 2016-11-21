require "docker-api"
require "sinatra"

set :bind, '0.0.0.0'

get "/" do
@image = Docker::Image.all
Docker.url = "http://127.0.0.1:4243/"
cons = Docker::Container.all(:running => true)
@cont = Docker::Container.all(:running => true)
  erb :index
end

post "/run" do
 Docker.url = "http://127.0.0.1:4243/"
 @img = @params[:img]
 @port = @params[:port]
@container = Docker::Container.create(
      'Image' => @img,
'OpenStdin' => true,
'ExposedPorts' => { '80/tcp' => {} },
'Tty' => true,
      'HostConfig' => { 'Privileged' => true, 'PortBindings' => {
      '80/tcp' => [{}]
    }},
      'Cmd': [ '/bin/bash' ]
    ) 
@container.start
@container.exec(["./run.sh"], detach: true)
erb :run
end

get "/stop" do
  @id = params["id"]
  @container = Docker::Container.get(@id)
  @container.stop
  erb :stop
end

