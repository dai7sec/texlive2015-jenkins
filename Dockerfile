From ringo/scientific:6.5

MAINTAINER tboffice
ENV TEXLIVESERVER 172.17.0.1

RUN yum install -y yum-fastestmirror && \
    yum update -y && \
    yum -y install wget patch git vim-enhanced gcc openssl-devel python-devel libffi-devel python-imaging ipa-gothic-fonts libjpeg-turbo-devel ipa-pgothic-fonts ghostscript && \
    yum clean all
RUN curl https://bootstrap.pypa.io/get-pip.py | python && \
    pip install --upgrade ndg-httpsclient

# TeX Live 2015
RUN cd /tmp && \
    wget -r http://${TEXLIVESERVER}:8000/tlpkg/; mv ${TEXLIVESERVER}\:8000/tlpkg/ . && \
    wget -r http://${TEXLIVESERVER}:8000/archive/; mv ${TEXLIVESERVER}\:8000/archive/ . && \
    wget ${TEXLIVESERVER}:8000/install-tl && \
    rm -rf ${TEXLIVESERVER}\:8000 && \
    chmod +x install-tl && \
    ./install-tl -profile tlpkg/texlive.tlpdb && \
    echo "PATH=$PATH:/usr/local/texlive/2015/bin/x86_64-linux" > /etc/profile.d/texlive.sh && \
    chmod +x /etc/profile.d/texlive.sh
RUN pip install sphinxcontrib-blockdiag && \
    pip install sphinx==1.3.6
RUN source /etc/profile; kanji-config-updmap-sys ipaex

# jenkins
RUN wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo && \
    rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key && \
    yum install -y jenkins java-1.8.0-openjdk && \
    yum clean all

# Add Tini
ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d
COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy
ENV JENKINS_UC https://updates.jenkins.io
RUN chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins/ref
ENV JENKINS_HOME /var/lib/jenkins
ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log
COPY jenkins.sh /usr/local/bin/jenkins.sh
RUN chmod +x /usr/local/bin/jenkins.sh
ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]

