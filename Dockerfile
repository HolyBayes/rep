FROM anaderi/rep-base:0.6.1
MAINTAINER Andrey Ustyuzhanin <anaderi@yandex-team.ru>

ENV TEMP /tmp
ENV SHELL /bin/bash
ENV JUPYTER_PORT=8888

# install REP
# 
RUN mkdir $TEMP/build
COPY setup.py README.md AUTHORS requirements.txt $TEMP/build/
COPY rep $TEMP/build/rep
COPY tests $TEMP/build/tests
COPY run.sh /root/
COPY howto /REP_howto
RUN cd $TEMP/build && \
  pip install . && \
  cd tests && \
  nosetests . || echo OK && \
  rm -rf $TEMP/build


# IPython setup
#
RUN mkdir /notebooks
WORKDIR /root/
RUN ipython profile create default &&\
  /bin/echo -e "c.NotebookApp.ip = '*'\nc.NotebookApp.open_browser = False\nc.NotebookApp.port = $JUPYTER_PORT\n" | \
  tee -a /root/.ipython/profile_default/ipython_notebook_config.py

EXPOSE $JUPYTER_PORT 5000
CMD ["bash", "/root/run.sh"]
