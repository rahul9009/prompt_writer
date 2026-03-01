# Terminal Commands — Account App

यह दस्तावेज़ [PROMPT.md](PROMPT.md), [ROADMAP.md](ROADMAP.md) और [AGENTS.md](AGENTS.md) के अनुसार प्रोजेक्ट चलाने के लिए टर्मिनल कमांड देता है। सभी कमांड **repository root** (`/path/to/account_app`) से शुरू होने का मानक है, जब तक कि अलग न लिखा हो।

**पोर्ट:** Backend **8000** (या `--port` से बदलें), Web **4200**, Postgres **5434**

---

## 1. Prerequisites

### 1.1 पहले प्रोजेक्ट रूट में Environment Files (env.example) सेट करें

```bash
# Backend (DATABASE_URL, JWT_SECRET_KEY – production में strong secret)
cp backend/.env.example backend/.env
# .env में values सेट करें; production में openssl rand -hex 32 जैसा इस्तेमाल करें
```

### 1.2 Postgres और Redis चालू करें

```bash
docker compose -f docker/docker-compose.yml up -d postgres redis
```

### 1.3 Dependencies (Backend Database Migration and Seed)

```bash
# 1. From backend (FastAPI) project root
cd backend

# 2. Venv + deps
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# 3. Env (create .env from .env.example, set DATABASE_URL and JWT_SECRET_KEY)
cp .env.example .env

# 4. Migrations
alembic upgrade head

# 5. Seed (admin@example.com / admin)
python -m scripts.seed_admin
python -m scripts.seed_admin --no-email # No email will be sent to the users

# 6. Run server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8002

# 7. From web (Angular) project root
cd web
npm install
```

admin: `admin@rndcsoftware.com`
password: `Admin@9009`

### 1.4 Run server

```bash
# 1. From backend (FastAPI) project root
cd backend
source .venv/bin/activate
alembic upgrade head
uvicorn app.main:app --reload --host 0.0.0.0 --port 8002

# 2. From web (Angular) project root
cd web
npm start
```
- Web App (Angular) - [http://localhost:4202/](http://localhost:4202/)
- API: [http://localhost:8002](http://localhost:8002)  
- Docs: [http://localhost:8002/docs](http://localhost:8002/docs)  
- Health: [http://localhost:8002/health](http://localhost:8002/health) (अगर रूट पर है)
---

## 2. Development — सब चलाना

### 2.1 Postgres (Docker)

```bash
docker compose up -d
```

Postgres: `localhost:5434`, DB: `account_app`, user/pass: `postgres`/`postgres` (`.env` के अनुसार)।

### 2.2 Backend (FastAPI)

```bash
# 1. From backend (FastAPI) project root
cd backend
source .venv/bin/activate
alembic upgrade head
uvicorn app.main:app --reload --host 0.0.0.0 --port 8002

# 2. From web (Angular) project root
cd web
npm start
```

- API: [http://localhost:8002](http://localhost:8002)  
- Docs: [http://localhost:8002/docs](http://localhost:8002/docs)  
- Health: [http://localhost:8002/health](http://localhost:8002/health) (अगर रूट पर है)

### 2.3 Web (Angular)

दूसरे टर्मिनल में:

```bash
# 1. From web (Angular) project root
cd web
npm start
```

ब्राउज़र: **[http://localhost:4202](http://localhost:4202)**

### 2.4 क्रम (संक्षेप)


| क्रम | टर्मिनल 1                                                                                                                     | टर्मिनल 2             |
| ---- | ----------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| 1    | `docker compose up -d`                                                                                                        | —                     |
| 2    | `cd backend && source .venv/bin/activate && alembic upgrade head && uvicorn app.main:app --reload --host 0.0.0.0 --port 8002` | —                     |
| 3    | —                                                                                                                             | `cd web && npm start` |


---

## 3. Database (Alembic)

Migrations **backend/** से चलते हैं। DB पहले चल रहा हो (Docker)।

### 3.1 पहली बार / सभी migrations लागू करना

```bash
# 1. From backend (FastAPI) project root
cd backend
source .venv/bin/activate
alembic upgrade head

# 2 Check migrations
alembic history

# 3 Check current revision
alembic current

# 4 Check revision history
alembic history
cd ..

# 5. Check the table in the database
docker exec -it account_app-postgres psql -U postgres -d account_app -c '\dt'
```

### 3.2 नई migration बनाना (models बदलने के बाद)

```bash
# 1. From backend (FastAPI) project root
cd backend
source .venv/bin/activate
alembic revision --autogenerate -m "short_description"
alembic upgrade head
cd ..
```

उदाहरण: `-m "add_ledger_group_columns"`।

### 3.3 Rollback / current revision

```bash
# 1. From backend (FastAPI) project root
cd backend
alembic downgrade -1
alembic current
alembic history
cd ..
```

Rollback से पहले बैकअप लेने की सिफारिश (नीचे §6)।

---

## 4. Seed (Admin + RBAC)

[ROADMAP Phase 0](ROADMAP.md) के अनुसार default admin, roles और permissions लोड करने के लिए:

```bash
# 1. From backend (FastAPI) project root
cd backend
source .venv/bin/activate
python -m scripts.seed_admin
python -m scripts.seed_admin --no-email # No email will be sent to the users
cd ..
```

**Default login:** `admin@example.com` / `admin`  
Production में इन्हें बदलें या हटा दें। ([PROMPT](PROMPT.md): never log tokens; use strong secrets.)

---

## 5. Lint और Test

```bash
# 1. From backend (FastAPI) project root
cd backend
source .venv/bin/activate
pytest -v

# 2. From web (Angular) project root
cd web
npm test
```

Lint/format (अगर scripts हों):

```bash
# 1. From backend (FastAPI) project root
cd backend
ruff check .

# 2. From web (Angular) project root
cd web
npm run lint
```

---

## 6. Backup / Restore (Postgres)

### 6.1 Backup

```bash
# 1. From project root (docker-compose.yml)
docker exec account_app_postgres pg_dump -U postgres -Fc account_app > backup_$(date +%Y%m%d_%H%M).dump
# या SQL: docker exec account_app_postgres pg_dump -U postgres account_app > backup_$(date +%Y%m%d_%H%M).sql
```

### 6.2 Restore

```bash
# 1. From project root (docker-compose.yml)
cat backup.dump | docker exec -i account_app_postgres pg_restore -U postgres -d account_app --clean
# SQL: cat backup.sql | docker exec -i account_app_postgres psql -U postgres -d account_app
```

---

## 7. Troubleshooting

- **API नहीं मिल रहा:** Backend चल रहा है? `curl http://localhost:8002/docs`। Web हमेशा HTTP से चलाएं ([http://localhost:4202](http://localhost:4202)), `file://` नहीं।
- **DB connection error:** `docker compose ps` से Postgres चेक करें। `backend/.env` में `DATABASE_URL` सही हो (host `localhost`, port **5434**, db `account_app`)।
- **Migration fail:** बैकअप लें (§6)। `alembic current` / `alembic history` देखें; जरूरत हो तो `downgrade -1` फिर स्कीमा ठीक करके दोबारा `upgrade head`।

---

## 8. Copy-paste checklist

**पहली बार सेटअप:**

```bash
# 1. From backend (FastAPI) project root
cp backend/.env.example backend/.env
# backend/.env में DATABASE_URL और JWT_SECRET_KEY सेट करें
source .venv/bin/activate
pip install -r requirements.txt

# 2. From web (Angular) project root
cd web
npm install
```

**डेवलपमेंट चलाना:**

```bash
# 1. From project root (docker-compose.yml)
docker compose up -d

# 2. From backend (FastAPI) project root
cd backend
source .venv/bin/activate
alembic upgrade head
uvicorn app.main:app --reload --host 0.0.0.0 --port 8002

# 3. From web (Angular) project root
cd web
npm start
```

**सीड:**

```bash
# 1. From backend (FastAPI) project root
cd backend
source .venv/bin/activate
python -m scripts.seed_admin
python -m scripts.seed_admin --no-email # No email will be sent to the users
cd ..

# 2. From web (Angular) project root
cd web
npm start
```

---

इस दस्तावेज़ में दिए गए कमांड [PROMPT.md](PROMPT.md), [ROADMAP.md](ROADMAP.md) और [AGENTS.md](AGENTS.md) के साथ संगत हैं।