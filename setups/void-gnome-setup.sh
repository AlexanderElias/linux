

echo "repository=https://mirrors.servercentral.com/voidlinux/current" > 00-repository-main.conf
echo "repository=https://mirrors.servercentral.com/voidlinux/current/nonfree" > 00-repository-main.conf

# update system
xbps-install -Syu
xbps-install -Syu

# install personal apps
xbps-install -S chromium atom nodejs vim spotify steam inkscape chrome-gnome-shell

mkdir ~/.icons
mkdir ~/.themes

git clone https://github.com/daniruiz/flat-remix.git
git clone https://github.com/daniruiz/flat-remix-gtk.git
git clone https://github.com/daniruiz/flat-remix-gnome.git

mv flat-remix/Flat-Remix-Blue ~/.icons/.
mv flat-remix/Flat-Remix-Blue-Dark ~/.icons/.
mv flat-remix/Flat-Remix-Blue-Light ~/.icons/.

mv flat-remix-gtk/Flat-Remix-GTK-Blue ~/.themes/.
mv flat-remix-gtk/Flat-Remix-GTK-Blue-Dark ~/.themes/.
mv flat-remix-gtk/Flat-Remix-GTK-Blue-Dark-Solid ~/.themes/.
mv flat-remix-gtk/Flat-Remix-GTK-Blue-Darker ~/.themes/.
mv flat-remix-gtk/Flat-Remix-GTK-Blue-Darker-Solid ~/.themes/.
mv flat-remix-gtk/Flat-Remix-GTK-Blue-Darkest ~/.themes/.
mv flat-remix-gtk/Flat-Remix-GTK-Blue-Darkest-NoBorder ~/.themes/.
mv flat-remix-gtk/Flat-Remix-GTK-Blue-Darkest-Solid ~/.themes/.
mv flat-remix-gtk/Flat-Remix-GTK-Blue-Darkest-Solid-NoBorder ~/.themes/.
mv flat-remix-gtk/Flat-Remix-GTK-Blue-Solid ~/.themes/.

mv flat-remix-gnome/Flat-Remix-Dark-fullPanel ~/.themes/.
mv flat-remix-gnome/Flat-Remix-Miami-fullPanel ~/.themes/.
mv flat-remix-gnome/Flat-Remix-Darkest-fullPanel ~/.themes/.
mv flat-remix-gnome/Flat-Remix-Miami-Darkest-fullPanel ~/.themes/.

gsettings set org.gnome.shell.extensions.user-theme name "Flat-Remix-Dark-fullPanel"

gsettings set org.gnome.desktop.screensaver lock-delay 5
gsettings set org.gnome.desktop.background picture-uri file:///home/alex/Pictures/flat-remix-smoke.jpg
gsettings set org.gnome.desktop.screensaver picture-uri file:///home/alex/Pictures/flat-remix-smoke.jpg

gsettings set org.gnome.desktop.interface true
gsettings set org.gnome.desktop.interface "Adwaita-dark"
gsettings set org.gnome.desktop.interface "DejaVu Sans 14"
gsettings set org.gnome.desktop.interface "DejaVu Sans Ultra-Light 12"
gsettings set org.gnome.desktop.interface.monospace-font-name "DejaVu Sans Mono 14"

git config --global user.name "Alex Elias"
git config --global user.email "alex.steven.elias@gmail.com"
