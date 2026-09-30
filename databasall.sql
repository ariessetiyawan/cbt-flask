-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versi server:                 10.4.32-MariaDB - mariadb.org binary distribution
-- OS Server:                    Win64
-- HeidiSQL Versi:               12.15.0.7171
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Membuang struktur basisdata untuk cbt_app
CREATE DATABASE IF NOT EXISTS `cbt_app` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `cbt_app`;

-- membuang struktur untuk table cbt_app.guru
CREATE TABLE IF NOT EXISTS `guru` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `nip` varchar(30) DEFAULT NULL,
  `nama` varchar(100) NOT NULL,
  `mapel` varchar(50) DEFAULT NULL,
  `jk` enum('L','P') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nip` (`nip`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `guru_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Membuang data untuk tabel cbt_app.guru: ~0 rows (lebih kurang)

-- membuang struktur untuk table cbt_app.hasil_ujian
CREATE TABLE IF NOT EXISTS `hasil_ujian` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ujian_id` int(11) DEFAULT NULL,
  `siswa_id` int(11) DEFAULT NULL,
  `nilai` int(11) DEFAULT 0,
  `benar` int(11) DEFAULT 0,
  `salah` int(11) DEFAULT 0,
  `waktu_selesai` timestamp NOT NULL DEFAULT current_timestamp(),
  `waktu_mulai` datetime DEFAULT NULL,
  `status` enum('berlangsung','selesai') DEFAULT 'selesai',
  `waktu_expired` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Membuang data untuk tabel cbt_app.hasil_ujian: ~0 rows (lebih kurang)
INSERT INTO `hasil_ujian` (`id`, `ujian_id`, `siswa_id`, `nilai`, `benar`, `salah`, `waktu_selesai`, `waktu_mulai`, `status`, `waktu_expired`) VALUES
	(1, 1, 3, 60, 3, 2, '2026-09-30 11:47:43', '2026-09-30 12:33:27', 'selesai', '2026-09-30 13:03:27');

-- membuang struktur untuk table cbt_app.jawaban_siswa
CREATE TABLE IF NOT EXISTS `jawaban_siswa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hasil_id` int(11) DEFAULT NULL,
  `soal_id` int(11) DEFAULT NULL,
  `jawaban` char(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hasil_id` (`hasil_id`),
  KEY `soal_id` (`soal_id`),
  CONSTRAINT `jawaban_siswa_ibfk_1` FOREIGN KEY (`hasil_id`) REFERENCES `hasil_ujian` (`id`) ON DELETE CASCADE,
  CONSTRAINT `jawaban_siswa_ibfk_2` FOREIGN KEY (`soal_id`) REFERENCES `soal` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Membuang data untuk tabel cbt_app.jawaban_siswa: ~0 rows (lebih kurang)
INSERT INTO `jawaban_siswa` (`id`, `hasil_id`, `soal_id`, `jawaban`) VALUES
	(1, 1, 3, 'A'),
	(2, 1, 5, 'A'),
	(3, 1, 4, 'C'),
	(4, 1, 1, 'A'),
	(5, 1, 2, 'D');

-- membuang struktur untuk table cbt_app.kelas
CREATE TABLE IF NOT EXISTS `kelas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama_kelas` varchar(50) NOT NULL,
  `tingkat` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Membuang data untuk tabel cbt_app.kelas: ~3 rows (lebih kurang)
INSERT INTO `kelas` (`id`, `nama_kelas`, `tingkat`) VALUES
	(1, 'XII IPA 1', 'XII'),
	(2, 'XII IPA 2', 'XII'),
	(3, 'XI IPA 1', 'XI');

-- membuang struktur untuk table cbt_app.siswa
CREATE TABLE IF NOT EXISTS `siswa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `nis` varchar(30) DEFAULT NULL,
  `nama` varchar(100) NOT NULL,
  `kelas_id` int(11) DEFAULT NULL,
  `jk` enum('L','P') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nis` (`nis`),
  KEY `user_id` (`user_id`),
  KEY `kelas_id` (`kelas_id`),
  CONSTRAINT `siswa_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `siswa_ibfk_2` FOREIGN KEY (`kelas_id`) REFERENCES `kelas` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Membuang data untuk tabel cbt_app.siswa: ~0 rows (lebih kurang)
INSERT INTO `siswa` (`id`, `user_id`, `nis`, `nama`, `kelas_id`, `jk`) VALUES
	(3, 101, '2024001', 'Ahmad Fauzi', 1, 'L'),
	(4, 102, '2024002', 'Budi Santoso', 1, 'L'),
	(5, 103, '2024003', 'Citra Dewi', 1, 'P'),
	(6, 104, '2024004', 'Dian Pratama', 1, 'L'),
	(7, 105, '2024005', 'Eka Wijaya', 1, 'P'),
	(8, 106, '2024006', 'Fajar Ramadhan', 2, 'L'),
	(9, 107, '2024007', 'Gita Permata', 2, 'P'),
	(10, 108, '2024008', 'Hendra Kusuma', 2, 'L'),
	(11, 109, '2024009', 'Indah Sari', 2, 'P'),
	(12, 110, '2024010', 'Joko Widodo', 2, 'L'),
	(13, 111, '2024011', 'Kartika Sari', 3, 'P'),
	(14, 112, '2024012', 'Lukman Hakim', 3, 'L'),
	(15, 113, '2024013', 'Maya Anggraini', 3, 'P'),
	(16, 114, '2024014', 'Nanda Pratama', 3, 'L'),
	(17, 115, '2024015', 'Oktavia Putri', 3, 'P');

-- membuang struktur untuk table cbt_app.soal
CREATE TABLE IF NOT EXISTS `soal` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `folder` varchar(20) DEFAULT NULL,
  `pertanyaan` text NOT NULL,
  `gambar` varchar(255) DEFAULT NULL,
  `opsi_a` varchar(255) DEFAULT NULL,
  `gambar_a` varchar(255) DEFAULT NULL,
  `opsi_b` varchar(255) DEFAULT NULL,
  `gambar_b` varchar(255) DEFAULT NULL,
  `opsi_c` varchar(255) DEFAULT NULL,
  `gambar_c` varchar(255) DEFAULT NULL,
  `opsi_d` varchar(255) DEFAULT NULL,
  `gambar_d` varchar(255) DEFAULT NULL,
  `jawaban` char(1) NOT NULL,
  `sumber` enum('manual','excel') DEFAULT 'manual',
  PRIMARY KEY (`id`),
  UNIQUE KEY `folder` (`folder`),
  KEY `idx_soal_folder` (`folder`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Membuang data untuk tabel cbt_app.soal: ~0 rows (lebih kurang)
INSERT INTO `soal` (`id`, `folder`, `pertanyaan`, `gambar`, `opsi_a`, `gambar_a`, `opsi_b`, `gambar_b`, `opsi_c`, `gambar_c`, `opsi_d`, `gambar_d`, `jawaban`, `sumber`) VALUES
	(1, 'S1CONTOH01', 'Ibu kota Indonesia adalah?', NULL, 'Jakarta', NULL, 'Bandung', NULL, 'Surabaya', NULL, 'Medan', NULL, 'A', 'excel'),
	(2, 'S2CONTOH02', 'Hasil dari 25 × 4 adalah?', NULL, '90', NULL, '100', NULL, '110', NULL, '120', NULL, 'B', 'excel'),
	(3, 'S3CONTOH03', 'Siapa proklamator kemerdekaan Indonesia?', NULL, 'Soekarno & Hatta', NULL, 'Soeharto', NULL, 'Habibie', NULL, 'Soekarno saja', NULL, 'A', 'excel'),
	(4, 'S4CONTOH04', 'Perhatikan gambar berikut. Bangun datar apakah ini?', 'segitiga.svg', 'Segitiga sama sisi', NULL, 'Persegi panjang', NULL, 'Trapesium', NULL, 'Jajar genjang', NULL, 'A', 'excel'),
	(5, 'S5CONTOH05', 'Perhatikan gambar berikut. Berapakah luas bangun datar ini jika panjang sisi 6 cm?', 'persegi.svg', '24 cm²', NULL, '30 cm²', NULL, '36 cm²', 'rumus_luas.svg', '42 cm²', NULL, 'C', 'excel');

-- membuang struktur untuk table cbt_app.ujian
CREATE TABLE IF NOT EXISTS `ujian` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `judul` varchar(150) NOT NULL,
  `mapel` varchar(50) DEFAULT NULL,
  `kelas_id` int(11) DEFAULT NULL,
  `durasi` int(11) DEFAULT 60,
  `tanggal` date DEFAULT NULL,
  `status` enum('aktif','nonaktif') DEFAULT 'aktif',
  `shuffle_soal` tinyint(1) DEFAULT 1,
  `shuffle_opsi` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `kelas_id` (`kelas_id`),
  CONSTRAINT `ujian_ibfk_1` FOREIGN KEY (`kelas_id`) REFERENCES `kelas` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Membuang data untuk tabel cbt_app.ujian: ~0 rows (lebih kurang)
INSERT INTO `ujian` (`id`, `judul`, `mapel`, `kelas_id`, `durasi`, `tanggal`, `status`, `shuffle_soal`, `shuffle_opsi`) VALUES
	(1, 'Ulangan Harian Matematika Dasar', 'Matematika', 1, 30, '2026-09-30', 'aktif', 1, 1),
	(2, 'Ulangan Harian Matematika Dasar', 'Matematika', 2, 30, '2026-09-30', 'aktif', 1, 1),
	(3, 'Ulangan Harian Matematika Dasar', 'Matematika', 3, 30, '2026-09-30', 'aktif', 1, 1);

-- membuang struktur untuk table cbt_app.ujian_soal
CREATE TABLE IF NOT EXISTS `ujian_soal` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ujian_id` int(11) DEFAULT NULL,
  `soal_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ujian_id` (`ujian_id`),
  KEY `soal_id` (`soal_id`),
  CONSTRAINT `ujian_soal_ibfk_1` FOREIGN KEY (`ujian_id`) REFERENCES `ujian` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ujian_soal_ibfk_2` FOREIGN KEY (`soal_id`) REFERENCES `soal` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Membuang data untuk tabel cbt_app.ujian_soal: ~0 rows (lebih kurang)
INSERT INTO `ujian_soal` (`id`, `ujian_id`, `soal_id`) VALUES
	(1, 1, 1),
	(2, 1, 2),
	(3, 1, 3),
	(4, 1, 4),
	(5, 1, 5),
	(6, 2, 1),
	(7, 2, 2),
	(8, 2, 3),
	(9, 2, 4),
	(10, 2, 5),
	(11, 3, 1),
	(12, 3, 2),
	(13, 3, 3),
	(14, 3, 4),
	(15, 3, 5);

-- membuang struktur untuk table cbt_app.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','guru','siswa') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Membuang data untuk tabel cbt_app.users: ~1 rows (lebih kurang)
INSERT INTO `users` (`id`, `username`, `password`, `role`, `created_at`) VALUES
	(2, 'admin', 'scrypt:32768:8:1$B3au00Heo0hE2Iz6$596f4f9509eebecb06b20e34194c0d0381aa06c473697c0034684fd004ca0c799f1e5a2cdb8c5aa31d6484fae24993e2edc78026474873b6c10b161dd73fd941', 'admin', '2026-09-30 10:07:06'),
	(101, '2024001', 'scrypt:32768:8:1$7IHfaNFFpqGd8saI$dc602f5ab7c6bba2e1f78e6b910c3eb7497b3da45b19d49263bc6159d43f4110e6e25061cdfa17fd373dd91f004acc9f95426c4d6d0086f523ddf7ab9c7321ec', 'siswa', '2026-09-30 11:23:12'),
	(102, '2024002', 'scrypt:32768:8:1$8J2DvwxLdIrxQChl$17674874bed13dd33588ec158d1cd85d4bf5b75ca52c423f4a46b03a1da9a7d526206f9d92a147e531f044e7fb0c3e3d999c5a6e8191bbbbf48d55d8c0656165', 'siswa', '2026-09-30 11:23:12'),
	(103, '2024003', 'scrypt:32768:8:1$x7EANm10gjXULeJp$cf2009ea73e2db17b463ff14e01d2e1eea6241f9fd749a44962bb3fe1103dc54fe37c39f0eabd2080c21dc364e502445b65e7b55c66ccd2e9f1b944ad5f78d0a', 'siswa', '2026-09-30 11:23:12'),
	(104, '2024004', 'scrypt:32768:8:1$XLIwFXQivlJHPgVJ$65f329c6edf156e8cc0d634980e788c3f6c8112a95a2652d86cc2633926a05c328c6f198ac75b22e94bc2d3c580c6960c2de9bcab5e802e17c14ce96421ac71c', 'siswa', '2026-09-30 11:23:12'),
	(105, '2024005', 'scrypt:32768:8:1$tHDoVIcbJUrr4YKo$7acaedaf28540f0be10593feb89cec1ab14958215a1441c29b8067d13018e1ee5a967993f5ff48b2e17e27f179724ccf99695add6e3bc4496f22b0d1a5ad8b1a', 'siswa', '2026-09-30 11:23:12'),
	(106, '2024006', 'scrypt:32768:8:1$A2cW9kddjyfOyq5P$3175116ef4060cd626ce859950b89de10a031391c9d3b8c4b7a9e0c2959f4ff8458dfb4d888ccd1adb9373aafc7d77b7d3796d5dc355bab632a5d52f72044094', 'siswa', '2026-09-30 11:23:12'),
	(107, '2024007', 'scrypt:32768:8:1$fpRe2BN29GM2qHjU$8a0d3e75d72f7637c5d29483f144980aba6dd3381785ce61d79428ee3e463bdf5e8a8572f7a77e36f377dcb56c43f433fb1fe3e9502f73ac228ba4944ace7bff', 'siswa', '2026-09-30 11:23:12'),
	(108, '2024008', 'scrypt:32768:8:1$kIxrprwd8RwioFvF$a6bcef2be05317e4a2bcb4c669eeb51fb3b0c6abed21e3fba9b46cfe086f1f2e9c9b5ffce4929e6f3d08cc92b07929255acc40f94242325594db07b2a2b122fc', 'siswa', '2026-09-30 11:23:13'),
	(109, '2024009', 'scrypt:32768:8:1$IC2l7SKOoFLtsUfi$b62fb202b85f6a0b7708870965fc2a59f49d49877ead38407512a0a2f9f6233e00f7050d5d25fcb9b675e2308d9917b91d5739fe900f892d2281ddc7ff2c7826', 'siswa', '2026-09-30 11:23:13'),
	(110, '2024010', 'scrypt:32768:8:1$e6RfIk5i0LE4Yitb$e599b52a1497e1b5bb7aef672d91cebb07c0d0d9ab4c0031258e73dbb670ae20045c872bf8493264ecd6218d90604c435db6bfb94d375289182ba1afff945d84', 'siswa', '2026-09-30 11:23:13'),
	(111, '2024011', 'scrypt:32768:8:1$zFpFBaxaY61EuVB5$8ae47ba88a1a3d8f418ecd0d0dec0e6e857da7feed92697613d20dfcb168779a11677a36f04f142ebf3c38d19628b29ba63685102ec99a0e88739a5b680976c9', 'siswa', '2026-09-30 11:23:13'),
	(112, '2024012', 'scrypt:32768:8:1$i47hMc7uBgN84DJP$ce44b18685a9b2d28c4e69832d5762b2cb8c4b015f85c77fd90e0c52a99ab39cb522b1f8183d6edc7a8ec54ccec826211b19330c08615560b235dfff8fba6e85', 'siswa', '2026-09-30 11:23:13'),
	(113, '2024013', 'scrypt:32768:8:1$QtaGbLKIsYuKlOHq$03a4bfe350a2bc8bb9fdd2be256c799c696ba081346f558f5bf1bd43b70da593f1f95a93ab4f0dd7809bca5ba456f160c01a9bc0290e948ca619812eac41b872', 'siswa', '2026-09-30 11:23:13'),
	(114, '2024014', 'scrypt:32768:8:1$QrpCNMLiBjCoaN44$0e374aaac20de3204ce3518a2630901232b0b1ce91c4dc9fcad137cf079229b123ef1a728ed20e98040c125d497ada27471a868dcb3e45ae7c8f682ea626ebf2', 'siswa', '2026-09-30 11:23:13'),
	(115, '2024015', 'scrypt:32768:8:1$VrJem3MzoTUWUMkY$adbca12f2751282be746b62f56e2341a960f41a4e21e59a5a2e8b01db3b4f75bc0ae9ca929c6e38f84cbb2aa9aaa15695e30a0bcb21821d72b5b824104ccb565', 'siswa', '2026-09-30 11:23:13');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
