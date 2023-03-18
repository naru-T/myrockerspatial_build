#FROM rocker/geospatial:4.1.2
FROM rocker/rstudio:latest-daily
RUN chown rstudio:rstudio -R /home/rstudio/
RUN chmod -R 775 /home/rstudio/
COPY ./ /home/rstudio/
RUN chmod -R 775 /home/rstudio/
RUN chown rstudio:rstudio -R /home/rstudio/

# Install Python stack
RUN apt-get update \
    && apt-get --yes --no-install-recommends install \
      curl \
      python3  \
      python3-dev \
      python3-pip  \
      python3-venv  \
      python3-wheel  \
      python3-setuptools \
      build-essential  \
      cmake \
      graphviz  \
      git  \
      openssh-client \
      libssl-dev  \
      libffi-dev \
      fonts-ipafont \
      libfontconfig1-dev \
      libxml2-dev \
      libcurl4-openssl-dev \
      libharfbuzz-dev \
      libfribidi-dev \
      libfreetype6-dev \
      libpng-dev \
      libtiff5-dev \
      libjpeg-dev \
      fontconfig \
      libfontconfig1-dev \
      binutils \
      libproj-dev \
      gdal-bin \
      libgdal-dev \
      libudunits2-dev \
      apt-transport-https  \
      ca-certificates  \
      gnupg \
    && pip3 install virtualenv cryptography \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install IPyLeaflet. The notebook library dependency is downgraded to
# version 4.4.1 but the datalab repo warns about potential version issues:
# https://github.com/googledatalab/datalab/blob/master/containers/base/Dockerfile#L139
RUN pip3 install ipyleaflet \
                  jupyter_contrib_nbextensions \
  && jupyter contrib nbextension install --user \
  && jupyter nbextension enable varInspector/main \
  && jupyter nbextension enable --py --sys-prefix ipyleaflet \
  && pip3 install notebook

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-cli -y

# RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
#   && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - \
#   && apt-get update -y \
#   && apt-get install -y google-cloud-cli \
#   google-cloud-cli-app-engine-python \
#   google-cloud-cli-app-engine-python-extras \
#   google-cloud-cli-cloud-build-local


RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH=$PATH:/root/google-cloud-sdk/bin

# Install the Earth Engine Python API.
RUN pip3 install earthengine-api geemap --upgrade

RUN install2.r --error \
  remotes \
  sf \
  lwgeom \
  tidyverse \
  stars \
  terra \
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
  rgee \
  tinytex


# RUN Rscript -e "remotes::install_github('naru-T/MyRMiscFunc')"
RUN Rscript -e "tinytex::install_tinytex()"

#https://hub.docker.com/r/rocker/verse/dockerfile
