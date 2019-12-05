FROM rocker/geospatial:3.6.0
RUN Rscript -e "install.packages(c('shiny', 'shinythemes','shinydashboard','remotes','leaflet','corpcor','doParallel','here','spdplyr','GWmodel','spgwr','sf','stars','tmap','tmaptools'), repos='http://cran.rstudio.com/')"
RUN Rscript -e "remotes::install_github('naru-T/MyRMiscFunc')"

COPY ./ /home/rstudio/
RUN chown rstudio:rstudio -R /home/rstudio/.
RUN chmod -R 775 /home/rstudio/.


RUN Rscript -e "install.packages('/home/rstudio/pkg/gwpcor_0.1.1.tar.gz', repos = NULL, type = 'source')"
