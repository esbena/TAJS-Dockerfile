FROM ubuntu:15.04

ARG CACHE_DATE=not_a_date

RUN set -ex

#
# apt-get for misc. packages
#
RUN apt-get update; \
    apt-get install -y software-properties-common; \
    add-apt-repository -y ppa:webupd8team/java; \
    apt-get update; \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections; \
    apt-get install -y \
        ant \
        curl \
        git \
        gnuplot \
        netcat \
        oracle-java8-installer

#
# manual node 5.5
#

# gpg keys from https://github.com/nodejs/node
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    B9AE9905FFD7803F25714661B63B535A4C206CA9;

ENV NPM_CONFIG_LOGLEVEL=info
ENV NODE_VERSION=5.5.0
RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" && gpg --verify SHASUMS256.txt.asc && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc

#
# npm for misc. packages
#
RUN npm install \
    https://github.com/wala/jsdelta.git \
    babel-cli \
    babel-plugin-transform-es2015-block-scoping \
    babel-plugin-transform-es2015-classes \
    babel-plugin-transform-es2015-for-of \
    babel-plugin-transform-es2015-shorthand-properties \
    babel-plugin-transform-es2015-template-literals
