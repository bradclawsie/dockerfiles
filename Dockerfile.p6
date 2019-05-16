FROM debian:stretch

RUN apt-get update && apt-get -y install git libssl-dev build-essential wget curl
RUN git clone https://github.com/tadzik/rakudobrew ~/.rakudobrew
ENV RAKUDOVERSION=2019.03.1
RUN rakudobrew build moar ${RAKUDOVERSION}
RUN rakudobrew local moar-${RAKUDOVERSION}
RUN rakudobrew global moar-${RAKUDOVERSION}
RUN rakudobrew build zef
RUN zef install Linenoise
RUN zef install UUID
RUN zef install JSON::Tiny
RUN zef install DBIish
RUN zef install --verbose --/test cro
RUN zef install Redis
RUN zef install JSON::JWT
RUN zef install --/test Lumberjack
RUN zef install Data::Dump

CMD ["tail","-f","/dev/null"]
