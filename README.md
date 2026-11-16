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

```sh
sudo install -d /usr/share/sddm/themes/marble
sudo cp -a . /usr/share/sddm/themes/marble/
```

Set `/etc/sddm.conf.d/10-theme.conf` to:

```ini
[Theme]
Current=marble
```

Select the theme on the next login screen. Avoid restarting SDDM from an
active desktop session, as that ends the current graphical session.

## Preview

See [`preview.png`](preview.png) for a visual preview of the layout. It is an
illustration of the theme, not a screenshot of the greeter.

## License

Theme files: GPL-3.0-or-later.

Fredoka One is distributed under the SIL Open Font License; see
[`OFL.txt`](OFL.txt).
