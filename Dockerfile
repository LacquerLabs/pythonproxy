FROM python:3.6-slim

ARG APP_HOME
ARG APP_PORT
# ARG MIRROR_URL

LABEL org.label-schema.name="PythonProxy" \
      org.label-schema.description="Simple PythonProxy with devpi" \
      org.label-schema.url="https://github.com/LacquerLabs/pythonproxy" \
      org.label-schema.vcs-url="https://github.com/LacquerLabs/pythonproxy" \
      org.label-schema.vendor="LacquerLabs"

### SETUP PORTABLE PYTHON ENV ###

ENV APP_HOME=${APP_HOME:-/app}
ENV APP_PORT=${APP_PORT:-3141}
ENV CLIENT_HOST=host.docker.internal
ENV CLIENT_PORT=${APP_PORT}

# ENV PIPENV_PYPI_MIRROR=${MIRROR_URL}
# ENV PIP_INDEX_URL=${MIRROR_URL}/+simple/

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
COPY ./scripts /scripts
RUN apt-get update && \
    apt-get install --no-install-recommends -y dumb-init && \
    rm -rf /var/lib/apt/lists/* && \
    chmod a+x /scripts/*.sh && \
    pip install pipenv virtualenv

## copy over our Pipfiles for max cache effort
# how pipfile was generated:
#   - pipenv install --python=$(which python) devpi-server devpi-client devpi-web
COPY ./app/Pipfile ${APP_HOME}/Pipfile
COPY ./app/Pipfile.lock ${APP_HOME}/Pipfile.lock

# run our package install with sync since we already have a valid lockfile
RUN pipenv sync --python=$(which python) --verbose

### END PYTHON ENV SETUP ###
# prep and start as user
RUN chmod a+rw -R ${APP_HOME}
USER docker
### SETUP APP ###

ENV DEVPISERVER_SERVERDIR=${APP_HOME}/server \
    DEVPICLIENT_CLIENTDIR=${APP_HOME}/client

RUN mkdir -p ${DEVPISERVER_SERVERDIR} ${DEVPICLIENT_CLIENTDIR}

### END APP SETUP ###

VOLUME ${APP_HOME}/server
EXPOSE ${APP_PORT}
ENTRYPOINT [ "/scripts/entrypoint.sh" ]
CMD [ "default" ]