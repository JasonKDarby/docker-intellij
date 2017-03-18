FROM ubuntu:16.04

MAINTAINER Jason Darby "jasonkdarby@gmail.com"

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update -qq && \
    echo 'Installing OS dependencies' && \
    apt-get install -qq -y --fix-missing sudo software-properties-common git libxext-dev libxrender-dev libxslt1.1 \
        libxtst-dev libgtk2.0-0 libcanberra-gtk-module unzip wget && \
    echo 'Installing JDK 8' && \
    apt-get install -qq -y --fix-missing openjdk-8-jdk && \
    echo 'Installing Leiningen' && \
    wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -O /usr/local/bin/lein && \
    chmod a+x /usr/local/bin/lein && \
    lein && \
    echo 'Cleaning up' && \
    apt-get clean -qq -y && \
    apt-get autoclean -qq -y && \
    apt-get autoremove -qq -y &&  \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN echo 'Creating user: developer' && \
    mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    sudo echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    sudo chmod 0440 /etc/sudoers.d/developer && \
    sudo chown developer:developer -R /home/developer && \
    sudo chown root:root /usr/bin/sudo && \
    chmod 4755 /usr/bin/sudo

RUN mkdir -p /home/developer/.IdeaIC2016.3/config/options && \
    mkdir -p /home/developer/.IdeaIC2016.3/config/plugins

ADD ./jdk.table.xml /home/developer/.IdeaIC2016.3/config/options/jdk.table.xml
ADD ./jdk.table.xml /home/developer/.jdk.table.xml

ADD ./run /usr/local/bin/intellij

RUN chmod +x /usr/local/bin/intellij && \
    chown developer:developer -R /home/developer/.IdeaIC2016.3

RUN echo 'Downloading IntelliJ IDEA' && \
    wget https://download.jetbrains.com/idea/ideaIC-2016.3.5.tar.gz -O /tmp/intellij.tar.gz -q && \
    echo 'Installing IntelliJ IDEA' && \
    mkdir -p /opt/intellij && \
    tar -xf /tmp/intellij.tar.gz --strip-components=1 -C /opt/intellij && \
    rm /tmp/intellij.tar.gz

RUN echo 'Installing Cursive Plugin' && \
    wget https://plugins.jetbrains.com/files/8090/31467/cursive-1.4.3-2016.3.zip -O cursive.zip -q && \
    unzip -q cursive.zip && \
    rm cursive.zip

RUN echo 'Installing Markdown plugin' && \
    wget https://plugins.jetbrains.com/files/7793/32455/markdown-2016.3.20170209.zip -O markdown.zip -q && \
    unzip -q markdown.zip && \
    rm markdown.zip

RUN sudo chown developer:developer -R /home/developer

USER developer
ENV HOME /home/developer
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
WORKDIR /home/developer/clojure
CMD /usr/local/bin/intellij
