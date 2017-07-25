FROM andreroquem/ocaml-build

MAINTAINER André Roque Matheus <amatheus@mac.com>

RUN mkdir /app

COPY . /app

RUN cd /app; ocaml setup.ml -configure --enable-tests ; make test
