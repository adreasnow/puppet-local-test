FROM puppet/puppetserver

RUN /opt/puppetlabs/bin/puppetserver gem install hiera-eyaml

COPY puppet.conf /etc/puppetlabs/puppet/puppet.conf

# Expose the puppet server port
EXPOSE 8140

# Use the default puppetserver entrypoint
CMD ["foreground"]
