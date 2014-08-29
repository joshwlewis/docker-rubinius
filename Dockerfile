FROM ubuntu:14.04
MAINTAINER Josh W Lewis <josh.w.lewis@gmail.com>

ENV RBX_VERSION 2.2.10

# Generate and set UTF-8 locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV HOME /root
ENV SHELL /bin/bash

RUN apt-get update
RUN apt-get install -y git wget ruby-dev make automake
RUN apt-get install -y gcc g++ flex bison llvm-dev zlib1g-dev libyaml-dev \
    libssl-dev libgdbm-dev libreadline-dev libncurses5-dev
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN gem install bundler
RUN wget -O rubinius-release-$RBX_VERSION.tar.bz2 http://releases.rubini.us/rubinius-$RBX_VERSION.tar.bz2
RUN tar -xjf rubinius-release-$RBX_VERSION.tar.bz2
RUN rm rubinius-release-$RBX_VERSION.tar.bz2
RUN cd rubinius-$RBX_VERSION && \
    bundle install && \
    ./configure --prefix=/opt/rubies/rubinius-$RBX_VERSION && \
    rake build && \
    sudo rake install

ENV PATH /opt/rubies/rubinius-$RBX_VERSION/bin:$PATH
RUN rm -rf /tmp/* /var/tmp/*
