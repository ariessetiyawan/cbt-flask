-- ============================================================
--  CBT ONLINE — DATABASE SCHEMA
--  Aplikasi Ujian Berbasis Komputer
--  Flask + MySQL + Tailwind CSS
-- ============================================================
--  File   : database.sql
--  Version: 2.0 (Final — include all migrations)
--  Author : [Nama Anda]
--  GitHub : https://github.com/USERNAME/cbt-flask
-- ============================================================

-- ============================================================
--  0. SETUP AWAL
-- ============================================================
DROP DATABASE IF EXISTS cbt_app;
CREATE DATABASE cbt_app
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE cbt_app;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+07:00";  -- WIB (sesuaikan jika perlu)


-- ============================================================
--  1. TABEL USERS
--  Menyimpan akun login untuk semua role (admin, guru, siswa)
-- ============================================================
CREATE TABLE users (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,       -- Hash (Werkzeug scrypt)
    role        ENUM('admin','guru','siswa') NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_users_role (role),
    INDEX idx_users_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
--  2. TABEL KELAS
-- ============================================================
CREATE TABLE kelas (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    nama_kelas  VARCHAR(50) NOT NULL,
    tingkat     VARCHAR(10),                 -- X / XI / XII
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_kelas_tingkat (tingkat)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
--  3. TABEL GURU
--  Terhubung ke users.id (auto-create saat tambah guru)
-- ============================================================
CREATE TABLE guru (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT UNIQUE,
    nip         VARCHAR(30) UNIQUE,
    nama        VARCHAR(100) NOT NULL,
    mapel       VARCHAR(50),                 -- Mata pelajaran
    jk          ENUM('L','P') DEFAULT 'L',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_guru_nip (nip)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
--  4. TABEL SISWA
--  Terhubung ke users.id & kelas.id
-- ============================================================
CREATE TABLE siswa (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT UNIQUE,
    nis         VARCHAR(30) UNIQUE NOT NULL,
    nama        VARCHAR(100) NOT NULL,
    kelas_id    INT,
    jk          ENUM('L','P') DEFAULT 'L',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)  REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (kelas_id) REFERENCES kelas(id) ON DELETE SET NULL,
    INDEX idx_siswa_nis (nis),
    INDEX idx_siswa_kelas (kelas_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
--  5. TABEL SOAL
--  Bank soal + support gambar
--  folder     : kode unik 10 char (contoh: S3A7F2K9Q1)
--  gambar     : nama file saja (tanpa path)
--  gambar_a-d : gambar untuk setiap opsi
--  sumber     : asal soal (manual / excel)
-- ============================================================
CREATE TABLE soal (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    folder      VARCHAR(20) UNIQUE,           -- Kode folder unik
    pertanyaan  TEXT NOT NULL,
    gambar      VARCHAR(255),                 -- Gambar soal (nama file)

    opsi_a      VARCHAR(255),
    gambar_a    VARCHAR(255),
    opsi_b      VARCHAR(255),
    gambar_b    VARCHAR(255),
    opsi_c      VARCHAR(255),
    gambar_c    VARCHAR(255),
    opsi_d      VARCHAR(255),
    gambar_d    VARCHAR(255),

    jawaban     CHAR(1) NOT NULL,             -- A / B / C / D
    sumber      ENUM('manual','excel') DEFAULT 'manual',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_soal_folder (folder),
    INDEX idx_soal_sumber (sumber),
    CONSTRAINT chk_soal_jawaban CHECK (jawaban IN ('A','B','C','D'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
--  6. TABEL UJIAN
--  shuffle_soal : acak urutan soal per siswa (1=ya, 0=tidak)
--  shuffle_opsi : acak urutan opsi jawaban per siswa
-- ============================================================
CREATE TABLE ujian (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    judul         VARCHAR(150) NOT NULL,
    mapel         VARCHAR(50),
    kelas_id      INT,
    durasi        INT DEFAULT 60,             -- Durasi dalam menit
    tanggal       DATE,
    status        ENUM('aktif','nonaktif') DEFAULT 'aktif',
    shuffle_soal  TINYINT(1) DEFAULT 1,
    shuffle_opsi  TINYINT(1) DEFAULT 1,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (kelas_id) REFERENCES kelas(id) ON DELETE SET NULL,
    INDEX idx_ujian_status (status),
    INDEX idx_ujian_kelas (kelas_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
--  7. TABEL UJIAN_SOAL
--  Relasi many-to-many antara ujian dan soal
-- ============================================================
CREATE TABLE ujian_soal (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    ujian_id  INT NOT NULL,
    soal_id   INT NOT NULL,
    FOREIGN KEY (ujian_id) REFERENCES ujian(id) ON DELETE CASCADE,
    FOREIGN KEY (soal_id)  REFERENCES soal(id)  ON DELETE CASCADE,
    UNIQUE KEY unique_ujian_soal (ujian_id, soal_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
--  8. TABEL HASIL_UJIAN
--  Menyimpan nilai & status sesi ujian per siswa
--  status = 'berlangsung' → timer masih jalan
--  status = 'selesai'     → sudah submit
-- ============================================================
CREATE TABLE hasil_ujian (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    ujian_id        INT NOT NULL,
    siswa_id        INT,
    nilai           INT DEFAULT 0,
    benar           INT DEFAULT 0,
    salah           INT DEFAULT 0,
    waktu_mulai     DATETIME,
    waktu_expired   DATETIME,                 -- Batas waktu berakhir
    waktu_selesai   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status          ENUM('berlangsung','selesai') DEFAULT 'selesai',

    FOREIGN KEY (ujian_id) REFERENCES ujian(id) ON DELETE CASCADE,
    FOREIGN KEY (siswa_id) REFERENCES siswa(id) ON DELETE SET NULL,
    INDEX idx_hasil_ujian (ujian_id),
    INDEX idx_hasil_siswa (siswa_id),
    INDEX idx_hasil_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
--  9. TABEL JAWABAN_SISWA
--  Detail jawaban siswa per soal
-- ============================================================
CREATE TABLE jawaban_siswa (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    hasil_id   INT NOT NULL,
    soal_id    INT NOT NULL,
    jawaban    CHAR(1),                       -- A / B / C / D (bisa NULL jika kosong)

    FOREIGN KEY (hasil_id) REFERENCES hasil_ujian(id) ON DELETE CASCADE,
    FOREIGN KEY (soal_id)  REFERENCES soal(id)        ON DELETE CASCADE,
    UNIQUE KEY unique_hasil_soal (hasil_id, soal_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
--  10. TABEL UJIAN_SISWA_SOAL
--  Menyimpan urutan soal & urutan opsi yang sudah diacak
--  untuk setiap sesi siswa (agar tetap konsisten meski refresh)
--
--  urutan_opsi = string 4 char mapping label→opsi asli
--  Contoh 'CADB':
--    label A → opsi C asli
--    label B → opsi A asli
--    label C → opsi D asli
--    label D → opsi B asli
-- ============================================================
CREATE TABLE ujian_siswa_soal (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    hasil_id     INT NOT NULL,
    soal_id      INT NOT NULL,
    urutan       INT NOT NULL,                -- Urutan soal (1, 2, 3, ...)
    urutan_opsi  VARCHAR(10) DEFAULT 'ABCD',

    FOREIGN KEY (hasil_id) REFERENCES hasil_ujian(id) ON DELETE CASCADE,
    FOREIGN KEY (soal_id)  REFERENCES soal(id)        ON DELETE CASCADE,
    UNIQUE KEY unique_hasil_soal (hasil_id, soal_id),
    INDEX idx_uss_urutan (hasil_id, urutan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
--  11. SEED DATA AWAL
-- ============================================================

-- ----------------------------------------
-- 11.1  Admin default
--       Username : admin
--       Password : admin123
--       (hash di-generate via Python — lihat init_admin.py)
-- ----------------------------------------
-- Catatan: hash di bawah adalah placeholder.
-- JALANKAN `python init_admin.py` setelah import SQL ini
-- untuk generate hash admin yang valid.
INSERT INTO users (username, password, role) VALUES
('admin', 'PLACEHOLDER_RUN_INIT_ADMIN_PY', 'admin');


-- ============================================================
--  12. VIEW BANTUAN (Opsional — untuk query cepat)
-- ============================================================

-- View: rekap nilai siswa
CREATE OR REPLACE VIEW v_rekap_nilai AS
SELECT
    h.id              AS hasil_id,
    s.nis,
    s.nama            AS nama_siswa,
    k.nama_kelas,
    u.judul           AS judul_ujian,
    u.mapel,
    h.nilai,
    h.benar,
    h.salah,
    h.waktu_mulai,
    h.waktu_selesai,
    h.status
FROM hasil_ujian h
JOIN siswa  s ON h.siswa_id = s.id
JOIN kelas  k ON s.kelas_id = k.id
JOIN ujian  u ON h.ujian_id = u.id;

-- View: statistik per ujian
CREATE OR REPLACE VIEW v_statistik_ujian AS
SELECT
    u.id              AS ujian_id,
    u.judul,
    k.nama_kelas,
    COUNT(h.id)                          AS total_peserta,
    ROUND(AVG(h.nilai), 2)               AS rata_rata,
    MAX(h.nilai)                         AS nilai_tertinggi,
    MIN(h.nilai)                         AS nilai_terendah,
    SUM(CASE WHEN h.nilai >= 75 THEN 1 ELSE 0 END) AS lulus,
    SUM(CASE WHEN h.nilai <  75 THEN 1 ELSE 0 END) AS tidak_lulus
FROM ujian u
LEFT JOIN kelas k       ON u.kelas_id  = k.id
LEFT JOIN hasil_ujian h ON h.ujian_id  = u.id AND h.status = 'selesai'
GROUP BY u.id;


-- ============================================================
--  13. VERIFIKASI
-- ============================================================
SELECT '✅ Database cbt_app berhasil dibuat!' AS status;
SELECT '📊 Total tabel:' AS info, COUNT(*) AS jumlah
FROM information_schema.tables
WHERE table_schema = 'cbt_app';

SELECT '📋 Daftar tabel:' AS info;
SHOW TABLES;

SELECT '👤 Admin default:' AS info, username, role FROM users WHERE role='admin';


-- ============================================================
--  CATATAN PENGGUNAAN
-- ============================================================
-- Setelah import file ini, jalankan langkah berikut:
--
--   1. python init_admin.py     → Generate hash admin yang valid
--   2. python seed_siswa.py     → (Opsional) Seed siswa + soal contoh
--   3. python seed_gambar.py    → (Opsional) Generate gambar dummy
--   4. python app.py            → Jalankan Flask
--
-- Login default:
--   Admin  : admin / admin123
--   Siswa  : 2024001 / 2024001  (jika seed dijalankan)
--
-- Struktur tabel:
--   users              → Akun login (admin/guru/siswa)
--   kelas              → Data kelas
--   guru               → Profil guru
--   siswa              → Profil siswa
--   soal               → Bank soal + gambar
--   ujian              → Data ujian + shuffle config
--   ujian_soal         → Relasi ujian ↔ soal
--   hasil_ujian        → Rekap nilai per siswa
--   jawaban_siswa      → Detail jawaban per soal
--   ujian_siswa_soal   → Urutan soal & opsi yang diacak
--
-- ============================================================