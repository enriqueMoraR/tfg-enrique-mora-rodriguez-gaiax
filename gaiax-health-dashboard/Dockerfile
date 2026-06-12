# Multi-stage Dockerfile for React Dashboard
# Stage 1: Build the application
FROM node:20.12.0-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --legacy-peer-deps

ARG VITE_FHIR_API_URL=/api/fhir
ARG VITE_FHIR_API_TIMEOUT=10000

# Copy source code
COPY . ./

# Set environment variables for build
ENV VITE_FHIR_API_URL=${VITE_FHIR_API_URL}
ENV VITE_FHIR_API_TIMEOUT=${VITE_FHIR_API_TIMEOUT}

# Build the application
RUN npm run build

# Stage 2: Serve the application with nginx
FROM nginx:alpine AS runtime

# Copy built application from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom nginx configuration to proxy FHIR traffic to the provider
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost/ >/dev/null || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
