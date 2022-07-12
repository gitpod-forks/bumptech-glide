FROM gitpod/workspace-full-vnc
SHELL ["/bin/bash", "-c"]

USER gitpod

ENV VERSION_TOOLS "8512546"
ENV ANDROID_HOME "/sdk"

# Keep alias for compatibility
ENV PATH "$PATH:${ANDROID_HOME}/cmdline-tools/cmdline-tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/ndk-bundle:${ANDROID_HOME}/tools"
ENV DEBIAN_FRONTEND noninteractive

USER root

RUN apt-get -qq update \
 && apt-get install -qqy --no-install-recommends \
      bzip2 \
      curl \
      git-core \
      html2text \
      openjdk-17-jdk \
      libc6-i386 \
      lib32stdc++6 \
      lib32gcc1 \
      lib32ncurses6 \
      lib32z1 \
      unzip \
      locales \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN rm -f /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure
RUN curl -s https://dl.google.com/android/repository/commandlinetools-linux-${VERSION_TOOLS}_latest.zip > /tools.zip \
 && mkdir -p ${ANDROID_HOME}/cmdline-tools \
 && unzip /tools.zip -d ${ANDROID_HOME}/cmdline-tools \
 && rm -v /tools.zip

RUN mkdir -p $ANDROID_HOME/licenses/ \
 && yes | ${ANDROID_HOME}/cmdline-tools/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses >/dev/null

RUN mkdir -p /root/.android \
 && touch /root/.android/repositories.cfg \
 && ${ANDROID_HOME}/cmdline-tools/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --update

RUN bash -c "source ~/.sdkman/bin/sdkman-init.sh"
RUN yes | sdkmanager "platform-tools" "build-tools;31.0.0" "platforms;android-31"
RUN yes | sdkmanager --licenses
