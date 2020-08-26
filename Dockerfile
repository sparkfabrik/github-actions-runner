FROM quay.io/evryfs/github-actions-runner:2.273.0

# Switch to root user for software installation.
USER root

# Make runner user use sudo without a password:
RUN apt update && apt install -y sudo
# Add runner user to sudoers without password request.
RUN echo 'runner ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/runner

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

# Install the Google Cloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update -y && \
    apt-get install -y google-cloud-sdk

# Clean apt cache.
RUN apt-get -y clean && \
    rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Back to default runner user.
USER runner
