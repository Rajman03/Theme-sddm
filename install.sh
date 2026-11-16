#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SDDM_CONFIG_DIR=/etc/sddm.conf.d
CONFIG_MARKER="# Managed by SDDM Marble Theme installer"

if [ "$(id -u)" -ne 0 ]; then
    if command -v sudo >/dev/null 2>&1; then
        exec sudo -- "$SCRIPT_DIR/install.sh" "$@"
    fi
    printf 'Instalacja wymaga uprawnień administratora. Zainstaluj sudo albo uruchom skrypt jako root.\n' >&2
    exit 1
fi

if [ ! -t 0 ] || [ ! -t 1 ]; then
    printf 'Uruchom instalator w interaktywnym terminalu.\n' >&2
    exit 1
fi

if command -v dialog >/dev/null 2>&1; then
    UI=dialog
elif command -v whiptail >/dev/null 2>&1; then
    UI=whiptail
else
    UI=text
fi

show_message() {
    case "$UI" in
        dialog) dialog --title "Motyw SDDM Marble" --msgbox "$1" 9 70 ;;
        whiptail) whiptail --title "Motyw SDDM Marble" --msgbox "$1" 9 70 ;;
        *) printf '\n%s\n\n' "$1" ;;
    esac
}

choose_action() {
    case "$UI" in
        dialog)
            REPLY=$(dialog --title "Motyw SDDM Marble" \
                --menu "Zainstaluj motyw i skonfiguruj SDDM." 12 72 2 \
                install "Zainstaluj lub zaktualizuj motyw" \
                cancel "Anuluj" 3>&1 1>&2 2>&3) || return 1
            ;;
        whiptail)
            REPLY=$(whiptail --title "Motyw SDDM Marble" \
                --menu "Zainstaluj motyw i skonfiguruj SDDM." 12 72 2 \
                install "Zainstaluj lub zaktualizuj motyw" \
                cancel "Anuluj" 3>&1 1>&2 2>&3) || return 1
            ;;
        *)
            printf 'Instalator motywu SDDM Marble\n\n1) Zainstaluj lub zaktualizuj motyw\n2) Anuluj\nWybierz [1/2]: '
            IFS= read -r choice || return 1
            case "$choice" in
                1) REPLY=install ;;
                *) REPLY=cancel ;;
            esac
            ;;
    esac
}

confirm_install() {
    prompt="Zainstalować motyw w:
$theme_dir/marble

Instalator ustawi ten katalog w SDDM i włączy zapamiętywanie ostatniego użytkownika."

    case "$UI" in
        dialog) dialog --title "Motyw SDDM Marble" --yesno "$prompt" 12 76 ;;
        whiptail) whiptail --title "Motyw SDDM Marble" --yesno "$prompt" 12 76 ;;
        *)
            printf '%s\nKontynuować? [T/n]: ' "$prompt"
            IFS= read -r answer || return 1
            case "$answer" in
                ""|t|T|tak|Tak|TAK|y|Y|yes|Yes|YES) return 0 ;;
                *) return 1 ;;
            esac
            ;;
    esac
}

detect_theme_dir() {
    for config_file in /etc/sddm.conf "$SDDM_CONFIG_DIR"/*.conf; do
        [ -r "$config_file" ] || continue
        awk '
            /^[[:space:]]*\[Theme\][[:space:]]*$/ { in_theme = 1; next }
            /^[[:space:]]*\[/ { in_theme = 0 }
            in_theme && /^[[:space:]]*ThemeDir[[:space:]]*=/ {
                sub(/^[^=]*=/, "")
                sub(/^[[:space:]]+/, "")
                sub(/[[:space:]]+$/, "")
                value = $0
            }
            END { if (value != "") print value }
        ' "$config_file"
    done | tail -n 1
}

stat_uid() {
    if stat -c '%u' "$1" 2>/dev/null; then
        return 0
    fi
    stat -f '%u' "$1"
}

stat_permissions() {
    if stat -c '%A' "$1" 2>/dev/null; then
        return 0
    fi
    stat -f '%Sp' "$1"
}

is_secure_theme_dir() {
    check_path=$1

    while :; do
        [ -d "$check_path" ] || return 1

        owner=$(stat_uid "$check_path") || return 1
        permissions=$(stat_permissions "$check_path") || return 1
        write_bits=$(printf '%s' "$permissions" | cut -c6,9)

        [ "$owner" = 0 ] || return 1
        case "$write_bits" in
            *w*) return 1 ;;
        esac

        [ "$check_path" = / ] && break
        check_path=$(dirname "$check_path")
    done
}

select_config_file() {
    candidate="$SDDM_CONFIG_DIR/zzzzzzzz-marble-theme.conf"
    suffix=0

    while [ -e "$candidate" ] && ! grep -Fqx "$CONFIG_MARKER" "$candidate"; do
        suffix=$((suffix + 1))
        candidate="$SDDM_CONFIG_DIR/zzzzzzzz-marble-theme.z$suffix.conf"
    done

    CONFIG_FILE=$candidate
}

if ! choose_action; then
    exit 0
fi

if [ "$REPLY" != install ]; then
    exit 0
fi

theme_dir=$(detect_theme_dir)
theme_dir=${theme_dir:-/usr/share/sddm/themes}
case "$theme_dir" in
    /*) ;;
    *)
        show_message "Ścieżka katalogu motywów musi być bezwzględna."
        exit 1
        ;;
esac

case "$theme_dir" in
    /|*'#'*|*';'*|*'='*)
        show_message "Katalog motywów zawiera niedozwolone znaki."
        exit 1
        ;;
esac

while [ "${theme_dir%/}" != "$theme_dir" ]; do
    theme_dir=${theme_dir%/}
done

if ! is_secure_theme_dir "$theme_dir"; then
    show_message "Katalog motywów lub jeden z jego katalogów nadrzędnych nie istnieje, nie należy do root albo jest zapisywalny przez innych użytkowników. SDDM wymaga zaufanego katalogu systemowego. Ustaw ThemeDir w konfiguracji SDDM na bezpieczny katalog i uruchom instalator ponownie."
    exit 1
fi

theme_path="$theme_dir/marble"
if ! confirm_install; then
    exit 0
fi

install -d "$theme_path/components" "$SDDM_CONFIG_DIR"

install -m 644 \
    "$SCRIPT_DIR/Main.qml" \
    "$SCRIPT_DIR/theme.conf" \
    "$SCRIPT_DIR/metadata.desktop" \
    "$SCRIPT_DIR/FredokaOne.ttf" \
    "$SCRIPT_DIR/OFL.txt" \
    "$theme_path/"

for component in "$SCRIPT_DIR"/components/*.qml; do
    install -m 644 "$component" "$theme_path/components/"
done

if id sddm >/dev/null 2>&1 && command -v runuser >/dev/null 2>&1; then
    if ! runuser -u sddm -- test -r "$theme_path/Main.qml"; then
        show_message "Greeter SDDM nie ma dostępu do plików w:
$theme_path

Wybierz katalog dostępny do odczytu dla użytkownika sddm."
        exit 1
    fi
fi

select_config_file
config_tmp=$(mktemp "$SDDM_CONFIG_DIR/.marble-theme.XXXXXX")
cleanup() {
    if [ -n "${config_tmp:-}" ]; then
        rm -f "$config_tmp"
    fi
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM

{
    printf '%s\n[Theme]\nThemeDir=%s\nCurrent=marble\n\n[Users]\nRememberLastUser=true\n' \
        "$CONFIG_MARKER" "$theme_dir"
} > "$config_tmp"

chmod 644 "$config_tmp"
mv -f "$config_tmp" "$CONFIG_FILE"
config_tmp=
trap - EXIT HUP INT TERM

show_message "Zainstalowano w:
$theme_path

SDDM wybierze motyw Marble i zapamięta ostatniego użytkownika. Motyw będzie aktywny przy następnym ekranie logowania. Nie restartuj SDDM z aktywnej sesji."
