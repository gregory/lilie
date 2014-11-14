FROM bigcommerce/ruby:2.0.0-p576

ENV USE_ENV true
ENV WORKDIR /opt/services/lilie
ENV BUNDLE_PATH /var/bundle
ENV GEM_HOME $BUNDLE_PATH
ENV HOME $WORKDIR
ENV BUNDLE_APP_CONFIG $GEM_HOME
ENV RACK_ENV production

RUN apt-get update && apt-get install -y -q \
    mysql-client \
    mysql-common \
    libmysqlclient-dev \
    imagemagick

RUN gem install rack

RUN groupadd app &&\
    useradd -g app -d $WORKDIR -s /sbin/nologin -c 'Docker user' app &&\
    mkdir -p $WORKDIR $BUNDLE_PATH

WORKDIR /opt/services/lilie

ADD Gemfile /opt/services/lilie/
ADD Gemfile.lock /opt/services/lilie/


RUN bundle install --without development --path $BUNDLE_PATH

ADD . /opt/services/lilie

RUN chown -R app:app $WORKDIR $BUNDLE_PATH

USER app

CMD bundle &&\
    bundle exec rake db:migrate:up &&\
    foreman start

