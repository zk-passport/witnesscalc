FROM rust:1.81 as builder

RUN apt-get update
RUN apt-get install build-essential cmake libgmp-dev libsodium-dev nasm curl m4 -y

WORKDIR /circuits
COPY . .

RUN ./build_gmp.sh host && \
    make host 
RUN ./build_witnesses.sh