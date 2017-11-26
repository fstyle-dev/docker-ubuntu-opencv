FROM ubuntu:16.04

ARG OPENCV_VERSION=3.3.1

RUN apt-get update && \
    apt-get install -y \
      wget \
      unzip \
      build-essential \
      cmake \
      pkg-config \
      # image loading
      libjpeg8-dev \
      libtiff5-dev \
      libjasper-dev \
      libpng12-dev \
      libgtk-3-dev \
      # webcam
      libv4l-dev \
      libatlas-base-dev \
      gfortran && \

      # download and extract opencv
      mkdir -p /opt && cd /opt && \
      wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
      unzip ${OPENCV_VERSION}.zip && \
      rm -rf ${OPENCV_VERSION}.zip && \

      # download and extract opencv-contrib
      wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip && \
      unzip ${OPENCV_VERSION}.zip && \
      rm -rf ${OPENCV_VERSION}.zip && \

      # compile opencv
      mkdir -p /opt/opencv-${OPENCV_VERSION}/build && \
      cd /opt/opencv-${OPENCV_VERSION}/build && \
      cmake \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D ENABLE_PRECOMPILED_HEADERS=OFF \
        -D BUILD_SHARED_LIBS=OFF \
        -D WITH_FFMPEG=OFF \
        -D WITH_1394=OFF \
        -D WITH_IPP=OFF \
        -D WITH_OPENEXR=OFF \
        -D WITH_TBB=YES \
        -D WITH_WEBP=OFF \
        -D WITH_JASPER=ON \
        -D BUILD_TBB=ON \
        -D BUILD_FAT_JAVA_LIB=OFF \
        -D BUILD_TESTS=OFF \
        -D BUILD_PERF_TESTS=OFF \
        -D BUILD_EXAMPLES=OFF \
        -D BUILD_ANDROID_EXAMPLES=OFF \
        -D INSTALL_PYTHON_EXAMPLES=OFF \
        -D INSTALL_C_EXAMPLES=OFF \
        -D BUILD_DOCS=OFF \
        -D BUILD_opencv_python2=OFF \
        -D BUILD_opencv_python3=OFF \
        -D BUILD_opencv_apps=OFF \
        -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-${OPENCV_VERSION}/modules \
        .. && \
        make -j"$(nproc)" && \
        make install && \
        ldconfig && \
        rm -rf /opt/opencv-${OPENCV_VERSION} && \
        rm -rf /opt/opencv_contrib-${OPENCV_VERSION}
