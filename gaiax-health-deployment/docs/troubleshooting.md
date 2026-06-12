# Troubleshooting

- If a service fails to start, inspect logs with:
  ```bash
  docker compose logs --tail 50 <service>
  ```

- If the dashboard is blank, verify the consumer service is reachable at `http://consumer:8083` from the container network.

- If Docker build fails for Node, remove `node_modules` from the dashboard repo and rebuild.

- If port conflict occurs, ensure 3000, 8081, 8082 and 8083 are free.
