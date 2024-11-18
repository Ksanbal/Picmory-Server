FROM node:20

# Puppeteer가 필요로 하는 의존성을 설치합니다.
RUN apt-get update && apt-get install gnupg wget -y && \
  wget --quiet --output-document=- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google-archive.gpg && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
  apt-get update && \
  apt-get install google-chrome-stable -y --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY ./server/package.json ./server/yarn.lock ./
RUN yarn install

COPY ./server/ .
COPY ./.env .env

RUN yarn prisma generate

RUN yarn build

CMD ["yarn", "start:prod"]