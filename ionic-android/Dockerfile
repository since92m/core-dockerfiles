FROM ubuntu:14.04
MAINTAINER m<since92x@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive \
	ANDROID_HOME=/opt/android-sdk-linux
#use mirrors for faster apt downloads no matter where the machine that builds the image is
RUN	sed -i 's/http:\/\/archive\.ubuntu\.com\/ubuntu\//http:\/\/mirrors\.163\.com\/ubuntu\//g' /etc/apt/sources.list && \
	echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse" >> /etc/apt/sources.list; \
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list; \
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list; \
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse" >> /etc/apt/sources.list && \
#install required software before using nvm/node/npm/bower
	apt-get update --fix-missing && apt-get install -y -q \
	htop vim-gnome tmux wget curl git zip unzip bzip2 ruby screen python build-essential \
#ANDROID
#JAVA
# install python-software-properties (so you can do add-apt-repository)
    python-software-properties software-properties-common  && \
    add-apt-repository ppa:webupd8team/java -y && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get update && apt-get -y install oracle-java7-installer && \
#ANDROID STUFF
    echo ANDROID_HOME="${ANDROID_HOME}" >> /etc/environment && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --force-yes expect ant wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 qemu-kvm kmod && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
# Install Android SDK
    cd /opt && \
    wget --output-document=android-sdk.tgz --quiet http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
    tar xzf android-sdk.tgz && \
    rm -f android-sdk.tgz && \
    chown -R root. /opt
# Setup environment
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:/opt/tools
# Install sdk elements
COPY tools /opt/tools
RUN ["/opt/tools/android-accept-licenses.sh", "android update sdk --all --no-ui --filter platform-tools,tools,build-tools-23.0.2,android-23,extra-android-support,extra-android-m2repository,extra-google-m2repository"]
RUN unzip ${ANDROID_HOME}/temp/*.zip -d ${ANDROID_HOME} && \
	sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
#add user developer and use it to install node 
	useradd --home /home/developer -m -U -s /bin/bash developer && \
#allow some limited sudo commands for user `developer`
#	chmod +w /etc/sudoers; echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers; chmod -w /etc/sudoers 
	chmod +w /etc/sudoers; echo "ALL ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers; chmod -w /etc/sudoers && \
    cp /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
    dpkg-reconfigure locales && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8
#run all of the following commands as user developer from now on
USER developer 
#change it to your required node version
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
#install the specified node version and set it as the default one, install the global npm packages
ENV NODE_VERSION=6.9.2 \
	NVM_DIR=/home/developer/.nvm
COPY .bash* /home/developer/
#RUN . $NVM_DIR/nvm.sh && \
#    nvm install $NODE_VERSION && nvm alias default $NODE_VERSION && nvm use default && \
#	npm config set registry http://registry.npm.taobao.org && \
##   npm config set registry http://registry.cnpmjs.org && \
#    npm install -g bower grunt-cli gulp forever yo \
#    generator-gulp-angular generator-ionic-gulp \
#    compass cordova ionic && \
#	gem sources --remove https://rubygems.org/  && \
#	gem source -a http://ruby.taobao.org && \ 
#	gem install sass && \
#    npm cache clear && \
#    /bin/bash -c "source $HOME/.bashrc"
RUN . $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION && nvm use default && \
    npm install -g bower grunt grunt-cli gulp yo cordova ionic forever --user "developer" && \
	npm cache clear && \
    /bin/bash -c "source $HOME/.bashrc"

WORKDIR /home/developer
ENTRYPOINT ["/bin/bash"]
