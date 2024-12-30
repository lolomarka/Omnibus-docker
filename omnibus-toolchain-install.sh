#!/bin/bash

yum install -y xz gcc automake bison zlib-devel libyaml-devel openssl-devel gdbm-devel readline-devel ncurses-devel libffi-devel

yum install -y git

yum install -y rpm-build

yum install -y gcc automake bison zlib-devel libyaml-devel openssl-devel gdbm-devel readline-devel ncurses-devel libffi-devel

curl -L -o ruby-2.4.2.tar.gz https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.2.tar.gz
tar xzvf ruby-2.4.2.tar.gz
cd ruby-2.4.2
./configure
make
make install
cd -

gem install bundler

useradd builder

mkdir /var/cache/omnibus
chown builder:builder /var/cache/omnibus
mkdir /opt/omnibus-toolchain
chown builder:builder /opt/omnibus-toolchain

su - builder

git clone https://github.com/chef/omnibus-toolchain.git
cd omnibus-toolchain

# if a Gemfile.lock file already exists then run
bundle install --without development --deployment

# if a Gemfile.lock file does not already exist then run
bundle install --without development --path vendor/bundle

bundle exec omnibus build omnibus-toolchain