# Dockerfile

A provisional Dockerfile for installing all dependencies needed to run the 
analyses. Not yet tested.

## Host system


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

## Build and run

To build the docker container, execute (where `master` can be substituted with any git branch you want to build):

    docker build https://github.com/caseywdunn/comparative_expression_2017.git#master:docker

If all goes well this will finish with the line `Successfully built [id]`, where `[id]` is the image ID for the image you just built. You can then run a container based on this id with (substituting `[id]`):

    docker run -p 8787:8787 [id]

To run the container interactively, eg to debug it, you can instead run:

    docker run -p 8787:8787 -it [id] bash

## Use

Point your browser to port 8787 at the appropriate ip address. Sign in with username `rstudio` and password `rstudio`.

Select File > Create Project... > Version control > git, and enter `https://github.com/caseywdunn/comparative_expression_2017.git` for the Repository URL. You can now select your branch and execute the manuscript.

