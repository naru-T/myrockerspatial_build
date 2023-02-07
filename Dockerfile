#FROM rocker/geospatial:4.1.2
FROM rocker/rstudio:latest-daily
RUN chown rstudio:rstudio -R /home/rstudio/
RUN chmod -R 775 /home/rstudio/
COPY ./ /home/rstudio/
RUN chmod -R 775 /home/rstudio/
RUN chown rstudio:rstudio -R /home/rstudio/

RUN apt-get update &&\
    apt-get install -y binutils libproj-dev gdal-bin libgdal-dev libudunits2-dev fonts-ipafont libfontconfig1-dev

RUN install2.r --error \
  remotes \
  sf \
  lwgeom \
  tidyverse \
  stars \
  tmap \
  tmaptools \
  sp \
  shinythemes \
  shinydashboard \
  spdplyr \
  here \
  GWmodel \
  data.table \
  viridis \
  gridExtra \
  colorspace \
  rasterVis \
  kableExtra \
  doMC \
  foreach \
  renv \
  tinytex


# RUN Rscript -e "remotes::install_github('naru-T/MyRMiscFunc')"
RUN Rscript -e "tinytex::install_tinytex()"


#https://hub.docker.com/r/rocker/verse/dockerfile
