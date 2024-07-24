FROM alpine:3.20 as sources
WORKDIR /app
RUN apk add --no-cache git
RUN git clone https://github.com/novnc/noVNC.git

FROM bitnami/kubectl:1.29
COPY --from=sources /app/noVNC/app /static/app
COPY --from=sources /app/noVNC/core /static/core
COPY --from=sources /app/noVNC/po /static/po
COPY --from=sources /app/noVNC/vendor /static/vendor
COPY --from=sources /app/noVNC/vnc.html /static/vnc.html
COPY --from=sources /app/noVNC/vnc_lite.html /static/vnc_lite.html
ADD index.html /static/index.html

CMD ["proxy", "--www=/static", "--accept-hosts=^.*$", "--address=[::]", "--api-prefix=/k8s/", "--www-prefix="]
