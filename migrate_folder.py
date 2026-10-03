"""
Assign folder unik ke soal-soal lama yang belum punya folder.
Jalankan: python migrate_folder.py
"""
import os
import uuid
from db import query, execute

UPLOAD_ROOT = os.path.join('static', 'uploads', 'soal')
os.makedirs(UPLOAD_ROOT, exist_ok=True)


def generate_folder_code():
    """Generate kode folder unik: S + 9 hex"""
    while True:
        kode = 'S' + uuid.uuid4().hex[:9].upper()
        cek = query("SELECT id FROM soal WHERE folder=%s", (kode,), one=True)
        if not cek:
            return kode


def main():
    print("=" * 60)
    print("📁 MIGRATE FOLDER — Assign folder unik ke soal lama")
    print("=" * 60)

    # Cari soal yang belum punya folder
    soal_lama = query("SELECT id, LEFT(pertanyaan, 60) AS p FROM soal "
                      "WHERE folder IS NULL OR folder='' ORDER BY id")

    if not soal_lama:
        print("\n✅ Semua soal sudah punya folder. Tidak ada yang perlu dimigrate.")
        return

    print(f"\n📋 Ditemukan {len(soal_lama)} soal tanpa folder.\n")

    sukses = 0
    for s in soal_lama:
        folder = generate_folder_code()

        # Update DB
        execute("UPDATE soal SET folder=%s WHERE id=%s", (folder, s['id']))

        # Buat folder fisik
        folder_path = os.path.join(UPLOAD_ROOT, folder)
        os.makedirs(folder_path, exist_ok=True)

        # Buat file .gitkeep agar folder ikut ter-commit (opsional)
        open(os.path.join(folder_path, '.gitkeep'), 'a').close()

        print(f"  ✅ Soal #{s['id']} → folder {folder}")
        print(f"     {s['p']}...")
        sukses += 1

    print("\n" + "=" * 60)
    print(f"🎉 Selesai! {sukses} soal berhasil diberi folder unik.")
    print("=" * 60)

    # Verifikasi
    total = query("SELECT COUNT(*) AS c FROM soal", one=True)['c']
    punya_folder = query("SELECT COUNT(*) AS c FROM soal "
                         "WHERE folder IS NOT NULL", one=True)['c']
    print(f"\n📊 Total soal          : {total}")
    print(f"📊 Soal punya folder   : {punya_folder}")
    print(f"📊 Soal tanpa folder   : {total - punya_folder}")


if __name__ == '__main__':
    main()