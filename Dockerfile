FROM ruby:2.5.7

RUN apt-get update -qq && \
apt-get install -y build-essential \
									 libpq-dev \
									 nodejs \
									 default-mysql-client \
									 vim

RUN apt-get update && apt-get install -y unzip && \
    CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ && \
    unzip ~/chromedriver_linux64.zip -d ~/ && \
    rm ~/chromedriver_linux64.zip && \
    chown root:root ~/chromedriver && \
    chmod 755 ~/chromedriver && \
    mv ~/chromedriver /usr/bin/chromedriver && \
    sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && apt-get install -y google-chrome-stable

RUN mkdir /book_management_system

WORKDIR /book_management_system

COPY Gemfile /book_management_system/Gemfile
COPY Gemfile.lock /book_management_system/Gemfile.lock

RUN bundle install

COPY . /book_management_system