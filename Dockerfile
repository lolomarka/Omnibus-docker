FROM almalinux:9
# FROM almalinux:8

RUN dnf install -y 'dnf-command(config-manager)'
RUN dnf config-manager --set-enabled crb

# for fs
RUN dnf install -y mc

# Install a build toolchain for the platform as specified by the https://github.com/postmodern/ruby-install/blob/master/share/ruby-install/ruby/dependencies.txt
RUN yum install -y xz gcc automake bison zlib-devel libyaml-devel openssl-devel gdbm-devel readline-devel ncurses-devel libffi-devel 
# additional
RUN yum install -y perl perl-FindBin perl-IPC-Cmd 

# Install git
RUN yum install -y git

# Install the rpm-build package so omnibus will be able to build rpm packages.
RUN yum install -y rpm-build

RUN yum update -y

# Install packages used when compiling ruby as specified by the ruby-install tool

#RUN yum install -y gcc automake bison zlib-devel libyaml-devel openssl-devel gdbm-devel readline-devel ncurses-devel libffi-devel

WORKDIR /

RUN curl -L -o ruby-3.3.6.tar.gz https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.6.tar.gz

RUN tar xzvf ruby-3.3.6.tar.gz

WORKDIR /ruby-3.3.6

RUN ./configure

RUN make
RUN make install 

WORKDIR /


RUN gem install bundler

RUN useradd builder

RUN mkdir /var/cache/omnibus
RUN chown builder:builder /var/cache/omnibus
RUN mkdir /opt/my_cpp_program
RUN chown builder:builder /opt/my_cpp_program

RUN mkdir /bin/my_cpp_program
RUN chown builder:builder /bin/my_cpp_program


# RUN git clone https://github.com/chef/omnibus-toolchain.git
# RUN chown builder:builder /omnibus-toolchain
# WORKDIR /omnibus-toolchain
# USER builder

RUN git clone https://github.com/lolomarka/omnibus-my_cpp_program.git
RUN chown builder:builder /omnibus-my_cpp_program
WORKDIR /omnibus-my_cpp_program
USER builder

# if a Gemfile.lock file already exists then run
# RUN bundle install --without development

# if a Gemfile.lock file does not already exist then run
RUN bundle config set path 'vendor/bundle'
RUN bundle config set without 'development'
RUN bundle install

RUN bundle exec omnibus build my_cpp_program

USER root
