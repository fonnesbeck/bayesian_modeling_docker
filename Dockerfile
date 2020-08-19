FROM tensorflow/tensorflow:latest-jupyter

LABEL maintainer fonnesbeck@hey.com

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# for dynamic linking to the development version of theano
RUN apt-get update && \
    apt-get install -y --no-install-recommends libatlas-base-dev && \
    apt-get install -y graphviz graphviz-dev unixodbc-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN python -m pip install \
    arviz \
    bokeh \
    dask \
    fastprogress \
    joblib \
    numba \
    pygraphviz \
    pyodbc \
    seaborn \
    streamlit \  
    tensorflow_probability \
    Theano \
    xarray
RUN python -m pip install -e git+https://github.com/pymc-devs/pymc3.git#egg=pymc3

# Import matplotlib the first time to build the font cache.
RUN python -c "import matplotlib.pyplot"