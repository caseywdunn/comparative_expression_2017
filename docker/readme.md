# Dockerfile

A provisional Dockerfile for installing all dependencies needed to run the 
analyses. Not yet fully tested.

See [my cheat sheet](https://gist.github.com/caseywdunn/34aac3d1993f9b3340496e9294239d3d) for more about Docker.

## Host system

The host system can be your own computer, a local server, or a cloud server (such as a machine on Amazon Web Services).

### Amazon Web Services

I developed this Dockerfile on an [m4.4xlarge](https://aws.amazon.com/ec2/instance-types/) EC2 instance running Amazon Linux. I made the following changes to the default configuration:

- Increase the storage to 20 GB

- Open port 8787 (for RStudio web access)

Install docker with:

    sudo yum update -y
    sudo yum install -y docker
    sudo yum install -y git
    sudo service docker start
    sudo usermod -a -G docker ec2-user

Log out and then log in again for the `usermod` changes to take effect.

Your Amazon machine is now ready to build and run the SMRTLink Docker container.

## Build

To build the docker container, execute (where `master` can be substituted with any git branch you want to build):

    docker build https://github.com/caseywdunn/comparative_expression_2017.git#master:docker

If all goes well this will finish with the line `Successfully built [id]`, where `[id]` is the image ID for the image you just built. 

## Run and use

### RStudio

Run a container based on the image you built above (substituting `[id]` for the id you got above):

    docker run -p 8787:8787 [id]

Point your browser to port 8787 at the appropriate ip address (eg, http://localhost:8787 if running docker on your local machine, or http://ec2-x-x-x.compute-1.amazonaws.com:8787 if running docker on an amazon ec2 instance, where `ec2-x-x-x.compute-1.amazonaws` is the public DNS). Sign in with username `rstudio` and password `rstudio`. This will pull up a full RStudio interface in your webrowser, powered by R in the container you just made.

Select File > Create Project... > Version control > git, and enter `https://github.com/caseywdunn/comparative_expression_2017.git` for the Repository URL. You can now select your branch and execute the manuscript.

### Command line interface

To run the container interactively, run to following on the docker host:

    docker run -it [id] bash

From within the container, you can for example do the following:

    git clone https://github.com/caseywdunn/comparative_expression_2017.git
    cd comparative_expression_2017

To knit the manuscript:

    git checkout revision # change branches
    nohup Rscript -e "library(rmarkdown); render('manuscript.rmd')" &

Or, to run all the code at the R console (so you can dig into particular variables, for example):

    R
    library(knitr)
    purl("manuscript.rmd")
    source("manuscript.R")
