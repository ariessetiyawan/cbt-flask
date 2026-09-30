import mysql.connector
from mysql.connector import pooling
from config import Config

# Connection pool
pool = pooling.MySQLConnectionPool(
    pool_name="cbt_pool",
    pool_size=5,
    host=Config.DB_HOST,
    user=Config.DB_USER,
    password=Config.DB_PASSWORD,
    database=Config.DB_NAME,
    autocommit=False,
)

def get_conn():
    return pool.get_connection()

def query(sql, params=None, one=False):
    conn = get_conn()
    cur = conn.cursor(dictionary=True)
    cur.execute(sql, params or ())
    result = cur.fetchone() if one else cur.fetchall()
    cur.close(); conn.close()
    return result

def execute(sql, params=None):
    conn = get_conn()
    cur = conn.cursor()
    cur.execute(sql, params or ())
    conn.commit()
    last_id = cur.lastrowid
    rowcount = cur.rowcount
    cur.close(); conn.close()
    return last_id, rowcount