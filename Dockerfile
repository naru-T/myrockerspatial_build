FROM rocker/geospatial:3.6.0

RUN chown rstudio:rstudio -R /home/rstudio/
RUN chmod -R 775 /home/rstudio/
COPY ./ /home/rstudio/
RUN chmod -R 775 /home/rstudio/
RUN chown rstudio:rstudio -R /home/rstudio/

RUN install2.r --error \
  shinythemes \ 
  shinydashboard \  
  spdplyr \ 
  here \
  lwgeom \
  tmap \
  tmaptools \
  stars
