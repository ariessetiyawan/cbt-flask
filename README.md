# 🌿 CBT Online — Aplikasi Ujian Berbasis Komputer

<div align="center">

![Flask](https://img.shields.io/badge/Flask-3.0.0-000000?style=for-the-badge&logo=flask&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.10+-3776AB?style=for-the-badge&logo=python&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0+-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![TailwindCSS](https://img.shields.io/badge/Tailwind-3.x-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**Platform ujian online modern dengan tema hijau daun — dibangun dengan Flask + MySQL + Tailwind CSS**

[Fitur](#-fitur-utama) • [Instalasi](#-instalasi) • [Screenshot](#-screenshot) • [API](#-struktur-folder) • [Kontribusi](#-kontribusi)

</div>

---

## 📖 Tentang Project

**CBT Online** adalah aplikasi ujian berbasis komputer (Computer Based Test) yang dirancang untuk sekolah, kampus, dan lembaga pendidikan. Aplikasi ini mendukung **multi-role** (admin, guru, siswa), **import soal massal via Excel**, **support gambar soal**, dan **randomisasi soal & opsi jawaban per siswa** untuk mencegah kecurangan.

Dibangun dengan pendekatan **server-side rendering (SSR)** menggunakan Jinja2 template, sehingga ringan, cepat, dan mudah di-deploy di VPS sederhana.

---

## ✨ Fitur Utama

### 🎯 Manajemen Pengguna (Multi-Role)
- 👨‍💼 **Admin** — Kelola semua data (kelas, guru, siswa, soal, ujian)
- 👨‍🏫 **Guru** — Kelola soal, ujian, dan gambar soal
- 👨‍🎓 **Siswa** — Kerjakan ujian & lihat hasil (login terpisah)

### 📚 Bank Soal
- ✅ CRUD soal pilihan ganda (A, B, C, D)
- ✅ **Import massal dari Excel** (template disediakan)
- ✅ **Support gambar** untuk soal & setiap opsi jawaban
- ✅ **Folder unik per soal** untuk organisir gambar
- ✅ Auto-generate kode folder (contoh: `S3A7F2K9Q1`)

### 📝 Manajemen Ujian
- ✅ Buat ujian dengan durasi & jadwal
- ✅ Pilih soal dari bank soal (checkbox)
- ✅ **Randomisasi urutan soal** per siswa
- ✅ **Randomisasi urutan opsi jawaban** per siswa
- ✅ Status aktif/nonaktif

### 🖥️ Ujian Interaktif
- ✅ **Timer real-time** dengan auto-submit saat waktu habis
- ✅ **Auto-save jawaban** (AJAX, tidak takut koneksi putus)
- ✅ **Resume ujian** — bisa lanjut meski browser ditutup
- ✅ **Anti-cheat** — satu siswa hanya bisa 1x ujian
- ✅ Tampilan responsif (mobile-friendly)

### 📊 Hasil & Analisis
- ✅ Nilai instan setelah submit
- ✅ Statistik benar/salah
- ✅ Review jawaban lengkap dengan gambar
- ✅ Riwayat hasil ujian per siswa

### 🎨 UI/UX
- ✅ **Tema hijau daun** (Leaf Green Theme)
- ✅ **Custom dialog box** (menggantikan alert/confirm bawaan browser)
- ✅ **Landing page modern** dengan slideshow 5 gambar
- ✅ **Statistik real-time** dari database
- ✅ **Animasi halus** & responsive di semua device

---

## 🛠️ Teknologi yang Digunakan

| Layer | Teknologi |
|-------|-----------|
| **Backend** | Python 3.10+, Flask 3.0 |
| **Database** | MySQL 8.0+ (mysql-connector-python) |
| **Frontend** | Jinja2, Tailwind CSS 3.x, Font Awesome 6 |
| **Excel** | openpyxl 3.1 |
| **Security** | Werkzeug (scrypt password hashing) |
| **Session** | Flask Session (server-side) |

---

## 📸 Screenshot

### 🏠 Landing Page
> Halaman utama dengan slideshow 5 gambar + statistik real-time

### 🔐 Login (Terpisah untuk Admin/Guru & Siswa)
> Dua pintu masuk berbeda untuk keamanan lebih baik

### 📊 Dashboard Admin
> Statistik lengkap + ringkasan ujian terbaru

### 📚 Bank Soal & Import Excel
> Input manual atau import massal dari template Excel

### 🖥️ Ujian Siswa (Dengan Timer)
> Timer real-time, auto-save jawaban, auto-submit

### 🏆 Hasil Ujian & Review
> Nilai instan + review jawaban dengan gambar

> 💡 *Tambahkan screenshot Anda sendiri di folder `docs/screenshots/`*

---

## 🚀 Instalasi

### 📋 Prasyarat

Pastikan sistem Anda sudah terinstall:
- Python 3.10 atau lebih baru
- MySQL 8.0 atau lebih baru
- Git

### 1️⃣ Clone Repository

```bash
git clone https://github.com/ariessetiyawan/cbt-flask.git
cd cbt-flask
```

### 2️⃣ Buat Virtual Environment

```bash
python -m venv venv

# Windows
venv\Scripts\activate

# Linux / macOS
source venv/bin/activate
```

### 3️⃣ Install Dependencies

```bash
pip install -r requirements.txt
```

**Isi `requirements.txt`:**
```
Flask==3.0.0
mysql-connector-python==8.2.0
Werkzeug==3.0.1
openpyxl==3.1.2
```

### 4️⃣ Setup Database

Buat database MySQL terlebih dahulu:

```bash
mysql -u root -p < database.sql
mysql -u root -p cbt_app < migration.sql
```

Atau import manual melalui **phpMyAdmin**:
1. Buat database `cbt_app`
2. Import `database.sql` → membuat struktur tabel
3. Import `migration.sql` → menambahkan kolom gambar, folder, dll

### 5️⃣ Konfigurasi Database

Edit file `config.py`:

```python
import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY', 'ganti-dengan-secret-key-anda')
    DB_HOST = 'localhost'
    DB_USER = 'root'
    DB_PASSWORD = ''         # sesuaikan password MySQL Anda
    DB_NAME = 'cbt_app'
```

### 6️⃣ Inisialisasi Admin & Data Awal

```bash
# Buat akun admin default
python init_admin.py

# (Opsional) Seed data kelas, siswa, soal, ujian contoh
python seed_siswa.py
python seed_gambar.py
```

**Kredensial default:**
- **Admin**: `admin` / `admin123`
- **Siswa contoh**: `2024001` / `2024001`

### 7️⃣ Jalankan Aplikasi

```bash
python app.py
```

Buka browser: **http://localhost:5000** (atau port yang tertera di terminal)

---

## 📁 Struktur Folder

```
cbt-flask/
├── app.py                    # Main Flask app (semua route)
├── config.py                 # Konfigurasi DB & secret key
├── db.py                     # Helper query & connection pool
├── requirements.txt          # Python dependencies
├── database.sql              # Schema database awal
├── migration.sql             # Migration (folder, gambar, dll)
├── init_admin.py             # Script buat admin default
├── seed_siswa.py             # Seed data siswa & soal contoh
├── seed_gambar.py            # Generate gambar dummy
├── README.md
│
├── static/
│   ├── img/
│   │   └── slide/            # 5 gambar slideshow landing page
│   └── uploads/
│       └── soal/             # Folder gambar soal (auto-generate)
│           ├── S3A7F2K9Q1/
│           ├── S8B2M4X7P3/
│           └── ...
│
└── templates/
    ├── base.html             # Layout utama + sidebar
    ├── _dialog.html          # Custom modal dialog
    ├── landing.html          # Halaman utama
    ├── login.html            # Login admin/guru
    ├── siswa_login.html      # Login siswa
    ├── dashboard.html        # Dashboard admin
    ├── siswa_dashboard.html  # Dashboard siswa
    ├── kelas.html            # CRUD kelas
    ├── guru.html             # CRUD guru
    ├── siswa.html            # CRUD siswa
    ├── soal.html             # Bank soal
    ├── soal_upload.html      # Upload Excel
    ├── soal_gambar.html      # Kelola gambar 1 soal
    ├── soal_gambar_batch.html# Upload gambar batch
    ├── ujian.html            # Manajemen ujian
    ├── siswa_ujian.html      # Halaman ujian siswa
    └── siswa_hasil.html      # Hasil ujian
```

---

## 🗄️ Skema Database

### Tabel Utama

| Tabel | Deskripsi |
|-------|-----------|
| `users` | Akun login (admin, guru, siswa) |
| `kelas` | Data kelas (XII IPA 1, dll) |
| `guru` | Profil guru (terhubung ke `users`) |
| `siswa` | Profil siswa (terhubung ke `users` & `kelas`) |
| `soal` | Bank soal + referensi gambar |
| `ujian` | Data ujian dengan konfigurasi shuffle |
| `ujian_soal` | Relasi many-to-many ujian ↔ soal |
| `hasil_ujian` | Rekap nilai per siswa per ujian |
| `jawaban_siswa` | Detail jawaban siswa per soal |
| `ujian_siswa_soal` | Urutan soal & opsi yang diacak per siswa |

### ERD Sederhana

```
users ─┬─ guru
       └─ siswa ─── kelas
                   │
ujian ─┬─ ujian_soal ── soal
       │
       └─ hasil_ujian ─┬─ jawaban_siswa
                       └─ ujian_siswa_soal
```

---

## 📝 Format Excel untuk Import Soal

### Cara Download Template
1. Login sebagai Admin/Guru
2. Buka menu **Data Soal** → **Import dari Excel**
3. Klik tombol **Download Template Excel**

### Struktur Kolom

| Kolom | Wajib | Deskripsi |
|-------|:-----:|-----------|
| `pertanyaan` | ✅ | Teks pertanyaan |
| `gambar` | ❌ | Nama file gambar soal (opsional) |
| `opsi_a` | ✅ | Pilihan A |
| `gambar_a` | ❌ | Nama file gambar opsi A |
| `opsi_b` | ✅ | Pilihan B |
| `gambar_b` | ❌ | Nama file gambar opsi B |
| `opsi_c` | ✅ | Pilihan C |
| `gambar_c` | ❌ | Nama file gambar opsi C |
| `opsi_d` | ✅ | Pilihan D |
| `gambar_d` | ❌ | Nama file gambar opsi D |
| `jawaban` | ✅ | Kunci jawaban (A/B/C/D) |

### Contoh Baris Excel

| pertanyaan | gambar | opsi_a | opsi_b | opsi_c | opsi_d | jawaban |
|-----------|--------|--------|--------|--------|--------|---------|
| Ibu kota Indonesia? | | Jakarta | Bandung | Surabaya | Medan | A |
| Hitung luas segitiga! | segitiga.png | 12 cm² | 24 cm² | 6 cm² | 18 cm² | C |

### Alur Import
1. **Download template** → isi soal
2. **Upload Excel** → sistem generate folder unik per soal
3. **Redirect otomatis** ke halaman upload gambar batch
4. **Upload gambar** → tersimpan otomatis di folder masing-masing soal

---

## 🔒 Keamanan

- ✅ **Password hashing** menggunakan Werkzeug (scrypt)
- ✅ **Session-based authentication**
- ✅ **Role-based access control** (decorator `@role_required`)
- ✅ **SQL injection prevention** (parameterized queries)
- ✅ **File upload validation** (whitelist ekstensi)
- ✅ **Path traversal prevention** (`secure_filename`)
- ✅ **CSRF-ready** (tinggal tambah Flask-WTF jika perlu)

---

## 🎯 Alur Penggunaan

### 👨‍💼 Alur Admin / Guru

```
1. Login di /login
   ↓
2. Tambah kelas, guru, siswa
   ↓
3. Buat soal (manual atau import Excel)
   ↓
4. Upload gambar soal (opsional)
   ↓
5. Buat ujian → pilih soal → aktifkan shuffle
   ↓
6. Aktifkan ujian → siswa bisa mengerjakan
```

### 👨‍🎓 Alur Siswa

```
1. Login di /login/siswa (gunakan NIS)
   ↓
2. Dashboard menampilkan ujian yang tersedia
   ↓
3. Klik "Mulai Ujian" → timer mulai berjalan
   ↓
4. Jawab soal (auto-save setiap klik)
   ↓
5. Klik "Selesai" atau tunggu waktu habis
   ↓
6. Lihat nilai + review jawaban
```

---

## 🎨 Kustomisasi Tema

Aplikasi menggunakan **palet hijau daun** yang bisa diubah sesuai selera:

| Elemen | Class Tailwind | Warna |
|--------|---------------|-------|
| Primary | `green-600` | Hijau daun |
| Primary Hover | `green-700` | Hijau gelap |
| Accent | `lime-400` | Hijau lime |
| Dark | `emerald-900` | Hijau tua |
| Background | `green-50` | Hijau sangat muda |

### Ganti Tema Cepat
Untuk tema berbeda, cukup cari & replace di semua file template:

```bash
# Contoh: ganti ke tema biru
green-600  → blue-600
green-700  → blue-700
lime-400   → sky-400
emerald-900 → indigo-900
```

---

## 🚀 Deploy ke Production

### Opsi 1: Gunicorn + Nginx (VPS)

```bash
# Install Gunicorn
pip install gunicorn

# Jalankan
gunicorn -w 4 -b 0.0.0.0:5000 app:app
```

**Nginx config** (`/etc/nginx/sites-available/cbt`):
```nginx
server {
    listen 80;
    server_name cbt.sekolah.sch.id;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /static/ {
        alias /path/to/cbt-flask/static/;
        expires 30d;
    }
}
```

### Opsi 2: Docker (Coming Soon)

### Opsi 3: PythonAnywhere / Railway / Render

Cocok untuk yang tidak mau setup VPS.

---

## 🧪 Testing

### Test Manual

```bash
# 1. Jalankan aplikasi
python app.py

# 2. Buka browser
http://localhost:5000

# 3. Login sebagai admin
#    Username: admin
#    Password: admin123

# 4. Coba semua fitur
```

### Test Randomisasi

Login bersamaan dengan 3 siswa berbeda di 3 browser:
- Chrome → NIS `2024001`
- Firefox → NIS `2024002`
- Edge → NIS `2024003`

Setiap siswa akan melihat **urutan soal & opsi yang berbeda**! 🎲

---

## 🐛 Troubleshooting

| Error | Solusi |
|-------|--------|
| `NameError: name 'random' is not defined` | Tambah `import random` di atas `app.py` |
| `Cannot add or update a child row` | Jalankan `seed_kelas()` dulu sebelum `seed_siswa()` |
| Gambar tidak muncul | Pastikan `folder` di DB terisi & file ada di path yang benar |
| Timer tidak jalan | Cek `sisa_detik` dari server, pastikan `datetime.now()` sinkron |
| Import Excel error | Pastikan file `.xlsx` (bukan `.xls`) dan nama sheet = `Bank Soal` |

---

## 🗺️ Roadmap

- [x] Landing page dengan slideshow
- [x] Multi-role login (admin/guru/siswa)
- [x] CRUD kelas, guru, siswa
- [x] Bank soal manual + Excel
- [x] Support gambar soal
- [x] Randomisasi soal & opsi
- [x] Timer otomatis + auto-save
- [x] Custom dialog UI
- [ ] Export nilai ke PDF
- [ ] Soal essay / isian singkat
- [ ] Notifikasi WhatsApp/Email
- [ ] Mode offline (PWA)
- [ ] Multi-bahasa (i18n)
- [ ] Dark mode

---

## 🤝 Kontribusi

Kontribusi selalu terbuka! Silakan:

1. **Fork** repository ini
2. Buat branch baru: `git checkout -b fitur/FiturBaru`
3. **Commit** perubahan: `git commit -m 'Menambah FiturBaru'`
4. **Push** ke branch: `git push origin fitur/FiturBaru`
5. Buat **Pull Request**

### Panduan Kontribusi
- Gunakan **PEP 8** untuk Python
- Ikuti **tema hijau daun** yang sudah ada
- Sertakan **screenshot** jika menambah fitur UI
- Tulis **commit message** yang jelas

---

## 📄 Lisensi

Project ini dilisensikan di bawah **MIT License** — bebas digunakan untuk keperluan pribadi maupun komersial.

Lihat file [LICENSE](LICENSE) untuk detail.

---

## 👨‍💻 Author

**[Aries Setiyawan]**

- 🌐 Website: [https://ariessoftware.my.id](https://ariessoftware.my.id)
- 📧 Email: aries.setiyawan@gmail.com
- 🐙 GitHub: [@ariessetiyawan](https://github.com/ariessetiyawan)
- 💼 LinkedIn: [in/aries-setiyawan-9b7412279](https://linkedin.com/in/aries-setiyawan-9b7412279)

---

## 🙏 Kredit & Ucapan Terima Kasih

- [Flask](https://flask.palletsprojects.com/) — Web framework
- [Tailwind CSS](https://tailwindcss.com/) — CSS framework
- [Font Awesome](https://fontawesome.com/) — Ikon
- [openpyxl](https://openpyxl.readthedocs.io/) — Excel handling
- Komunitas Python & Flask Indonesia 🇮🇩

---

## ⭐ Dukungan

Kalau project ini bermanfaat, berikan **bintang** ⭐ di GitHub — sangat membantu!

<div align="center">

**Dibuat dengan 💚 untuk pendidikan Indonesia**

🌿 **CBT Online** © 2025

</div>
