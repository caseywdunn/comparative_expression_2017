# Dockerfile

A Dockerfile for installing all dependencies needed to run the analyses.

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

### New image with the Dockerfile

To build the docker image, execute (where `master` can be substituted with any git branch you want to build):

    docker build https://github.com/caseywdunn/comparative_expression_2017.git#master:docker

If all goes well this will finish with the line `Successfully built [id]`, where `[id]` is the image ID for the image you just built.

### Pull the already built image

Rather than build the image with the Dockerfile, you can pull the image we build:

    docker pull dunnlab/comparative_expression_2017

`dunnlab/comparative_expression_2017` is the image ID you will use below.

This docker image that is a snapshot of the container in which we ran the
final published analyses. It therefore includes not only the dependencies
needed to run the analyses, but the analysis code and all result files
as well. You could use this image to inspect the published analyses without
rerunning them yourself, or you could rerun the analyses in the exact same
environment as the analyses we published.

More information on the image is available at
https://hub.docker.com/r/dunnlab/comparative_expression_2017/.

## Run and use

### RStudio

Run a container based on the image you built above (substituting `[id]` for the id you got above):

    docker run -d -p 8787:8787 [id]

Point your browser to port 8787 at the appropriate ip address (eg, http://localhost:8787 if running docker on your local machine, or http://ec2-x-x-x.compute-1.amazonaws.com:8787 if running docker on an amazon ec2 instance, where `ec2-x-x-x.compute-1.amazonaws` is the public DNS). Sign in with username `rstudio` and password `rstudio`. This will pull up a full RStudio interface in your web browser, powered by R in the container you just made.

Select File > Create Project... > Version control > git, and enter `https://github.com/caseywdunn/comparative_expression_2017.git` for the Repository URL. You can now select your branch and execute the manuscript.

### Command line interface

#### Get command line access to the container
If you have not already started RStudio as described above, run to following on the docker host:

    docker run -it [id] bash

If you have already started RStudio, run the following to get the `container_id` for the running container (this is different from the `image_id` that the container is based on).

    docker ps

Then run the following to log into the running container:

    docker exec -it [container_id] bash

#### Configure a few things

When you log into the container as described above, you are the `root` user. You should switch to the `rstudio` users
so that permissions are not messed up.

    chsh -s /bin/bash rstudio # Change the shell to bash so autocomplete, arrows, etc work
    su rstudio
    cd ~

To get ready to use `git` in the container, you need to configure it with your email address and name. This is done by  entering some `git` commands (where the `John Doe` bits are replaced with your name and email address):

    git config --global user.name "John Doe"
    git config --global user.email "johndoe@example.com"

If you didn't clone the repository via RStudio already, you can clone it now with:

    git clone https://github.com/caseywdunn/comparative_expression_2017.git

Now cd into the repository and, if needed, switch branches:

    cd comparative_expression_2017
    git checkout revision # optional- change branch

#### Execute the manuscript

Execute the manuscript in two steps with:

    nohup Rscript manuscript_kernel.R &
    Rscript -e "library(rmarkdown); render('manuscript.rmd')"
