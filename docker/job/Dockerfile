FROM python:3.10-bullseye

# set timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

COPY job /opt/job

WORKDIR /opt/job

RUN pip3 install --upgrade pip && pip3 install -r requirements.txt

COPY docker/job/entrypoint.sh /entrypoint.sh

RUN chmod 755 /entrypoint.sh

ENTRYPOINT []
CMD ["entrypoint.sh"]