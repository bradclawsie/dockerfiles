FROM debian:bullseye-slim

ENV RAKUDOVERSION=2019.11
WORKDIR /root
USER root
RUN apt-get update && apt-get -y install git build-essential wget curl
RUN git clone https://github.com/tadzik/rakudobrew /root/.rakudobrew
RUN /root/.rakudobrew/bin/rakudobrew init Bash >> /root/.profile
RUN bash -c "source .profile && rakudobrew build moar ${RAKUDOVERSION} && rakudobrew global moar-${RAKUDOVERSION} && rakudobrew build zef"
RUN ln -s /root/.rakudobrew/versions/moar-${RAKUDOVERSION}/install /rakudo
RUN ln -s /root/.rakudobrew/versions/moar-${RAKUDOVERSION}/zef /zef
RUN echo 'export PATH=${PATH}:/rakudo/bin:/zef/bin' >> /root/.bashrc
RUN bash -c "source .profile && rakudobrew global moar-${RAKUDOVERSION} && zef install Linenoise App::Prove6 Data::Dump"
RUN rm -rf /root/.rakudobrew/versions/moar-${RAKUDOVERSION}/src /root/zef /root/.rakudobrew/git_reference
ENTRYPOINT ["/rakudo/bin/raku"]
