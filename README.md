# Puppet Local Test

Standing up

```bash
docker compose up -d --build
```

To call puppet on client:

```bash
docker compose exec client puppet agent -t
```
