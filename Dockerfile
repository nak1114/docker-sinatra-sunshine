FROM centos:centos6

# for Locale(CentOS)
ENV LANG C.UTF-8

# for Ruby
RUN yum -y install wget gcc gcc-c++ make openssl-devel libffi-devel readline-devel zlib-devel \
 && wget --no-check-certificate https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.2.tar.gz \
 && tar zxvf ruby-2.4.2.tar.gz \
 && cd ruby-2.4.2 \
 && ./configure && make && make install  \
 && cd ..  \
 && rm -f ruby-2.4.2.tar.gz  \
 && rm -rf ruby-2.4.2 \
 && gem install bundler

# for Mecab
RUN yum -y install wget gcc gcc-c++ make \
 && wget -O mecab-0.996.tar.gz "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE" \
 && tar zxvf mecab-0.996.tar.gz \
 && cd mecab-0.996 \
 && ./configure --with-charset=utf8 && make && make install \
 && cd .. \
 && rm -f mecab-0.996.tar.gz \
 && rm -rf mecab-0.996 \
 && wget -O mecab-ipadic-2.7.0-20070801.tar.gz "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM" \
 && tar zxvf mecab-ipadic-2.7.0-20070801.tar.gz \
 && cd mecab-ipadic-2.7.0-20070801 \
 && ./configure --with-charset=utf8 && make && make install \
 && cd .. \
 && rm -f mecab-ipadic-2.7.0-20070801.tar.gz \
 && rm -rf mecab-ipadic-2.7.0-20070801

# for App
ENV APP_HOME /myapp
WORKDIR $APP_HOME
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install && cp -pf Gemfile.lock /tmp/Gemfile.lock

ADD . $APP_HOME
RUN cp -pf /tmp/Gemfile.lock Gemfile.lock

CMD bundle exec ruby app.rb
