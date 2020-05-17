FROM python:3.6-slim

# Build Args
ARG APP_HOME
ARG MIRROR_URL
ARG MIRROR_HOST

# ENV vars for using the pythonproxy
ENV APP_HOME=${APP_HOME:-/app}
ENV MIRROR_URL=${MIRROR_URL}
ENV MIRROR_HOST=${MIRROR_HOST}
ENV PIPENV_PYPI_MIRROR=${MIRROR_URL}
ENV PIP_INDEX_URL=${MIRROR_URL:+${MIRROR_URL}/+simple/}
ENV PIP_TRUSTED_HOST=${MIRROR_HOST}

# python/pipenv setup and activate overrides
ENV PATH="${APP_HOME}/.venv/bin:${PATH}" \
    PIPENV_PYTHON="${APP_HOME}/bin/python" \
    PIPENV_YES=1 \
    PIPENV_MAX_SUBPROCESS=5 \
    PIPENV_VENV_IN_PROJECT=1 \
    PYTHONUNBUFFERED=1

### End of what you need to do to use the mirror
### more normal dockerfile stuff

WORKDIR ${APP_HOME}

RUN apt-get update && \
    apt-get install --no-install-recommends -y uwsgi dumb-init

# RUN pip install pipenv virtualenv

COPY ./project/requirements.txt ${APP_HOME}/requirements.txt

# RUN pipenv install --python=$(which python) --verbose

RUN pip install -r requirements.txt

# ENV STATIC_URL /static
# ENV STATIC_PATH /var/www/app/static

# COPY ./requirements.txt /var/www/requirements.txt
# RUN pip install -r /var/www/requirements.txt

