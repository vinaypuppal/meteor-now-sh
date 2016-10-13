FROM ubuntu:16.04

RUN apt-get update && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get install -y nodejs
RUN curl https://install.meteor.com/ | sh

WORKDIR /root/meteorapp

ADD . .

RUN meteor npm install
RUN meteor build . --architecture os.linux.x86_64

RUN tar -xzf meteorapp.tar.gz -C ../

WORKDIR /root/bundle/programs/server
RUN npm install

RUN npm install -g forever

EXPOSE 8080
ENV PORT 8080
ENV MONGO_URL mongodb://meteor-test:meteor-test@ds061405.mlab.com:61405/meteor-test
ENV ROOT_URL https://meteor-now.now.sh

WORKDIR /root/bundle
CMD ["forever", "--minUptime", "1000", "--spinSleepTime", "1000", "main.js"]
