# Use Alpine Linux as the base image
FROM alpine:latest

# Install Nginx and OpenSSH
RUN apk add --no-cache nginx openssh

# Configure SSH
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
 && ssh-keygen -A

# Create a directory for Nginx PID and run Nginx in the foreground
RUN mkdir -p /run/nginx

# Expose port 22 for SSH and 2226 for Nginx
EXPOSE 22 2226

# Copy the public SSH key to the container (Adjust the path as necessary)
COPY ./secrets/id_rsa_container.pub /root/.ssh/authorized_keys

# Ensure proper permissions on the SSH folder and authorized_keys file
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys

# Start SSH and Nginx when the container launches
CMD /usr/sbin/sshd && nginx -g "daemon off;"
