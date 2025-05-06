FROM centos:centos7.9.2009

# Fix mirror list for CentOS vault
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Update system and install essential tools
RUN yum -y update \
    && yum -y install wget curl vim git net-tools passwd man man-pages \
    tar zip unzip bzip2 which less nano \
    bash-completion lsof iputils traceroute \
    bind-utils telnet jq

# Install Java
RUN yum -y install java

# Install development tools
RUN yum -y groupinstall "Development Tools"

# Install EPEL repository and additional packages
RUN yum -y install epel-release \
    && yum -y install python3 python3-pip \
    openssh-server sudo rsync screen tmux

# Install network diagnostic tools
RUN yum -y install tcpdump nc

# Disk Partition
RUN yum -y install util-linux parted e2fsprogs lvm2 gdisk

# Clean up cached files to reduce image size
RUN yum clean all

# Set the default shell to bash
CMD ["/bin/bash"]
