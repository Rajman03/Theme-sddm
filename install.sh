#!/bin/sh
set -eu

if [ "$(id -u)" -ne 0 ]; then
    printf 'Run this installer as root, for example: sudo %s\n' "$0" >&2
    exit 1
fi

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
THEME_DIR=/usr/share/sddm/themes/marble
CONFIG_FILE=/etc/sddm.conf.d/zzzz-marble-theme.conf

if [ -e "$CONFIG_FILE" ] && ! grep -q '^Current=marble$' "$CONFIG_FILE"; then
    printf 'Refusing to overwrite existing SDDM config: %s\n' "$CONFIG_FILE" >&2
    exit 1
fi

install -d "$THEME_DIR/components" /etc/sddm.conf.d
install -m 644 \
    "$SCRIPT_DIR/Main.qml" \
    "$SCRIPT_DIR/theme.conf" \
    "$SCRIPT_DIR/metadata.desktop" \
    "$SCRIPT_DIR/FredokaOne.ttf" \
    "$SCRIPT_DIR/OFL.txt" \
    "$THEME_DIR/"

for component in "$SCRIPT_DIR"/components/*.qml; do
    install -m 644 "$component" "$THEME_DIR/components/"
done

if [ ! -e "$CONFIG_FILE" ]; then
    printf '[Theme]\nCurrent=marble\n' > "$CONFIG_FILE"
    chmod 644 "$CONFIG_FILE"
fi

printf 'Installed SDDM Marble theme to %s\n' "$THEME_DIR"
printf 'Selected for the next login screen. Do not restart SDDM from your active session.\n'
