#FROM node:7.8.0
#
## Create app directory
#RUN mkdir -p /usr/src/app
#WORKDIR /usr/src/app
#
## Install app dependencies
#COPY ./package.json /usr/src/app/
#RUN npm install
#RUN npm install grunt -g
#
#ENV NODE_ENV test
#ENV DOCKER true
#
## Bundle app source
#COPY . /usr/src/app
#
#RUN grunt release
#
#EXPOSE 3000
#
#
##TESTS
##RUN npm install protractor -g
#
##RUN apt-get update && \
##    apt-get install -y openjdk-7-jre git && \
##    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
##    dpkg --unpack google-chrome-stable_current_amd64.deb && \
##    apt-get install -f -y && \
##    apt-get clean && \
##    rm google-chrome-stable_current_amd64.deb
##
##RUN webdriver-manager update
#
#
#
#CMD [ "npm", "start" ]



FROM node:7.8.0

RUN         apt-get update

# CURL
RUN         apt-get install -y curl

# REDIS
RUN         apt-get install -y redis-server
EXPOSE      6379

# MONGO 3.4
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
RUN echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.4 main" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list
RUN apt-get update
RUN apt-get install -y mongodb-org
EXPOSE      27017

#RUN         apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
#RUN         echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list
#RUN         apt-get update
#RUN         apt-get install -y mongodb-org
#RUN         service mongod start
#EXPOSE      27017

# GRUNT
RUN         npm install -g grunt
RUN         npm install -g grunt-cli

# KARMA
RUN         npm install -g karma

# PROTRACTOR
RUN         npm install -g protractor

# JAVA
#RUN         apt-get install -y default-jre
RUN \
    echo "===> add webupd8 repository..."  && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list  && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list  && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886  && \
    apt-get update  && \
    \
    \
    echo "===> install Java"  && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
    DEBIAN_FRONTEND=noninteractive  apt-get install -y --force-yes oracle-java8-installer oracle-java8-set-default  && \
    \
    \
    echo "===> clean up..."  && \
    rm -rf /var/cache/oracle-jdk8-installer  && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*



# CHROME
RUN         set -xe
RUN         wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN         echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list
RUN         apt-get update -yqqq
RUN         apt-get install -y google-chrome-stable
RUN         export CHROME_BIN=/usr/bin/google-chrome

# WEBDRIVER
RUN         webdriver-manager update


