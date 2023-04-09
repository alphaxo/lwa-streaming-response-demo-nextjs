FROM public.ecr.aws/lambda/nodejs:16 as builder
WORKDIR /app

COPY . .
RUN npm update && npm run build

FROM public.ecr.aws/lambda/nodejs:16 as runner
COPY --from=awsguru/aws-lambda-adapter:x86_64_0.7.0_alpha_2 /lambda-adapter /opt/extensions/lambda-adapter

ENV PORT=3000 NODE_ENV=production

ENV AWS_LWA_ENABLE_COMPRESSION=false
ENV AWS_LWA_RESPONSE_MODE=streaming

WORKDIR ${LAMBDA_TASK_ROOT}
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/next.config.js ./next.config.js

ENTRYPOINT ["npm", "run", "start", "--loglevel=verbose", "--cache=/tmp/npm"]