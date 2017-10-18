#!ruby -Ku
# -*- coding: utf-8 -*-

require 'rubygems'
require 'sinatra/base'
require 'sinatra/reloader'
require 'natto'

class MyApp < Sinatra::Base

  configure do
    set :server, :thin
    set :bind, '0.0.0.0'
    set :port, 3000
    
    enable :method_override
  end
  configure :development do
    register Sinatra::Reloader
    
    also_reload '/myapp/**/*.rb'
  end

  post '/sunshine' do
    text=params[:text]
    ret=""
    nm = Natto::MeCab.new
    text.each_line do |line|
      nm.parse(line.chomp) do |n|
        sp=n.feature.split(",")[7]
        if sp && sp.include?("イ")
          ret+=sp
        else
          ret+=n.surface
        end
      end
      ret+="\n"
    end

    @title="サンシャイン池崎ゲームリゾルバ(結果)"
    @restext=ret.gsub("イ","イェー！")
    @refescape=URI.encode_www_form({"text"=>@restext})
    slim :sunshine
  end

  get '/sunshine' do
    @title="サンシャイン池崎ゲームリゾルバ"
    slim :sunshine
  end

end

if $0 == __FILE__
  MyApp.run!
end

__END__
