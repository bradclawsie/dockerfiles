FROM debian:stretch

RUN apt-get update && apt-get -y install git libssl-dev build-essential wget curl

RUN mkdir -p /app/rakudo
WORKDIR /app/rakudo

RUN git clone https://github.com/tadzik/rakudobrew /app/rakudo/.rakudobrew
ENV PATH="/app/rakudo/.rakudobrew/bin:${PATH}"

ENV RAKUDOVERSION=2019.03.1

RUN rakudobrew build moar ${RAKUDOVERSION}
RUN rakudobrew local moar-${RAKUDOVERSION}
RUN rakudobrew global moar-${RAKUDOVERSION}
RUN rakudobrew build zef
RUN zef install Linenoise
zef install UUID
zef install JSON::Tiny
zef install DBIish
zef install --verbose --/test cro
zef install Redis
zef install JSON::JWT
zef install --/test Lumberjack
zef install Data::Dump

CMD ["tail","-f","/dev/null"]
