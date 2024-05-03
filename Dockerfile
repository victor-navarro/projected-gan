FROM nvidia/cuda:11.8.0-base-ubuntu22.04

WORKDIR /pg

# Remove any third-party apt sources to avoid issues with expiring keys.
RUN rm -f /etc/apt/sources.list.d/*.list

# Install some basic utilities
RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
    && rm -rf /var/lib/apt/lists/*

## MINICONDA INSTALLATION 
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-py38_23.11.0-2-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-py38_23.11.0-2-Linux-x86_64.sh -b \
    && rm -f Miniconda3-py38_23.11.0-2-Linux-x86_64.sh

## COPY FILES
COPY . .
## CREATE CONDA ENVIRONMENT
RUN conda env create -f environment.yml
ENV PATH /opt/conda/envs/env/bin:$PATH
RUN echo "source activate pg" > ~/.bashrc
RUN echo "conda activate pg" > ~/.profile