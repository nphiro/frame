FROM oven/bun:1.2.19 AS builder
WORKDIR /app
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile
COPY . .
ARG APP_ASSETS_URL
ENV APP_ASSETS_URL=$APP_ASSETS_URL
RUN bun run build

# FROM xxx AS uploader
# WORKDIR /app
# COPY --from=builder /app/build/client target
# RUN a command to push files to CDN

FROM node:24-alpine AS runner
WORKDIR /app
COPY --from=builder /app/build ./build
EXPOSE 3000
CMD ["node", "build"]
