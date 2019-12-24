FROM python:3.7.2-alpine

# install dependencies
RUN apk update && \
    apk add --virtual build-deps gcc python-dev musl-dev

# set working directory
WORKDIR /usr/src/app

# add and install requirements
COPY ./requirements/install.txt /usr/src/app/requirements.txt
RUN pip install -r requirements.txt

COPY ./src/ /usr/src/app


# add entrypoint.sh
COPY ./entrypoint.sh /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

# add app

# run server
CMD ["/usr/src/app/entrypoint.sh"]