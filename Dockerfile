FROM rocker/geospatial:3.6.0

RUN chown rstudio:rstudio -R /home/rstudio/
RUN chmod -R 775 /home/rstudio/
COPY ./ /home/rstudio/
RUN chmod -R 775 /home/rstudio/
RUN chown rstudio:rstudio -R /home/rstudio/

RUN apt-get update &&\
    apt-get install -y binutils libproj-dev gdal-bin

RUN install2.r --error \
  shinythemes \
  shinydashboard \
  spdplyr \
  here \
  lwgeom \
  tmap \
  tmaptools \
  stars \
  GWmodel


RUN Rscript -e "remotes::install_github('naru-T/MyRMiscFunc')"

