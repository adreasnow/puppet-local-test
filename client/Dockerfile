FROM antmelekhin/docker-systemd:ubuntu-22.04

RUN apt update && \
    apt purge -y puppet-agent && \
    apt install -y gnupg wget

RUN wget https://apt.puppetlabs.com/puppet8-release-bionic.deb && \
    dpkg -i puppet8-release-bionic.deb && \
    rm puppet8-release-bionic.deb

RUN apt update && \
    apt install -y puppet-agent

COPY puppet.conf /etc/puppetlabs/puppet/puppet.conf

ENV PATH="/opt/puppetlabs/puppet/bin:${PATH}"

# ENTRYPOINT comes from parent image
