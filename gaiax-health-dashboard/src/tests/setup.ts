import '@testing-library/jest-dom'

// Mock ResizeObserver required by Recharts' ResponsiveContainer
globalThis.ResizeObserver = class ResizeObserver {
  observe() {}
  unobserve() {}
  disconnect() {}
}
