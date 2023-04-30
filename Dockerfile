#FROM python:3.8-slim
FROM nvidia/cuda:11.2.0-base-ubuntu20.04 as runtime

WORKDIR /app

RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
        gcc-9 \
        g++-9 \
        gfortran-9 \
        libopenblas-dev \
        liblapack-dev \
        pkg-config \
        curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/bin/gcc-9 /usr/bin/gcc && \
    ln -s /usr/bin/g++-9 /usr/bin/g++ && \
    ln -s /usr/bin/gfortran-9 /usr/bin/gfortran



# Install miniconda
ARG CONDA_DIR=/opt/conda
ENV CONDA_DIR=${CONDA_DIR}
ENV PATH=${CONDA_DIR}/bin:${PATH}
RUN curl -sLo miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x ./miniconda.sh && \
    ./miniconda.sh -b -p ${CONDA_DIR} && \
    rm miniconda.sh

COPY ./environment.yaml ./
RUN conda env create -f environment.yaml && \
    conda init bash

#SHELL ["/bin/bash", "--login", "-c"]
#RUN conda activate generspeech

ENTRYPOINT ["bash"]
