FROM public.ecr.aws/docker/library/node:16.16.0-slim as builder
WORKDIR /app

COPY . .
RUN npm update && npm run build

# FROM public.ecr.aws/docker/library/node:16.16.0-slim as runner
# COPY --from=awsguru/aws-lambda-adapter:x86_64_0.7.0_alpha_2 /lambda-adapter /opt/extensions/lambda-adapter
# ENV PORT=3000 NODE_ENV=production
# ENV AWS_LWA_ENABLE_COMPRESSION=true

# WORKDIR /app
# COPY --from=builder /app/public ./public
# COPY --from=builder /app/package.json ./package.json
# COPY --from=builder /app/.next/standalone ./
# COPY --from=builder /app/.next/static ./.next/static
# COPY --from=builder /app/run.sh ./run.sh
# RUN ln -s /tmp/cache ./.next/cache

# CMD exec ./run.sh