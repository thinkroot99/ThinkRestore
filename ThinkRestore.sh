#!/bin/bash

# Verifică dacă scriptul rulează cu drepturile de administrator (root)
if [[ $EUID -ne 0 ]]; then
   echo "Acest script trebuie să fie rulat cu drepturile de administrator (root)." 
   exit 1
fi

# Verifică dacă rsync este instalat; dacă nu, îl instalează automat
if ! command -v rsync &> /dev/null; then
    echo "Utilitarul rsync nu este instalat. Se va încerca instalarea automată."
    pacman -S --noconfirm rsync
fi

# Sursa backup-ului (directorul unde ai salvat backup-ul)
backup_source="/mnt/backup"

# Destinația pentru restaurare (directoarele de pe sistemul tău care vor fi actualizate cu datele din backup)
restore_destinations=(
    "/etc"
    "/home"
    "/var"
    # Adaugă aici alte directoare pe care vrei să le restaurezi
)

# Execută restaurarea folosind rsync
rsync_options="-aAXv --delete"

echo "Începerea restaurării..."
for dir in "${restore_destinations[@]}"; do
    echo "Restaurare director: $dir"
    rsync $rsync_options "$backup_source/$dir" "$dir"
done

echo "Restaurare finalizată!"

