#!/bin/bash

# Script pentru restaurarea unui backup pe Arch Linux
# ----------------------------------------------------
#
# Utilizare:
#   - Asigurați-vă că scriptul are permisiuni de execuție:
#     $ chmod +x nume_script.sh
#   - Rulați scriptul ca administrator:
#     $ sudo ./nume_script.sh
#
# Descriere:
#   Acest script permite restaurarea unui backup în directorul rădăcină al sistemului de fișiere.
#   Asigurați-vă că înțelegeți consecințele acestei operații și că aveți un backup actualizat înainte
#   de a o efectua.
#
# Dependințe:
#   - Acest script va verifica și, dacă este necesar, va instala automat rsync.
#
# Configurare:
#   - Specificați calea către directorul de backup în variabila 'backup_dir'.
#   - Specificați calea către locația unde doriți să restaurați backup-ul în variabila 'restore_dir'.
#
# Exemplu de utilizare:
#   $ chmod +x nume_script.sh
#   $ sudo ./nume_script.sh
#
# ----------------------------------------------------

# Verificați dacă sunteți root (administrator)
if [[ $EUID -ne 0 ]]; then
    echo "Acest script trebuie să fie rulat cu permisiuni de administrator (root)."
    exit 1
fi

# Specificați calea către directorul de backup
backup_dir="/calea/către/directorul/de/backup/"

# Specificați calea către locația unde doriți să restaurați backup-ul
restore_dir="/calea/catre/destinatia/de/restaurare"

# Verificați dacă directorul de backup există
if [ ! -d "$backup_dir" ]; then
    echo "Directorul de backup nu există sau este incorect specificat."
    exit 1
fi

# Verificați dacă locația de restaurare există sau o creați dacă nu există
if [ ! -d "$restore_dir" ]; then
    mkdir -p "$restore_dir"
    echo "Directorul de restaurare a fost creat: $restore_dir"
fi

# Verificați dacă rsync este instalat și, dacă nu, încercați să-l instalați automat
if ! command -v rsync &>/dev/null; then
    echo "Instalarea rsync..."
    if command -v pacman &>/dev/null; then
        sudo pacman -S rsync
    else
        echo "Nu se poate instala rsync. Asigurați-vă că managerul de pachete al sistemului este suportat."
        exit 1
    fi
fi

# Restaurați backup-ul în locația de restaurare folosind rsync
rsync -av "$backup_dir"/ "$restore_dir"/
if [ $? -eq 0 ]; then
    echo "Backup-ul a fost restaurat în $restore_dir."
else
    echo "Restaurarea backup-ului a eșuat."
    exit 1
fi

echo "Procesul de restaurare a fost finalizat cu succes."
