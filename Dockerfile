FROM ubuntu:latest
FROM perl:latest
WORKDIR /opt/simple-search
COPY . .
RUN apt-get update && apt-get install -qyf libmecab-dev
RUN cpanm -n Mojolicious UUID Lingua::TFIDF Data::Dumper::Concise Test::More List::MoreUtils