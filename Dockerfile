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
        -D BUILD_opencv_dnn=ON \
        -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-${OPENCV_VERSION}/modules \
        -D BUILD_opencv_aruco=OFF \
        -D BUILD_opencv_bgsegm=OFF \
        -D BUILD_opencv_bioinspired=OFF \
        -D BUILD_opencv_ccalib=OFF \
        -D BUILD_opencv_cnn_3dobj=OFF \
        -D BUILD_opencv_cvv=OFF \
        -D BUILD_opencv_datasets=OFF \
        -D BUILD_opencv_dnns_easily_fooled=OFF \
        -D BUILD_opencv_dpm=OFF \
        -D BUILD_opencv_face=OFF \
        -D BUILD_opencv_fuzzy=OFF \
        -D BUILD_opencv_freetype=OFF \
        -D BUILD_opencv_hdf=OFF \
        -D BUILD_opencv_line_descriptor=OFF \
        -D BUILD_opencv_matlab=OFF \
        -D BUILD_opencv_optflow=OFF \
        -D BUILD_opencv_ovis=OFF \
        -D BUILD_opencv_plot=OFF \
        -D BUILD_opencv_reg=OFF \
        -D BUILD_opencv_rgbd=OFF \
        -D BUILD_opencv_saliency=OFF \
        -D BUILD_opencv_sfm=OFF \
        -D BUILD_opencv_stereo=OFF \
        -D BUILD_opencv_structured_light=OFF \
        -D BUILD_opencv_surface_matching=OFF \
        -D BUILD_opencv_text=OFF \
        -D BUILD_opencv_tracking=ON \
        -D BUILD_opencv_xfeatures2d=OFF \
        -D BUILD_opencv_ximgproc=OFF \
        -D BUILD_opencv_xobjdetect=OFF \
        -D BUILD_opencv_xphoto=OFF \
        .. && \
        make -j"$(nproc)" && \
        make install && \
        ldconfig && \
        rm -rf /opt/opencv-${OPENCV_VERSION} && \
        rm -rf /opt/opencv_contrib-${OPENCV_VERSION}
