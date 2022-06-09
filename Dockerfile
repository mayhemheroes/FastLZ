FROM --platform=linux/amd64 ubuntu:20.04 as builder

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential

ADD . /repo
WORKDIR /repo/examples
RUN make -j8

RUN mkdir -p /deps
RUN ldd /repo/examples/6pack | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04 as package

COPY --from=builder /deps /deps
COPY --from=builder /repo/examples/6pack /repo/examples/6pack
ENV LD_LIBRARY_PATH=/deps
