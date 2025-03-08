FROM openjdk:8-jdk

# Set the maintainer using LABEL (MAINTAINER is deprecated)
LABEL maintainer="Casey Hilland <casey.hilland@gmail.com>"

# Update package list and install dependencies, then clean up apt cache
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    wget \
    unzip \
    python-setuptools \
 && rm -rf /var/lib/apt/lists/*

# Install pip via easy_install and upgrade pip
RUN easy_install pip && pip install --upgrade pip

# Copy your source code into /src and install Python dependencies
ADD . /src
RUN pip install -r /src/requirements.txt

# Create a directory for Stanford NLP tools, download, and unzip the package
RUN mkdir -p /home/ubuntu && \
    cd /home/ubuntu && \
    wget http://nlp.stanford.edu/software/stanford-corenlp-full-2015-04-20.zip && \
    unzip stanford-corenlp-full-2015-04-20.zip && \
    cd stanford-corenlp-full-2015-04-20 && \
    wget http://nlp.stanford.edu/software/stanford-srparser-2014-10-23-models.jar

# Set the working directory
WORKDIR /src

# Expose the port your application listens on
EXPOSE 5000

# Define the command to run your application
CMD ["python", "app.py"]
