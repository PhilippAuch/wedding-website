FROM node:22.2.0-alpine3.18 AS builder
WORKDIR /app

RUN apk update && apk add tzdata openssh-client git
ENV TZ=Europe/Berlin
RUN npm install -g gulp

COPY ./package*.json ./
RUN npm install --ignore-scripts=false
COPY ./src/ ./src/
COPY ../views ./views/

RUN gulp

FROM nginx:1.25.1-alpine3.17 AS runner
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./index.html /usr/share/nginx/html
COPY --from=builder /app/js/*min.js /usr/share/nginx/html/js
