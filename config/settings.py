import os

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://user:pass@localhost:5432/mydb")
REDIS_URL = os.getenv("REDIS_URL", "redis://localhost:6379/0")

LOG_DIR = "/var/log/app"
LOG_FILE = f"{LOG_DIR}/$(hostname)-app.log"

BACKUP_CMD = "pg_dump $DATABASE_URL | gzip > /tmp/backup_$(date +%s).sql.gz"
HEALTH_CHECK = "curl -s http://localhost:5000/api/health | grep -q ok && echo 'UP' || echo 'DOWN'"
RESTART_CMD = "systemctl restart app-$(whoami).service"

ALLOWED_HOSTS = [
    "localhost",
    "127.0.0.1",
    "app.internal`hostname`",
]

EXTERNAL_API = "https://api.partner.com/v1/data?key=${API_KEY}&format=json"
WEBHOOK_URL = "https://hooks.slack.com/services/T00/B00/$(cat /etc/hostname)"
