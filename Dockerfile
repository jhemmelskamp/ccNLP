FROM openjdk:8-jdk

LABEL maintainer="Casey Hilland <casey.hilland@gmail.com>"

# Update package list and install required packages including Python.
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    wget \
    unzip \
    python \
 && rm -rf /var/lib/apt/lists/*

# Install pip for Python 2.7 using the official bootstrap script.
RUN wget https://bootstrap.pypa.io/pip/2.7/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

# Upgrade pip and install Python dependencies from requirements.txt
ADD . /src
RUN pip install --upgrade pip && pip install -r /src/requirements.txt

# Download and set up Stanford NLP tools
RUN mkdir -p /home/ubuntu && \
    cd /home/ubuntu && \
    wget http://nlp.stanford.edu/software/stanford-corenlp-full-2015-04-20.zip && \
    unzip stanford-corenlp-full-2015-04-20.zip && \
    cd stanford-corenlp-full-2015-04-20 && \
    wget http://nlp.stanford.edu/software/stanford-srparser-2014-10-23-models.jar

# Set the working directory
WORKDIR /src

# Expose the application port
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]
