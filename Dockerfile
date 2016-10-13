FROM openshift/base-centos7

ENV LETSENCRYPT_SH_COMMIT=a316a094df8d3d4b25673cfbb1197f646781e48f \
    LETSENCRYPT_DATADIR=/var/lib/letsencrypt-container \
    LETSENCRYPT_LIBEXECDIR=/usr/libexec/letsencrypt-container \
    LETSENCRYPT_SHAREDIR=/usr/share/letsencrypt-container

USER 0

RUN curl -sSL https://github.com/lukas2511/dehydrated/raw/$LETSENCRYPT_SH_COMMIT/dehydrated \
         -o /usr/bin/dehydrated \
 && chmod +x /usr/bin/dehydrated \
 && yum install -y openssl curl nss_wrapper \
 && yum clean all

ENV JQ_VERSION 1.5

# Install jq
# http://stedolan.github.io/jq/
RUN curl -o /usr/local/bin/jq -L https://github.com/stedolan/jq/releases/download/jq-$JQ_VERSION/jq-linux64 \
 && chmod +x /usr/local/bin/jq

USER 1001

ADD libexec/ $LETSENCRYPT_LIBEXECDIR
ADD share/ $LETSENCRYPT_SHAREDIR

ENTRYPOINT ["/usr/libexec/letsencrypt-container/entrypoint"]
CMD ["usage"]
