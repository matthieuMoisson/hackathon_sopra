FROM debian:stretch

# Install dependencies
RUN apt-get -qq update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends libstdc++6 python-pygments git ca-certificates asciidoc curl gnupg apt-transport-https gcc g++ make \
    && rm -rf /var/lib/apt/lists/*

# Node & yarn
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get -qq update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y nodejs yarn \
    && yarn global add firebase-tools gh-pages\
    && rm -rf /var/lib/apt/lists/*

# Hugo
ENV HUGO_VERSION 0.55.6
ENV HUGO_BINARY hugo_extended_${HUGO_VERSION}_Linux-64bit.deb
# RUN echo "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}"
RUN curl -L -o /tmp/hugo.deb \
    https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} && \
    dpkg -i /tmp/hugo.deb && \
    rm /tmp/hugo.deb && \
    mkdir /site

WORKDIR /site
VOLUME [ "/site" ]

CMD hugo version
