FROM --platform=$BUILDPLATFORM node:lts-alpine AS build
WORKDIR /build
COPY package.json .
COPY package-lock.json .
RUN npm install
COPY . .
RUN npm run build

FROM node:lts-alpine
WORKDIR /app
RUN mkdir src
COPY --from=build /build/src/global.json ./src/
COPY --from=build /build/dist/webserver.js ./src/
COPY --from=build /build/package.json .

CMD [ "npm", "run", "start", "--" ]
