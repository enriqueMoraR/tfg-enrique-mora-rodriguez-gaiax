import axios, { AxiosError, AxiosInstance } from 'axios'

const API_URL = (import.meta.env.VITE_API_URL as string) || 'http://localhost:8083/api/v1'
const API_TIMEOUT = Number((import.meta.env.VITE_API_TIMEOUT as string) || 10000)

// Create axios instance
const api: AxiosInstance = axios.create({
  baseURL: API_URL,
  timeout: API_TIMEOUT,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Helper to generate X-Request-Id (simple implementation for browser)
function generateXRequestId(): string {
  return `req-${Date.now()}-${Math.random().toString(36).substring(2, 11)}`
}

// Request interceptor: attach X-Request-Id
api.interceptors.request.use(
  (config) => {
    if (!config.headers['X-Request-Id']) {
      config.headers['X-Request-Id'] = generateXRequestId()
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Response interceptor: handle errors and retries
let retryCount = 0
const MAX_RETRIES = 3

api.interceptors.response.use(
  (response) => {
    retryCount = 0
    return response
  },
  async (error: AxiosError) => {
    const config = error.config

    if (
      (error.response?.status === 500 || error.response?.status === 503) &&
      config &&
      retryCount < MAX_RETRIES
    ) {
      retryCount++
      const backoffDelay = Math.pow(2, retryCount) * 1000 // Exponential backoff
      await new Promise((resolve) => setTimeout(resolve, backoffDelay))
      return api(config)
    }

    return Promise.reject(error)
  }
)

export default api

