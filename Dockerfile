FROM ocaml/opam:alpine-3.5_ocaml-4.03.0
RUN cd /home/opam/opam-repository && git pull origin master && opam update -uy
RUN cd /tmp && curl -OL https://test.docker.com/builds/Linux/x86_64/docker-1.13.1-rc2.tgz && tar -zxvf docker-1.13.1-rc2.tgz docker/docker && sudo mv docker/docker /usr/bin && rm -f docker-1.13.0-rc7.tgz
RUN opam pin add -n datakit-server.dev git://github.com/docker/datakit
RUN opam pin add -n datakit-github.dev git://github.com/docker/datakit
RUN opam pin add -n datakit-client.dev git://github.com/docker/datakit
RUN opam pin add -n datakit-bridge-github.dev git://github.com/docker/datakit
RUN opam pin add -n datakit-ci.dev https://github.com/avsm/datakit.git#fix-meta
RUN opam depext -uivy -j 4 datakit-ci conf-libev
RUN opam depext -uivy -j 4 toml irmin-unix ezjsonm dockerfile bos ptime fmt
ADD . /home/opam/src
RUN sudo chown -R opam /home/opam/src
RUN opam pin add -n mirage-ci /home/opam/src
RUN opam install -vy -j 4 mirage-ci
ENV CONDUIT_TLS=native
ENV OCAMLRUNPARAM=b
USER root
CMD []
