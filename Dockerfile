FROM rocker/shiny:3.4.1
MAINTAINER Your Name
# install required Linux packages
RUN sudo apt-get update && apt-get install -y libcurl4-openssl-dev libssl-dev libxml2-dev libudunits2-0 libudunits2-dev libproj-dev libgdal-dev && apt-get clean && rm -rf /var/lib/apt/lists/ && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
# install required R packages (if you need more packages you'll need to add them to this Dockerfile)
RUN Rscript -e "install.packages(c('plotly'), repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages(c('shiny'), repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages(c('icesDatras'), repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('DATRAS',repos='http://www.rforge.net/',type='source')"
# Copy our R files to the Docker image
COPY server.R /srv/shiny-server/
COPY global.R /srv/shiny-server/
COPY ui.R /srv/shiny-server/
# Set the default command for the Docker image to run Shiny
CMD ["/usr/bin/shiny-server.sh"]
#
# Helpful Docker commands
#
# To build this image run the command below in the same directory as the Dockerfile (remember the dot at the end of the line)
# docker build -t my/imagenameand:tag .
#
# After you have built your image you can run a container based on the image using the following
# (run the command in the directory above your DatrasData directory) 
# docker run --name pickaname --rm -d -v $PWD/DatrasData:/srv/shiny-server/data -p 3846:3838 my/imagenameand:tag
#
# To see running containers use
# docker ps
#
# To stop a container called pickaname use
# docker stop pickaname
#