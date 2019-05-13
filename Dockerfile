FROM rocker/geospatial:3.6.0
RUN Rscript -e "install.packages(c('shiny', 'shinythemes','shinydashboard','remotes','leaflet','corpcor','doParallel','here','spdplyr','GWmodel','spgwr'), repos='http://cran.rstudio.com/')"
RUN Rscript -e "remotes::install_github('naru-T/MyRMiscFunc')"

RUN mkdir -p /home/rstudio/Codes
WORKDIR /home/rstudio/Codes/
RUN chown rstudio:rstudio -R /home/rstudio/Codes
RUN chmod -R 775 /home/rstudio/Codes
COPY ./ /home/rstudio/
RUN chmod -R 775 /home/rstudio/Codes/
RUN chown rstudio:rstudio -R /home/rstudio/Codes/


RUN mkdir -p /home/rstudio/pkg
RUN chown rstudio:rstudio -R /home/rstudio/pkg
RUN chmod -R 775 /home/rstudio/pkg
COPY ./pkg/ /home/rstudio/pkg/
RUN chown rstudio:rstudio -R /home/rstudio/pkg/
RUN chmod -R 775 /home/rstudio/pkg/

RUN Rscript -e "install.packages('/home/rstudio/pkg/gwpcor_0.1.1.tar.gz', repos = NULL, type = 'source')"
