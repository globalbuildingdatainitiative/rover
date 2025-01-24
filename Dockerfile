ARG VERSION

FROM debian:stable-slim AS installer
ARG VERSION

RUN apt-get update && apt-get install -y curl unzip

RUN curl -sSL https://rover.apollo.dev/nix/${VERSION} | sh
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip -d /root/aws


FROM debian:stable-slim AS runner
ARG VERSION

COPY --from=installer /root/.rover/bin/rover /root/.rover/bin/rover
COPY --from=installer /root/aws/aws /root/aws

ENV PATH="/root/.rover/bin:${PATH}"
ENV ROVER_VERSION=$VERSION

RUN bash /root/aws/install

RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/* && apt-get clean
