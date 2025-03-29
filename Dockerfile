# Build stage
FROM node:20-alpine AS build
RUN apk update && apk upgrade --available && rm -rf /var/cache/apk/*
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:stable
COPY --from=build /app/dist /usr/share/nginx/html
# Add nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
