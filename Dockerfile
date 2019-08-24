FROM node

# Install dependencies
RUN apt-get -qq update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends libstdc++6 python-pygments git ca-certificates asciidoc curl gnupg apt-transport-https gcc g++ make \
    && rm -rf /var/lib/apt/lists/*

# Chrome & yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \ 
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get -qq update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont yarn \
    && yarn global add firebase-tools gh-pages \
    && rm -rf /var/lib/apt/lists/* \
    && echo 'kernel.unprivileged_userns_clone=1' > /etc/sysctl.d/userns.conf

# Hugo
ENV HUGO_VERSION 0.56.3
ENV HUGO_BINARY hugo_extended_${HUGO_VERSION}_Linux-64bit.deb
# RUN echo "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}"
RUN curl -L -o /tmp/hugo.deb \
      https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} \
    && dpkg -i /tmp/hugo.deb \
    && rm /tmp/hugo.deb

# User
RUN groupadd -r hugonode && useradd -r -g hugonode -G audio,video hugonode \
    && mkdir /home/hugonode/ \
    && chown hugonode:hugonode /home/hugonode
USER hugonode

WORKDIR /home/hugonode
VOLUME [ "/home/hugonode" ]

CMD hugo version
