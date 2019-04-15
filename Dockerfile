FROM tensorflow/tensorflow:1.8.0--gpu-py3

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

RUN apt-get update
RUN apt-get install -y --no-install-recommends --allow-unauthenticated \
  zip \
  gzip \
  make \
  automake \
  gcc \
  build-essential \
  g++ \
  cpp \
  libc6-dev \
  man-db \
  autoconf \
  pkg-config \
  unzip \
  libffi-dev \
  software-properties-common \
  locales \
  wget \
  git


# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN mkdir -p /hexaf/fever
WORKDIR /hexaf/fever

ADD initial_setup_fever2.sh /hexaf/fever/
RUN chmod +x initial_setup_fever2.sh && initial_setup_fever2.sh

ADD predict.sh .

ENV PYTHONPATH /hexaf/fever/:/hexaf/jack/:src
ENV FLASK_APP app:hexaf_fever

#ENTRYPOINT ["/bin/bash","-c"]
CMD ["waitress-serve", "--host=0.0.0.0", "--port=5000", "--call", "app:hexaf_fever"]