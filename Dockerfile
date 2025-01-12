FROM almalinux:9

RUN dnf install -y 'dnf-command(config-manager)'
RUN dnf config-manager --set-enabled crb

RUN yum install -y git xz cmake gcc automake bison zlib-devel libyaml-devel openssl-devel gdbm-devel readline-devel ncurses-devel libffi-devel rpm-build perl perl-FindBin perl-IPC-Cmd mc

RUN yum update -y

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
