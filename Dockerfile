FROM ruby:2.3-jessie
MAINTAINER Marc Byfield<marc@learningtapestry.com>

EXPOSE 3000
RUN apt-get update -yqq && apt-get install -y apt-transport-https postgresql-client
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
	&& echo "deb https://dl.yarnpkg.com/debian/ stable main" |  tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get update -qq && apt-get install nodejs yarn
RUN wget https://downloads.wkhtmltopdf.org/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
RUN tar xvfJ wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
RUN mv wkhtmltox/bin/wkhtmltopdf /usr/local/bin && rm -rf wkhtmltox*
ADD . .
RUN cp -R app/assets/fonts/* /usr/local/share/fonts && fc-cache -f -v
RUN yarn
RUN bundle
RUN chmod +x ./docker-entrypoint.sh
CMD ["./docker-entrypoint.sh"]
