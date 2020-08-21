FROM tensorflow/tensorflow:latest-jupyter

LABEL maintainer fonnesbeck@hey.com

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# for dynamic linking to the development version of theano
RUN apt-get update && \
    apt-get install -y --no-install-recommends libatlas-base-dev && \
    apt-get install -y graphviz graphviz-dev unixodbc-dev \
        zsh neovim git openssh-client docker wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a user called 'docker_user'
RUN useradd -ms /bin/zsh dockeruser
# Do everything from now in that users home directory
ENV HOME /home/dockeruser
WORKDIR ${HOME}

# Oh-my-zsh
RUN curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh || true

# Configure text editor - vim!
RUN curl -fLo ${HOME}/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
COPY init.vim .config/nvim/init.vim
# Clone the git repos of Vim plugins
WORKDIR ${HOME}/.config/nvim/plugged/
RUN git clone --depth=1 https://github.com/ctrlpvim/ctrlp.vim && \
    git clone --depth=1 https://github.com/tpope/vim-fugitive && \
    git clone --depth=1 https://github.com/godlygeek/tabular && \
    git clone --depth=1 https://github.com/plasticboy/vim-markdown && \
    git clone --depth=1 https://github.com/vim-airline/vim-airline && \
    git clone --depth=1 https://github.com/vim-airline/vim-airline-themes && \
    git clone --depth=1 https://github.com/vim-syntastic/syntastic && \
    git clone --depth=1 https://github.com/frazrepo/vim-rainbow && \
    git clone --depth=1 https://github.com/airblade/vim-gitgutter && \
    git clone --depth=1 https://github.com/derekwyatt/vim-scala && \
    git clone --depth=1 https://github.com/hashivim/vim-terraform.git && \
    git clone --depth=1 https://github.com/lifepillar/vim-solarized8.git

# Setup my $SHELL
ENV SHELL /bin/zsh
# Install oh-my-zsh
RUN wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | zsh || true
RUN wget https://gist.githubusercontent.com/xfanwu/18fd7c24360c68bab884/raw/f09340ac2b0ca790b6059695de0873da8ca0c5e5/xxf.zsh-theme -O ${HOME}/.oh-my-zsh/custom/themes/xxf.zsh-theme
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/plugins/zsh-autosuggestions
# Copy ZSh config
COPY zshrc ${HOME}/.zshrc

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

# Set working directory to /workspace
WORKDIR /workspace

COPY init_workspace.sh /bin/init_workspace.sh
RUN chmod +x /bin/init_workspace.sh

CMD ["/bin/init_workspace.sh"]