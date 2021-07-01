#!/bin/bash

# Fusuma
cp fusuma/config.yml  ~/.config/fusuma/
cp fusuma/config.yml.old  ~/.config/fusuma/

# Plasma
cp -r plasma/ ~/.config/

# KDE Plasma DE
cp kde/kdeglobals ~/.config/
cp kde/kdeglobals2 ~/.kde/share/config/kdeglobals
cp kde/elisa.conf ~/.config/kde.org/
cp kde/lattedock.conf ~/.config/kde.org/
cp kde/systemsettings.conf ~/.config/kde.org/
cp kde/ksplashrc ~/.config/
cp kde/kfontinstuirc ~/.config/
cp kde/kcminputrc ~/.config/
cp kde/kcmfonts ~/.config/
cp kde/kwinrc ~/.config/
cp kde/Trolltech.conf ~/.config/
cp kde/kscreenlockerrc ~/.config/
cp -r kde/color-schemes/ ~/.kde/share/apps/

# GTK
cp gtk/gtkrc ~/.config/
cp gtk/gtkrc-2.0 ~/.config/
cp gtk/gtkfilechooser.ini ~/.config/gtk-2.0/
cp gtk/gtk.css ~/.config/gtk-3.0/
cp gtk/colors.css ~/.config/gtk-3.0/
cp gtk/settings.ini ~/.config/gtk-3.0/

# SDDM

# KWin
cp -r kwin/local/kwin/ ~/.local/share/
cp -r kwin/usr/kwin/ /usr/share/ 

# Latte Dock (+ widgets)
cp latte/lattedockrc ~/.config/
cp -r latte/latte/ ~/.config/

# Z shell
cp zsh/.zshrc ~/
cp -r zsh/.oh-my-zsh/ ~/

# Konsole
cp konsole/Breeze.colorscheme ~/.local/share/konsole/
cp konsole/konsolerc ~/.config/
cp konsole/Blurred.profile ~/.local/share/konsole/

# Wallpapers
cp wallpapers/Nordic\ wallpaper\ -\ Imgur.jpg ~/Downloads/
cp wallpapers/aerial-view-of-the-sea-wallpaper.jpg ~/Pictures/

# Themes
cp -r themes/Nordic-Darker/ ~/Downloads/
