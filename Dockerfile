FROM andreroquem/ocaml-build

MAINTAINER André Roque Matheus <amatheus@mac.com>

RUN mkdir /home/ocaml/app

COPY . /home/ocaml/app

RUN sudo chown -R ocaml:ocaml /home/ocaml/app

WORKDIR /home/ocaml/app

ENV PATH="/home/ocaml/.opam/system/bin/:${PATH}"

RUN opam config env > ~/opamenv

RUN rm -f setup.data

RUN . ~/opamenv && oasis setup -setup-update dynamic

RUN . ~/opamenv && ocaml setup.ml -clean

RUN . ~/opamenv && ocaml setup.ml -configure --enable-tests

RUN . ~/opamenv && make clean test
