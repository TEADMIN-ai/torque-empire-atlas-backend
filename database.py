from sqlalchemy import create_engine, Column, Integer, String, MetaData, Table
from sqlalchemy.orm import sessionmaker
import os

DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///atlas.db")
engine = create_engine(DATABASE_URL)
metadata = MetaData()

suppliers = Table(
    "suppliers",
    metadata,
    Column("id", Integer, primary_key=True),
    Column("supplier", String),
    Column("name", String),
    Column("price", String),
    Column("source", String),
)

def init_db():
    metadata.create_all(engine)

def save_suppliers(data):
    with engine.begin() as conn:
        conn.execute(suppliers.delete())
        conn.execute(suppliers.insert(), data)

def get_all_suppliers():
    with engine.begin() as conn:
        return [dict(r) for r in conn.execute(suppliers.select())]
