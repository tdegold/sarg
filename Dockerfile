FROM ubuntu:22.04 AS maxima-installer

RUN apt update && \
    apt install -y \
    gnuplot \
    make \
    sbcl \
    wget

COPY installmaxima.sh /opt

WORKDIR /opt

RUN sh ./installmaxima.sh

FROM rocker/r-ubuntu:22.04

RUN apt-get update && \
    apt-get install -y gnuplot pandoc texlive-latex-recommended texlive-pictures texlive-latex-extra

RUN install2.r --error \
    DT \
    exams \
    rim \
    rmarkdown \
    shiny \
    shinydashboard \
    stringr \
    xtable

COPY --from=maxima-installer    /usr/local/lib/maxima /usr/local/lib/maxima 
COPY --from=maxima-installer    /usr/local/share/maxima /usr/local/share/maxima 
COPY --from=maxima-installer    /usr/local/share/bash-completion/completions/maxima /usr/local/share/bash-completion/completions/maxima 
COPY --from=maxima-installer    /usr/local/bin/maxima /usr/local/bin/maxima 
COPY --from=maxima-installer    /usr/local/libexec/maxima /usr/local/libexec/maxima

RUN mkdir -p /home/docker/src

WORKDIR /home/docker/src

COPY . .

RUN chown -R docker:docker /home/docker

EXPOSE 3838

USER docker

CMD R -e "shiny::runApp(appDir='R', host='0.0.0.0', port=3838)"