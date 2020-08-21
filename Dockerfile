FROM quay.io/evryfs/github-actions-runner:2.273.0

# Switch to root user for software installation.
USER root

# Install yarn.
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get -y update && \
  apt-get -y --no-install-recommends install yarn && \
  apt-get -y --no-install-recommends install htop

# Install Cypress dependencies.
RUN apt-get -y update && \
  apt-get -y --no-install-recommends install sudo libgtk2.0-0 libgtk-3-0 libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb libxcomposite1 libxcursor1

# Install Google Chrome.
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list && \
  apt-get -y update && \
  apt-get -y --no-install-recommends install google-chrome-stable && \
  echo "CHROME_BIN=/usr/bin/google-chrome" | tee -a /etc/environment

# Clean apt cache.
RUN apt-get -y clean && \
    rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Back to default runner user.
USER runner
