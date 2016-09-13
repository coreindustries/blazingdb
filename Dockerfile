# https://blazingdb.readme.io/v1.0/docs/quickstart-guide-to-blazingdb?
FROM nvidia/cuda:8.0-cudnn5-runtime

# http://layer0.authentise.com/docker-4-useful-tips-you-may-not-know-about.html
# pick a mirror for apt-get
RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    DEBIAN_FRONTEND=noninteractive apt-get update

# cache apt-get requests locally. 
# Requires: docker run -d -p 3142:3142 --name apt_cacher_run apt_cacher
# https://docs.docker.com/engine/examples/apt-cacher-ng/
RUN  echo 'Acquire::http { Proxy "http://192.168.150.50:3142"; };' >> /etc/apt/apt.conf.d/01proxy

RUN apt-get update && apt-get install -y --no-install-recommends \
	build-essential \
	&& rm -rf /var/lib/apt/lists/*



# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

WORKDIR "/opt/blazingdb"

RUN wget http://blazing-public-downloads.s3-website-us-west-2.amazonaws.com/installer/blazingdb_installer.sh
RUN wget http://blazing-public-downloads.s3-website-us-west-2.amazonaws.com/installer/blazingworkbench_installer.sh

RUN chmod +x blazingdb_installer.sh
RUN ./blazingdb_installer.sh
RUN /opt/blazing/Simplicity 8890 /opt/blazing/disk1/blazing/blazing.conf


# CMD ["/run_jupyter.sh"]
