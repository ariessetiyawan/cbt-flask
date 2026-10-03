-- ============================================================
--  CBT ONLINE — DATABASE MIGRATION
--  Upgrade dari versi lama → versi baru (SAFE — no data loss)
-- ============================================================
--  File    : migration.sql
--  Version : 1.0 → 2.0
--  Author  : [Nama Anda]
--  GitHub  : https://github.com/USERNAME/cbt-flask
-- ============================================================
--  ⚠️  PENTING — BACA SEBELUM JALANKAN:
--
--  1. BACKUP database dulu!
--     mysqldump -u root -p cbt_app > backup_$(date +%Y%m%d).sql
--
--  2. Jalankan file ini SEKALI saja
--  3. Script ini IDEMPOTENT — aman dijalankan ulang
--     (kolom/tabel yang sudah ada akan di-skip)
--  4. Setelah import, jalankan `python init_admin.py`
-- ============================================================

USE cbt_app;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+07:00";


-- ============================================================
--  1. HELPER PROCEDURE — Cek kolom sudah ada atau belum
--  (Dipakai agar migration aman dijalankan ulang)
-- ============================================================

DROP PROCEDURE IF EXISTS add_column_if_not_exists;
DROP PROCEDURE IF EXISTS drop_column_if_exists;
DROP PROCEDURE IF EXISTS add_index_if_not_exists;

DELIMITER $$

CREATE PROCEDURE add_column_if_not_exists(
    IN tbl_name  VARCHAR(64),
    IN col_name  VARCHAR(64),
    IN col_def   TEXT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name   = tbl_name
          AND column_name  = col_name
    ) THEN
        SET @sql = CONCAT('ALTER TABLE `', tbl_name, '` ADD COLUMN `', col_name, '` ', col_def);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SELECT CONCAT('✅ Added column: ', tbl_name, '.', col_name) AS progress;
    ELSE
        SELECT CONCAT('♻️  Skip (exists): ', tbl_name, '.', col_name) AS progress;
    END IF;
END$$

CREATE PROCEDURE drop_column_if_exists(
    IN tbl_name  VARCHAR(64),
    IN col_name  VARCHAR(64)
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name   = tbl_name
          AND column_name  = col_name
    ) THEN
        SET @sql = CONCAT('ALTER TABLE `', tbl_name, '` DROP COLUMN `', col_name, '`');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SELECT CONCAT('✅ Dropped column: ', tbl_name, '.', col_name) AS progress;
    END IF;
END$$

CREATE PROCEDURE add_index_if_not_exists(
    IN tbl_name   VARCHAR(64),
    IN idx_name   VARCHAR(64),
    IN idx_cols   TEXT,
    IN idx_unique TINYINT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name   = tbl_name
          AND index_name   = idx_name
    ) THEN
        SET @sql = CONCAT(
            'ALTER TABLE `', tbl_name, '` ADD ',
            IF(idx_unique=1, 'UNIQUE ', ''),
            'INDEX `', idx_name, '` (', idx_cols, ')'
        );
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SELECT CONCAT('✅ Added index: ', tbl_name, '.', idx_name) AS progress;
    ELSE
        SELECT CONCAT('♻️  Skip (exists): ', tbl_name, '.', idx_name) AS progress;
    END IF;
END$$

DELIMITER ;


-- ============================================================
--  2. MIGRATION v1.0 → v2.0
--     Tambah dukungan: gambar soal, folder unik, shuffle, timer
-- ============================================================

SELECT '========================================' AS '';
SELECT '  MIGRATION 1: SOAL — Kolom gambar' AS '';
SELECT '========================================' AS '';

-- Kolom folder unik per soal (kode S + 9 char hex)
CALL add_column_if_not_exists('soal', 'folder',
    "VARCHAR(20) UNIQUE NULL AFTER id");

-- Kolom sumber (manual/excel)
CALL add_column_if_not_exists('soal', 'sumber',
    "ENUM('manual','excel') DEFAULT 'manual' AFTER jawaban");

-- Kolom gambar utama soal
CALL add_column_if_not_exists('soal', 'gambar',
    "VARCHAR(255) NULL AFTER pertanyaan");

-- Kolom gambar per opsi
CALL add_column_if_not_exists('soal', 'gambar_a',
    "VARCHAR(255) NULL AFTER opsi_a");

CALL add_column_if_not_exists('soal', 'gambar_b',
    "VARCHAR(255) NULL AFTER opsi_b");

CALL add_column_if_not_exists('soal', 'gambar_c',
    "VARCHAR(255) NULL AFTER opsi_c");

CALL add_column_if_not_exists('soal', 'gambar_d',
    "VARCHAR(255) NULL AFTER opsi_d");

-- Index untuk lookup folder cepat
CALL add_index_if_not_exists('soal', 'idx_soal_folder', '`folder`', 0);
CALL add_index_if_not_exists('soal', 'idx_soal_sumber', '`sumber`', 0);


SELECT '========================================' AS '';
SELECT '  MIGRATION 2: UJIAN — Kolom shuffle' AS '';
SELECT '========================================' AS '';

CALL add_column_if_not_exists('ujian', 'shuffle_soal',
    "TINYINT(1) DEFAULT 1 AFTER status");

CALL add_column_if_not_exists('ujian', 'shuffle_opsi',
    "TINYINT(1) DEFAULT 1 AFTER shuffle_soal");


SELECT '========================================' AS '';
SELECT '  MIGRATION 3: HASIL_UJIAN — Timer' AS '';
SELECT '========================================' AS '';

CALL add_column_if_not_exists('hasil_ujian', 'waktu_mulai',
    "DATETIME NULL AFTER salah");

CALL add_column_if_not_exists('hasil_ujian', 'waktu_expired',
    "DATETIME NULL AFTER waktu_mulai");

CALL add_column_if_not_exists('hasil_ujian', 'status',
    "ENUM('berlangsung','selesai') DEFAULT 'selesai' AFTER waktu_selesai");

-- Index untuk filter status
CALL add_index_if_not_exists('hasil_ujian', 'idx_hasil_status', '`status`', 0);


SELECT '========================================' AS '';
SELECT '  MIGRATION 4: TABEL BARU' AS '';
SELECT '========================================' AS '';

-- Tabel ujian_siswa_soal (untuk persist urutan acak soal & opsi)
CREATE TABLE IF NOT EXISTS ujian_siswa_soal (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    hasil_id     INT NOT NULL,
    soal_id      INT NOT NULL,
    urutan       INT NOT NULL,
    urutan_opsi  VARCHAR(10) DEFAULT 'ABCD',

    FOREIGN KEY (hasil_id) REFERENCES hasil_ujian(id) ON DELETE CASCADE,
    FOREIGN KEY (soal_id)  REFERENCES soal(id)        ON DELETE CASCADE,
    UNIQUE KEY unique_hasil_soal (hasil_id, soal_id),
    INDEX idx_uss_urutan (hasil_id, urutan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SELECT '✅ Tabel ujian_siswa_soal siap' AS progress;


SELECT '========================================' AS '';
SELECT '  MIGRATION 5: Update data existing' AS '';
SELECT '========================================' AS '';

-- Soal lama yang belum punya folder → generate folder otomatis
-- (kode folder akan di-generate via Python, di sini kita skip saja)
-- Tandai soal lama sebagai 'manual'
UPDATE soal
SET sumber = 'manual'
WHERE sumber IS NULL OR sumber = '';

SELECT CONCAT('✅ Updated ', ROW_COUNT(), ' soal lama → sumber=manual') AS progress;

-- Ujian lama yang belum punya kolom shuffle → set default aktif
UPDATE ujian
SET shuffle_soal = 1
WHERE shuffle_soal IS NULL;

UPDATE ujian
SET shuffle_opsi = 1
WHERE shuffle_opsi IS NULL;

SELECT CONCAT('✅ Updated ', ROW_COUNT(), ' ujian → shuffle default aktif') AS progress;


-- ============================================================
--  3. VIEW BANTUAN (opsional, mudah di-query)
-- ============================================================

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

SELECT '✅ Views siap: v_rekap_nilai, v_statistik_ujian' AS progress;


-- ============================================================
--  4. CLEANUP — Hapus procedure helper
-- ============================================================

DROP PROCEDURE IF EXISTS add_column_if_not_exists;
DROP PROCEDURE IF EXISTS drop_column_if_exists;
DROP PROCEDURE IF EXISTS add_index_if_not_exists;

SELECT '✅ Cleanup procedure selesai' AS progress;


-- ============================================================
--  5. VERIFIKASI AKHIR
-- ============================================================

SELECT '========================================' AS '';
SELECT '  VERIFIKASI HASIL MIGRATION' AS '';
SELECT '========================================' AS '';

SELECT '📋 Struktur tabel SOAL:' AS info;
SHOW COLUMNS FROM soal;

SELECT '📋 Struktur tabel UJIAN:' AS info;
SHOW COLUMNS FROM ujian;

SELECT '📋 Struktur tabel HASIL_UJIAN:' AS info;
SHOW COLUMNS FROM hasil_ujian;

SELECT '📊 Ringkasan:' AS info;
SELECT
    (SELECT COUNT(*) FROM soal)        AS total_soal,
    (SELECT COUNT(*) FROM soal WHERE folder IS NOT NULL) AS soal_punya_folder,
    (SELECT COUNT(*) FROM ujian)       AS total_ujian,
    (SELECT COUNT(*) FROM hasil_ujian) AS total_hasil,
    (SELECT COUNT(*) FROM siswa)       AS total_siswa;

SELECT '🎉 MIGRATION SELESAI!' AS status;


-- ============================================================
--  CATATAN POST-MIGRATION
-- ============================================================
--
-- Setelah migration ini sukses, WAJIB jalankan:
--
--   1. python migrate_folder.py
--      → Assign folder unik ke soal-soal lama yang belum punya
--
--   2. python init_admin.py
--      → Regenerate hash admin (jika perlu)
--
--   3. Restart Flask: python app.py
--
-- Cek hasil:
--   SELECT id, folder, LEFT(pertanyaan, 40) FROM soal LIMIT 5;
--
--   Harusnya setiap soal punya folder unik seperti:
--   S3A7F2K9Q1, S8B2M4X7P3, S5C9N1L6R4, dst.
--
-- ============================================================