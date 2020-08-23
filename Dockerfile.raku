FROM alpine:latest

ARG VER="2020.08"
LABEL version="2.3.2" rakuversion=$VER

ENV PATH="/root/raku-install/bin:/root/raku-install/share/perl6/site/bin:/root/.rakudobrew/bin:${PATH}" \
    PKGS="curl git" \
    PKGS_TMP="perl curl-dev linux-headers make gcc musl-dev wget" \
    ENV="/root/.profile"

RUN mkdir /home/raku \
    && apk update && apk upgrade \
    && apk add --no-cache $PKGS $PKGS_TMP \
    && git clone https://github.com/tadzik/rakudobrew ~/.rakudobrew \
    && eval "$(~/.rakudobrew/bin/rakudobrew init Sh)"\
    && rakudobrew build moar $VER --configure-opts='--prefix=/root/raku-install' \
	&& rm -rf /root/.rakudobrew/versions/moar-$VER \
	&& rakudobrew register moar-$VER /root/raku-install \
    && rakudobrew global moar-$VER \
    && rakudobrew build-zef \
    && zef install Linenoise App::Prove6 \
    && apk del $PKGS_TMP \
    && rm -rf /root/.rakudobrew /root/raku-install/zef

# Runtime
WORKDIR /home/raku
CMD ["tail", "-f", "/dev/null"]
