# Build Stage
FROM node:24-slim AS builder
WORKDIR /app
COPY app .
RUN yarn install && yarn build


# Runtime Stage
FROM nginx:1.30.3-alpine
COPY --from=builder /app/build/ /usr/share/nginx/html/
EXPOSE 80
