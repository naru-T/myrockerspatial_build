FROM rocker/geospatial:4.0.３

RUN chown rstudio:rstudio -R /home/rstudio/
RUN chmod -R 775 /home/rstudio/
COPY ./ /home/rstudio/
RUN chmod -R 775 /home/rstudio/
RUN chown rstudio:rstudio -R /home/rstudio/

RUN apt-get update &&\
    apt-get install -y binutils libproj-dev gdal-bin

RUN install2.r --error \
  remotes \
  shinythemes \
  shinydashboard \
  spdplyr \
  here \
  lwgeom \
  tmap \
  tmaptools \
  stars \
  GWmodel \
  gwrr \
  spgwr \
  viridis \
  gridExtra \
  colorspace \
  scales \
  rasterVis \
  knitr \
  kableExtra \
  doMC \
  foreach \
  renv \
  tinytex


RUN Rscript -e "remotes::install_github('naru-T/MyRMiscFunc')"
RUN Rscript -e "tinytex::install_tinytex()"


#https://hub.docker.com/r/rocker/verse/dockerfile
