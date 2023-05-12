FROM mcr.microsoft.com/devcontainers/base:alpine-3.17
COPY . ./
RUN chmod +x  ./syncrepo.sh
ENTRYPOINT ["bash", "syncrepo.sh"]


