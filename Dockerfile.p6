FROM debian:stable

WORKDIR /root
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update && apt-get -y install git libssl-dev build-essential wget curl libsqlite3-dev libpq-dev
RUN git clone https://github.com/tadzik/rakudobrew ~/.rakudobrew
ENV RAKUDOVERSION=master
RUN /root/.rakudobrew/bin/rakudobrew init Bash > /root/.profile
RUN cp /root/.profile /root/.bash_profile
RUN cp /root/.profile /.profile
RUN cp /root/.profile /.bash_profile
RUN source /root/.profile
RUN echo "source .profile" >> /root/.bashrc
RUN bash -c "source .profile && rakudobrew build moar ${RAKUDOVERSION}"
RUN bash -c "source .profile && rakudobrew global moar-${RAKUDOVERSION}"
RUN bash -c "source .profile && rakudobrew build zef"
RUN mkdir -p /app/rakudo/bin
RUN ln -s /root/.rakudobrew/versions/moar-${RAKUDOVERSION} /app/rakudo/version
RUN echo 'export PATH=${PATH}:/app/rakudo/version' >> /root/.bashrc
RUN echo "rakudobrew global moar-${RAKUDOVERSION}" >> /root/.bashrc
RUN echo '#!/bin/bash' > /app/rakudo/bin/perl6
RUN echo 'source /root/.profile' >> /app/rakudo/bin/perl6
RUN echo "rakudobrew global moar-${RAKUDOVERSION}" >> /app/rakudo/bin/perl6
RUN echo 'perl6 "$@"' >> /app/rakudo/bin/perl6
RUN chmod a+rx /app/rakudo/bin/perl6
RUN ln -s /app/rakudo/bin/perl6 /app/rakudo/bin/raku
RUN bash -c "source .profile && rakudobrew global moar-${RAKUDOVERSION};which zef;zef install Linenoise"
RUN bash -c "source .profile && rakudobrew global moar-${RAKUDOVERSION};zef install UUID"
RUN bash -c "source .profile && rakudobrew global moar-${RAKUDOVERSION};zef install JSON::Tiny"
RUN bash -c "source .profile && rakudobrew global moar-${RAKUDOVERSION};zef install --/test DBIish"
RUN bash -c "source .profile && rakudobrew global moar-${RAKUDOVERSION};zef install Redis"
RUN bash -c "source .profile && rakudobrew global moar-${RAKUDOVERSION};zef install JSON::JWT"
RUN bash -c "source .profile && rakudobrew global moar-${RAKUDOVERSION};zef install Data::Dump"
RUN bash -c "source .profile && rakudobrew global moar-${RAKUDOVERSION};zef install --verbose --/test cro"
RUN bash -c "source .profile && rakudobrew global moar-${RAKUDOVERSION};zef install HTTP::UserAgent"
RUN bash -c "source .profile && rakudobrew global moar-${RAKUDOVERSION};zef install WWW"
RUN bash -c "source .profile && rakudobrew global moar-${RAKUDOVERSION};zef install Log::Async"
EXPOSE 3000

CMD ["tail","-f","/dev/null"]
