FROM ubuntu:24.04

RUN apt update && \
    apt purge -y puppet-agent && \
    apt install -y gnupg wget

RUN wget https://apt.puppetlabs.com/puppet8-release-bionic.deb && \
    dpkg -i puppet8-release-bionic.deb && \
    rm puppet8-release-bionic.deb

RUN apt update && \
    apt install -y puppetserver

RUN /opt/puppetlabs/puppet/bin/gem install hiera-eyaml r10k

COPY puppet.conf /etc/puppetlabs/puppet/puppet.conf
COPY r10k.yaml /etc/puppetlabs/r10k/r10k.yaml
COPY protocols /etc/protocols

EXPOSE 8140

# Use the default puppetserver entrypoint
ENTRYPOINT ["/opt/puppetlabs/bin/puppetserver"]
CMD ["foreground"]
