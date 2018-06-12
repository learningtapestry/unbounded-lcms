FROM ruby:2.3-jessie
SHELL ["/bin/bash", "-c"]
MAINTAINER Marc Byfield<marc@learningtapestry.com>

RUN apt-get update && apt-get install apt-transport-https
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
	&& echo "deb https://dl.yarnpkg.com/debian/ stable main" |  tee /etc/apt/sources.list.d/yarn.list
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
	&& . $HOME/.nvm/nvm.sh \
	&& nvm install node \
        && apt-get update && apt-get install yarn
RUN wget https://downloads.wkhtmltopdf.org/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
RUN tar xvfJ wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
RUN mv wkhtmltox/bin/wkhtmltopdf /usr/local/bin && rm -rf wkhtmltox*
ADD . .
RUN cp -R app/assets/fonts/* /usr/local/share/fonts && fc-cache -f -v
RUN . $HOME/.nvm/nvm.sh && yarn
RUN bundle install
