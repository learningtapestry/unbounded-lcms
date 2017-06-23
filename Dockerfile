FROM ruby:2.3
ENV LANG C.UTF-8

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev apt-transport-https postgresql-client
RUN wget https://downloads.wkhtmltopdf.org/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz && \
          tar xvfJ wkhtmltox-0.12.3_linux-generic-amd64.tar.xz && \
          cp wkhtmltox/bin/wkhtmltopdf /usr/local/bin
RUN curl https://repo.varnish-cache.org/GPG-key.txt | apt-key add - && \
      echo 'deb https://repo.varnish-cache.org/ubuntu/ trusty varnish-4.0' > /etc/apt/sources.list.d/varnish-cache.list && \
      apt-get update -qq && apt-get install varnish -y
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
      apt-get install -y nodejs
RUN npm install svgexport -g && npm install pngquant-bin -g && npm install phantomjs -g

RUN mkdir /app
WORKDIR /app
ADD . /app/

RUN cp /app/.cloud66/varnish/default.vcl /etc/varnish/default.vcl && \
          cp /app/.cloud66/varnish/varnish.service /etc/default/varnish

RUN cp -R app/assets/fonts/* /usr/local/share/fonts && fc-cache -f -v
RUN bundle install
