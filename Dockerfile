# 1. Node.js 기반 이미지 사용하여 Vue 애플리케이션 빌드
FROM node:18-alpine AS build

# 작업 디렉토리 설정
WORKDIR /app

# 의존성 설치
COPY package.json package-lock.json ./
RUN npm install

# 애플리케이션 소스 복사
COPY . .

# Vue 애플리케이션 빌드
RUN npm run build

# 2. Nginx 기반 이미지로 최종 배포
FROM nginx:alpine

# 빌드된 애플리케이션을 Nginx의 HTML 디렉토리에 복사
COPY --from=build /app/dist /usr/share/nginx/html

# Nginx 설정 파일 복사 (필요시 설정 파일 추가)
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Nginx 서버 시작
CMD ["nginx", "-g", "daemon off;"]

# 80 포트 노출
EXPOSE 80

