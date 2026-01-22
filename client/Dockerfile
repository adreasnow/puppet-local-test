FROM puppet/puppet-agent-ubuntu:latest

COPY puppet.conf /etc/puppetlabs/puppet/puppet.conf

# Wait for puppet server to be ready, then run puppet agent periodically
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["echo 'Waiting for puppet server...'; sleep 20; while true; do puppet agent -t --debug || true; sleep 30; done"]
