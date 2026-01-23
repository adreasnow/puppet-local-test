FROM puppet/puppetserver

COPY puppet.conf /etc/puppetlabs/puppet/puppet.conf
COPY protocols /etc/protocols

RUN /opt/puppetlabs/bin/puppetserver gem install hiera-eyaml

# Expose the puppet server port
EXPOSE 8140

# Use the default puppetserver entrypoint
CMD ["foreground"]
