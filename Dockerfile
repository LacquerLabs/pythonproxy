FROM python:3.6-slim

ARG APP_HOME
ARG APP_PORT

# For fancy badges
# Build-time metadata as defined at http://label-schema.org
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.name="PythonProxy" \
        org.label-schema.description="Simple PythonProxy with devpi" \
        org.label-schema.url="https://github.com/LacquerLabs/pythonproxy" \
        org.label-schema.vcs-ref=$VCS_REF \
        org.label-schema.vcs-url="https://github.com/LacquerLabs/pythonproxy" \
        org.label-schema.vendor="LacquerLabs" \
        org.label-schema.version=$VERSION \
        org.label-schema.schema-version="1.0"

### SETUP PORTABLE PYTHON ENV ###

ENV APP_HOME=${APP_HOME:-/app}
ENV APP_PORT=${APP_PORT:-3141}

# python/pipenv setup and activate overrides
ENV PATH="${APP_HOME}/.venv/bin:${PATH}" \
    PIPENV_PYTHON="${APP_HOME}/bin/python" \
    PIPENV_YES=1 \
    PIPENV_VERBOSE=1 \
    PIPENV_VENV_IN_PROJECT=1 \
    PYTHONUNBUFFERED=1

# setup user
ENV USER=docker \
    UID=501 \
    GID=501
RUN addgroup --gid "${GID}" "${USER}" && \
    adduser --disabled-password --gecos "" --home "${APP_HOME}" \
    --ingroup "${USER}" --no-create-home --uid "${UID}" "${USER}"

# setup app space
WORKDIR ${APP_HOME}
COPY entrypoint.sh /entrypoint.sh
COPY add_mirror.sh /add_mirror.sh
RUN apt-get update && \
    apt-get install --no-install-recommends -y dumb-init && \
    rm -rf /var/lib/apt/lists/* && \
    chmod a+x /entrypoint.sh /add_mirror.sh && \
    pip install pipenv virtualenv

## copy over our Pipfiles for max cache effort
# pipenv install --python=$(which python) devpi-server devpi-client devpi-web
COPY Pipfile /${APP_HOME}/Pipfile
COPY Pipfile.lock /${APP_HOME}/Pipfile.lock
# run our package install with sync since we already have a valid lockfile
RUN pipenv sync --python=$(which python) --verbose

### END PYTHON ENV SETUP ###
# prep and start as user
RUN chmod a+rw -R ${APP_HOME}
USER docker
### SETUP APP ###

ENV DEVPISERVER_SERVERDIR=/${APP_HOME}/server \
    DEVPICLIENT_CLIENTDIR=/${APP_HOME}/client

RUN mkdir -p ${DEVPISERVER_SERVERDIR} ${DEVPICLIENT_CLIENTDIR}

# temporarily start and initialize the devpi-server
RUN devpi-init --serverdir ${DEVPISERVER_SERVERDIR} && \
    ( devpi-server --host 0.0.0.0 --port ${APP_PORT} --serverdir ${DEVPISERVER_SERVERDIR} & ) && \
    sleep 4 && \
    devpi --clientdir ${DEVPICLIENT_CLIENTDIR} use http://localhost:${APP_PORT} && \
    devpi --clientdir ${DEVPICLIENT_CLIENTDIR} login root --password='' && \
    devpi --clientdir ${DEVPICLIENT_CLIENTDIR} index -c root/mirror bases=root/pypi volatile=True mirror_whitelist="*"

### END APP SETUP ###

VOLUME ${APP_HOME}
EXPOSE ${APP_PORT}
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "default" ]