sudo dnf install gnome-tweak-tool svn rsync ostree libappstream-glib gtk3 gnome-themes-extra gtk-murrine-engine sassc
git clone https://github.com/vinceliuice/Orchis-theme.git && cd Orchis-theme && ./install.sh && ./install.sh -l
cd ..
git clone https://github.com/265866/Fedora-Installation.git && cd Fedora-Installation
unzip Orchis-Shell-MOD.zip -d Orchis-shell-MOD
unzip fonts.zip -d fonts
unzip backgrounds.zip -d backgrounds
unzip gnome-extensions-settings.zip -d gnome-extensions-settings
cp -Rv Orchis-shell-MOD ~/themes
cp -Rv fonts ~/.local/share/
cp -Rv backgrounds ~/.local/share/
dconf load /org/gnome/shell/extensions < gnome-extensions-settings/gnome-extensions-settings.conf
cd ..
git clone https://github.com/TaylanTatli/Sevi.git && cd Sevi/ && ./install.sh -a
cd ..
