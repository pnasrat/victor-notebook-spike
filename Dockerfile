# Choose your desired base image
FROM jupyter/base-notebook:python-3.10

USER root
# Desktop packages
RUN apt-get update -qq --yes && apt-get install --yes \
            git \
            gnupg \
            groff \
            tree \
            vim \
            libgc-dev \
            libgc1 \
            libopengl0 \
            openmpi-bin \
            libgdal-dev \
            gdal-bin \
            grass \
            ghostscript \
            build-essential \
            libgfortran5 \
            libgl1-mesa-glx \
            dbus-x11 \
            xorg \
            xubuntu-icon-theme \
            xfce4 \
            xfce4-goodies \
            xclip \
            xsel \
            cmake \
            libgl1-mesa-dev \
            libxt-dev \
            libopenmpi-dev \
            libtbb-dev \
            ninja-build \
            paraview \
            libasound2 \
            libdbus-glib-1-2 \
            libpci-dev \
            qt5-style-plugins \
            software-properties-common && \
            apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"


# Use Mozilla Firefox PPA
RUN add-apt-repository ppa:mozillateam/ppa
COPY mozilla-firefox.apt.preferences /etc/apt/preferences.d/mozilla-firefox
RUN apt-get update -qq --yes && apt-get install --yes -t 'o=LP-PPA-mozillateam' --yes firefox


USER $NB_UID
COPY --chown=${NB_UID}:${NB_GID} environment.yml "/home/${NB_USER}/tmp/"
RUN cd "/home/${NB_USER}/tmp/" && \
    mamba env update -n base --file environment.yml
RUN jupyter serverextension enable --py jupyterlab_s3_browser
# RUN echo "conda activate ${conda_env}" >> "${HOME}/.bashrc"
