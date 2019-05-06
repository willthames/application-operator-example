FROM quay.io/operator-framework/ansible-operator:v0.7.0 AS operator

FROM alpine:3.9
COPY --from=operator /usr/local/bin /usr/local/bin
ENTRYPOINT /usr/local/bin/entrypoint
RUN apk add --no-cache git ansible python3
RUN apk add --no-cache -t .build-deps gcc musl-dev python3-dev linux-headers && \
    python3 -m pip install ansible-runner jmespath kubernetes openshift && \
    apk del .build-deps
RUN apk add --no-cache bash
USER 65534
ENV RUNNER_BASE_COMMAND ansible-playbook
ENV OPERATOR /usr/local/bin/ansible-operator
ENV USER_UID 1001
ENV USER_NAME ansible-operator
ENV HOME /opt/ansible
