# gaiax-health-dashboard

React dashboard frontend for Gaia-X Health.

## Setup

```bash
npm install --legacy-peer-deps
npm run dev
```

## Build

```bash
npm run build
```

## Test

```bash
npm run test
npm run type-check
```

## Docker

```bash
docker build -t gaiax-health-dashboard:1.0.0 .
```

## Notes
- The dashboard is configured to talk to the consumer API at `/api/v1`.
- In Docker Compose, the frontend uses `http://consumer:8083` as the API backend.
