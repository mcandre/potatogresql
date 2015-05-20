FROM mcandre/docker-debian:potato
MAINTAINER Andrew Pennebaker <andrew.pennebaker@gmail.com>

RUN apt-get update && \
		apt-get install -y wget patch

RUN apt-get install -y strace gdb less

ADD fix-postinstall.patch /

RUN wget http://archive.kernel.org/debian-archive/debian/dists/potato/main/binary-i386/misc/postgresql_6.5.3-27.deb
RUN dpkg --unpack postgresql_6.5.3-27.deb
RUN cd /var/lib/dpkg/info && \
		patch --verbose -p1 -i /fix-postinstall.patch
RUN apt-get install -yf

ENV PGDATA /var/lib/postgres/data
ENV POSTGRES_HOM /var/lib/postgres/data
ENV PGLIB /usr/lib/postgresql/lib
ENV PGACCESS_HOME /usr/lib/postgresql/pgaccess

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN echo "host all all 0.0.0.0/0 trust" >> /etc/postgresql/pg_hba.conf && \
    chown -R postgres:postgres /etc/postgresql && \
    chown -R postgres:postgres /var/lib/postgres

# RUN echo "listen_addresses='*'" >> /etc/postgresql/9.1/main/postgresql.conf

EXPOSE 5432

ADD postgres /postgres
# ENTRYPOINT /postgres
