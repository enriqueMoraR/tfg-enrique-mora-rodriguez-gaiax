# Development Setup

1. Clone the repos next to each other:
   - `gaiax-health-provider-node`
   - `gaiax-health-trust-service`
   - `gaiax-health-consumer-node`
   - `gaiax-health-dashboard`
   - `gaiax-health-deployment`

2. In `gaiax-health-deployment` run:
   ```bash
   docker compose up -d --build
   ```

   The stack works without a local `.env`; use `.env.example` only if you want to override frontend defaults during manual experimentation.

3. Access services:
   - Dashboard: http://localhost:3000
   - Provider: http://localhost:8081
   - Trust: http://localhost:8082
   - Consumer: http://localhost:8083

4. To stop:
   ```bash
   docker compose down
   ```
