# Build Stage

FROM node:24-slim AS builder
WORKDIR /app
COPY app .
RUN yarn install && yarn build
EXPOSE 3000
CMD [""]