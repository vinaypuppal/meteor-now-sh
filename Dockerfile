FROM node:6.9-slim

ENV MONGO_URL mongodb://<username>:<password>@ds061405.mlab.com:61405/meteor-test
ENV ROOT_URL https://meteor-now.now.sh

RUN apt-get update -q -q && \
    apt-get --yes --force-yes install curl python g++ build-essential && \
    curl https://install.meteor.com/ | sed s/--progress-bar/-sL/g | sh

COPY . /source

RUN cp -a /source /build && \
    rm -rf /source && \
    cd /build && \
    meteor npm install && \
    METEOR_PROGRESS_DEBUG=1 meteor build . --unsafe-perm&& \
    cd / && \
    tar xf /build/build.tar.gz && \
    cd /bundle/programs/server && \
    npm install && \
    apt-get --yes --force-yes purge curl && \
    apt-get --yes --force-yes remove build-essential && \
    apt-get --yes --force-yes autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /build /root/.meteor

WORKDIR /bundle
ENV PORT 3000
EXPOSE 3000
CMD ["node", "main.js"]