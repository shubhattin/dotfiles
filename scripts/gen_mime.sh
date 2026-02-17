#!/bin/bash
sudo update-mime-database /usr/share/mime
sudo update-desktop-database /usr/share/applications
update-desktop-database ~/.local/share/applications
XDG_MENU_PREFIX=arch- kbuildsycoca6 --noincremental
rm -f ~/.cache/ksycoca6*
XDG_MENU_PREFIX=arch- kbuildsycoca6 --noincremental