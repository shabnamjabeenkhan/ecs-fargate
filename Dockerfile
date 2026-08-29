# Build Stage
FROM node:24-slim AS builder
WORKDIR /app
COPY app .
RUN yarn install && yarn build


# Runtime Stage
FROM nginx:1.30.3-alpine
COPY --from=builder /app/build/ /usr/share/nginx/html/
RUN chown -R nginx:nginx /var/cache/nginx
RUN chown nginx:nginx /run
USER nginx
EXPOSE 80
