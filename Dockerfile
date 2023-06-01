FROM perl:5.36-bullseye
WORKDIR /opt/webservice
COPY . .
RUN apt update && apt install -y poppler-utils
RUN cpanm --installdeps -n .
EXPOSE 3000
CMD ./webservice.pl prefork
