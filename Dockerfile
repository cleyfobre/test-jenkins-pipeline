FROM node:16.20.0-alpine as build
#기반이 되는 이미지

#작업할 폴더
WORKDIR /app

# dev or prod
ARG BUILD

# 파일복사 (전체)
COPY . .

RUN yarn && yarn build:${BUILD} # 종속성 설치 후 빌드

FROM nginx:latest
# 멀티 스테이지 빌드로 용량 줄임

#포트 지정
EXPOSE 8030

# 전단계에서 빌드한 결과물을 복사
COPY --from=build /app/dist /usr/share/nginx/html

# nginx 실행에 필요한 쉘 스크립트 복사
COPY nginx/docker-entrypoint.sh /

ARG CACHEBUST=1
# nginx 설정파일 복사
COPY nginx/default.conf /etc/nginx/conf.d/

#COPY build/ /usr/share/nginx/html/
# nginx 쉘 스크립트 실행
ENTRYPOINT ["/docker-entrypoint.sh"]

