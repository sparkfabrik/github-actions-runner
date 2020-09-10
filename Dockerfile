FROM quay.io/evryfs/github-actions-runner:2.273.1

# Switch to root user for software installation.
USER root

# Use apt-fast for parallel downloads
RUN apt-get install -y aria2 && \
    add-apt-repository -y ppa:apt-fast/stable && \
    apt-get update && \
    apt-get -y install apt-fast

# Add runner user to sudoers without password request.
RUN echo 'runner ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/runner

# Copy scripts.
COPY scripts/snap /usr/local/bin
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
