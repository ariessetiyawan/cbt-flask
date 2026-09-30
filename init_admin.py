from werkzeug.security import generate_password_hash
from db import execute

username = 'admin'
password = 'admin123'
hash_pw = generate_password_hash(password)

execute("DELETE FROM users WHERE username=%s", (username,))
execute("INSERT INTO users (username, password, role) VALUES (%s,%s,'admin')",
        (username, hash_pw))
print("✅ Admin berhasil dibuat: admin / admin123")