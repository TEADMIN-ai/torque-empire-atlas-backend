# torque-empire-atlas-backend

Autonomous Procurement Intelligence Backend (Atlas Mode) for Torque Empire

## Development setup

Install dependencies with:

```bash
pip install -r requirements.txt
```

If you encounter build errors mentioning `pg_config`, make sure you have removed any previously installed `psycopg2` package. This project relies on the pre-compiled [`psycopg2-binary`](https://pypi.org/project/psycopg2-binary/) wheels so no local PostgreSQL headers or build tools are required. Upgrading `pip` before installing the requirements can also help ensure the wheel is used:

```bash
python -m pip install --upgrade pip
```