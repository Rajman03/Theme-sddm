# SDDM Marble Theme

A light turquoise SDDM login theme with a generated gradient background and
the Fredoka One typeface. The reference screenshot is not used as wallpaper.

## Features

- Solid `#80D4D9` background with subtle decorative shapes
- Polish clock and date
- Fredoka One font bundled with the theme
- First login: enter an existing system username and password
- Later logins: SDDM remembers the last user, so only the password is needed
- Account selector for existing users and session selector

The theme does not create system accounts or store passwords. Accounts must
already exist on the computer. Last-user selection is controlled by SDDM's
`RememberLastUser` setting.

## Install

From the project directory, run:

```sh
./install.sh
```

The TUI installer requests administrator privileges, detects the configured
SDDM theme directory, verifies that it is a trusted system directory, installs
the complete theme (including its QML components), and updates only the
relevant theme and last-user settings in `/etc/sddm.conf`. It uses `dialog` or
`whiptail` when available and has a terminal fallback. Other SDDM settings are
preserved. The theme is selected at the next login screen; do not restart SDDM
from an active desktop session.

## Customize

Edit the color and `timeScale` / `dateScale` values in `theme.conf`. UI
sections are separated into `components/ThemeBackground.qml`,
`components/ClockDisplay.qml`, `components/LoginPanel.qml`,
`components/SessionControls.qml`, and `components/ActionIcon.qml`.

The project layout is intentionally simple:

```text
Main.qml             screen layout and SDDM wiring
theme.conf           theme colors and font settings
components/           reusable screen components
FredokaOne.ttf        bundled display font
install.sh            system install helper
preview.png           visual preview
```

## Preview

See [`preview.png`](preview.png) for a visual preview of the layout. It is an
illustration of the theme, not a screenshot of the greeter.

## License

Theme files: MIT; see [`LICENSE`](LICENSE).

Fredoka One is distributed under the SIL Open Font License; see
[`OFL.txt`](OFL.txt).
