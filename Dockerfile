# Follows https://github.com/icbi-lab/quanTIseq/blob/039eb16455373915ace33b3ecede09bde697d005/Dockerfile
FROM centos:7

LABEL maintainer="christina.plattner@i-med.ac.at,francesca.finotello@i-med.ac.at,dietmar.rieder@i-med.ac.at"

RUN yum clean all && yum -y update

################# BEGIN INSTALLATION ######################


################## Java
RUN yum install -y java

################## wget
RUN yum install -y wget

##################  R (> version 3.4.3)
RUN yum install -y epel-release
RUN yum install -y R-core R-devel

#### utils

RUN yum install -y dos2unix
RUN yum install -y mc

#### Get the quanTIseq source code
ADD https://github.com/icbi-lab/quanTIseq/archive/039eb16455373915ace33b3ecede09bde697d005.zip /usr/local/quantiseq/
RUN cd /usr/local/quantiseq && \
    unzip 039eb16455373915ace33b3ecede09bde697d005.zip && \
    cd quanTIseq-039eb16455373915ace33b3ecede09bde697d005 && \
    cp dependencies.R /tmp/ && \
    cp -r quantiseq /opt/quantiseq

#### Install dependencies
RUN Rscript /tmp/dependencies.R

##################### INSTALLATION END #####################

#Clean up
RUN rm -rf /tmp/* /var/tmp/* ~/.cache/*

# entrypoint
ENTRYPOINT ["/opt/quantiseq/quanTIseq.sh"]
