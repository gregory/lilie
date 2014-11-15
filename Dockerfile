FROM debian:wheezy

RUN apt-get update &&\
    apt-get install -y \
      curl \
      git-core \
      build-essential \
      mysql-client \
      libssl-dev \
      mysql-common \
      libmysqlclient-dev \
      imagemagick &&\
    rm -rf /var/lib/apt/lists/*


ENV RUBY_MAJOR 2.0
ENV RUBY_VERSION  2.0.0-p576
ENV USE_ENV true
ENV WORKDIR /opt/services/lilie
ENV BUNDLE_PATH /var/bundle
ENV GEM_HOME $BUNDLE_PATH
ENV HOME $WORKDIR
ENV BUNDLE_APP_CONFIG $GEM_HOME
ENV PATH $PATH:$BUNDLE_PATH/bin

RUN mkdir -p /tmp/ruby \
  && curl -L "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" \
      | tar -xjC /tmp/ruby --strip-components=1 \
  && cd /tmp/ruby \
  && ./configure --disable-install-doc \
  && make \
  && make install \
  && gem update --system \
  && rm -r /tmp/ruby

RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc

RUN mkdir -p $BUNDLE_PATH &&\
    gem install bundler foreman pry

RUN groupadd lilie &&\
    useradd -g lilie -d $WORKDIR -s /sbin/nologin -c 'Docker user' lilie &&\
    mkdir -p $WORKDIR $BUNDLE_PATH

WORKDIR /opt/services/lilie
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock

RUN bundle install --without development --path $BUNDLE_PATH &&\
    chown -R lilie:lilie $WORKDIR $BUNDLE_PATH

ENV RACK_ENV production

USER lilie
ADD . /opt/services/lilie

CMD foreman start

