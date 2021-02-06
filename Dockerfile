FROM ruby:2.5.7

RUN apt-get update -qq && \
apt-get install -y build-essential \
									 libpq-dev \
									 nodejs \
									 default-mysql-client \
									 vim

RUN mkdir /book_management_system

WORKDIR /book_management_system

COPY Gemfile /book_management_system/Gemfile
COPY Gemfile.lock /book_management_system/Gemfile.lock

RUN bundle install

COPY . /book_management_system