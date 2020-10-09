FROM python:3

MAINTAINER Partha Sudarsanam

RUN /usr/local/bin/python -m pip install --upgrade pip
# We copy just the requirements.txt first to leverage Docker cache
COPY requirements.txt /app
RUN pip install --no-cache-dir -r requirements.txt

#We copy rest of the files except the ones defined in the .dockerignore and run the application
COPY . /app
WORKDIR /app
ENTRYPOINT [ "python" ]
CMD [ "app.py" ]
