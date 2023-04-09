FROM public.ecr.aws/docker/library/node:16.16.0-slim as builder
WORKDIR /app

COPY . .
RUN npm update && npm run build

FROM public.ecr.aws/docker/library/node:16.16.0-slim as runner
COPY --from=awsguru/aws-lambda-adapter:x86_64_0.7.0_alpha_2 /lambda-adapter /opt/extensions/lambda-adapter
ENV PORT=3000 NODE_ENV=production
ENV AWS_LWA_ENABLE_COMPRESSION=false

WORKDIR /app
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/next.config.js ./next.config.js


RUN rm -rf ./.next/cache

CMD /usr/local/bin/npm run start