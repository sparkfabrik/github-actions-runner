FROM quay.io/evryfs/github-actions-runner@sha256:7bfa720303eaef09a4886e6290efe503b7ed92d176334f29149c3b25cf24e185

# Switch to root user for software installation.
USER root

# Make runner user use sudo without a password:
RUN apt update && apt install -y git sudo

# Use apt-fast for parallel downloads
RUN apt-get install -y aria2 && \
    add-apt-repository -y ppa:apt-fast/stable && \
    apt-get update && \
    apt-get -y install apt-fast

# Add runner user to sudoers without password request.
RUN echo 'runner ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/runner

# This the release tag of virtual-environments: https://github.com/actions/virtual-environments/releases
ENV VIRTUAL_ENVIRONMENT_VERSION=ubuntu18/20200817.1

# Copy scripts.
COPY scripts/install-from-virtual-env /usr/local/bin
COPY scripts/snap /usr/local/bin
RUN chmod +x /usr/local/bin/install-from-virtual-env
RUN chmod +x /usr/local/bin/snap

# Install packages from virtual-environment repository.
# Installable script packages are available here
# https://github.com/actions/virtual-environments/tree/main/images/linux/scripts/installers
RUN install-from-virtual-env basic
RUN install-from-virtual-env google-chrome
RUN install-from-virtual-env google-cloud-sdk
RUN install-from-virtual-env kubernetes-tools

# Clean apt cache.
RUN apt-get -y clean && \
    rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

# @TODO we should set these symlinks in the source image as done with node.
RUN ln -s /home/runner/externals/node12/bin/npm /usr/local/bin/npm
RUN ln -s /home/runner/externals/node12/bin/npx /usr/local/bin/npx

# Back to default runner user.
USER runner
