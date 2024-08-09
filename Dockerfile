FROM ghcr.io/linuxserver/baseimage-kasmvnc:arch

ARG BUILD_DATE
ARG VERSION
LABEL build_version="Docker-winesapos version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="guestsneezeosdev"

# title
ENV TITLE=winesapOS

RUN \
  echo "**** install vanilla 32 bit packages from multilib ****" && \
  echo '[multilib]' >> /etc/pacman.conf && \
  echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf && \
  pacman -Sy --noconfirm --needed \
    lib32-amdvlk \
    lib32-glibc \
    lib32-libva-intel-driver \
    lib32-libva-mesa-driver \
    lib32-libva-vdpau-driver \
    lib32-libvdpau \
    lib32-mangohud \
    lib32-mesa-utils \
    lib32-mesa-vdpau \
    lib32-vulkan-intel \
    lib32-vulkan-mesa-layers \
    lib32-vulkan-radeon \
    lib32-vulkan-swrast \
    libva-intel-driver \
    libva-utils \
    mesa-vdpau \
    vulkan-swrast && \
  echo "**** add winesapos repos ****" && \
  echo '[jupiter-staging]' >> /etc/pacman.conf && \
  echo 'Server = https://steamdeck-packages.steamos.cloud/archlinux-mirror/$repo/os/$arch' >> /etc/pacman.conf && \
  echo 'SigLevel = Never' >> /etc/pacman.conf && \
  echo '[holo-staging]' >> /etc/pacman.conf && \
  echo 'Server = https://steamdeck-packages.steamos.cloud/archlinux-mirror/$repo/os/$arch' >> /etc/pacman.conf && \
  echo 'SigLevel = Never' >> /etc/pacman.conf && \
  echo `[winesapos]` >> /etc/pacman.conf && \
  echo `Server = https://winesapos.lukeshort.cloud/repo/winesapos/$arch/` >> /etc/pacman.conf && \
  echo `SigLevel = Never` >> /etc/pacman.conf && \
  pacman -Syyu --noconfirm && \
  echo "**** install packages ****" && \
  pacman -Sy --noconfirm --needed \
    boost-libs \
    dmidecode \
    dolphin \
    firefox \
    fuse2 \
    gamescope \
    git \
    gperftools \
    jq \
    kate \
    konsole \
    lib32-gamescope \
    lib32-gcc-libs \
    lib32-libpulse \
    lib32-libunwind \
    lib32-mesa-vdpau \
    lib32-opencl-mesa \
    lib32-renderdoc-minimal \
    mangohud \
    noto-fonts-cjk \
    plasma-desktop \
    sddm-wayland \
    steamdeck-kde-presets \
    steam-jupiter-stable \
    steamos-customizations \
    unzip \
    xdg-user-dirs \
    xorg-xwayland \
    zenity \
    nano \
    vi \
    vim \
    clamtk \
    spice-vdagent && \
  echo "**** install sunshine ****" && \
  cd /tmp && \
  git clone https://aur.archlinux.org/sunshine.git && \
  chown -R abc:abc sunshine && \
  cd sunshine && \
  sed -i '/CXXFLAGS/i sudo chown -R 911:1001 \/config' PKGBUILD && \
  sudo -u abc makepkg -sAci --skipinteg --noconfirm --needed && \
  usermod -G input abc && \
  echo "**** install fix for games using source engine ****" && \
  cd /tmp && \
  git clone https://aur.archlinux.org/lib32-gperftools.git && \
  chown -R abc:abc lib32-gperftools && \
  cd lib32-gperftools && \
  sudo -u abc makepkg -sAci --skipinteg --noconfirm --needed && \
  usermod -G input abc && \
  echo "**** steam tweaks ****" && \
  sed -i 's/-steamdeck//g' /usr/bin/steam && \
  echo "**** kde tweaks ****" && \
  sed -i \
    -e 's/applications:org.kde.discover.desktop,/applications:org.kde.konsole.desktop,/g' \
    -e 's#preferred://browser#applications:firefox.desktop#g' \
    /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml && \
  echo "**** cleanup ****" && \
  rm -rf \
    /config/.cache \
    /config/.npm \
    /tmp/* \
    /var/cache/pacman/pkg/* \
    /var/lib/pacman/sync/* && \
  echo "*** install additional packages ... ***" && \
  pacman -S yay && \
  yay -S \
  waydroid \
  waydroid-biglinux \
  waydroid-image \
  waydroid-image-gapps \
  waydroid-image-halium \
  waydroid-magisk \
  waydroid-openrc \
  google-chrome \
  protonup-qt \
  heroic-games-launcher \
  heroic-games-launcher-bin \
  prismlauncher \
  # Uncomment this if you play cracked minecraft
  #prismlauncher-cracked \
  prismlauncher-bin \
  lutris-wine-meta && \
  
  pacman -S \
  flatpak \
  flatpak install \
  io.github.antimicrox.antimicrox \
  com.usebottles.bottles \
  com.calibre_ebook.calibre \
  org.gnome.Cheese \
  com.gitlab.davem.ClamTk \
  com.discordapp.Discord \
  org.filezillaproject.Filezilla \
  com.github.tchx84.Flatseal \
  org.freedesktop.Platform.VulkanLayer.gamescope \
  com.google.Chrome \
  com.heroicgameslauncher.hgl \
  org.keepassxc.KeePassXC \
  org.libreoffice.LibreOffice \
  net.lutris.Lutris \
  org.freedesktop.Platform.VulkanLayer.MangoHud \
  com.obsproject.Studio \
  io.github.peazip.PeaZip \
  org.prismlauncher.PrismLauncher \
  com.github.Matoking.protontricks \
  net.davidotek.pupgui2 \
  org.qbittorrent.qBittorrent \
  com.valvesoftware.Steam \
  com.valvesoftware.Steam.Utility.steamtinkerlaunch \
  org.videolan.VLC && \
  echo "***Install Additional packages ... Complete***" && \
  echo "***Installing Native winesapOS files**" && \
  file /etc/os-release-winesapos && \
  touch /etc/os-release-winesapos && \
  echo "NAME="winesapOS" " >> /etc/os-release-winesapos && \
  echo "PRETTY_NAME="winesapOS"" >> /etc/os-release-winesapos && \
  echo "ID=winesapos" >> /etc/os-release-winesapos && \
  echo "ID_LIKE=arch" >> /etc/os-release-winesapos && \
  echo "VERSION_ID=4.1.0-beta.3" >> /etc/os-release-winesapos && \
  echo "HOME_URL="https://github.com/LukeShortCloud/winesapOS" " >> /etc/os-release-winesapos && \
  echo "SUPPORT_URL="https://github.com/LukeShortCloud/winesapOS/issues"" >> /etc/os-release-winesapos && \
  echo "BUG_REPORT_URL="https://github.com/LukeShortCloud/winesapOS/issues"" >> /etc/os-release-winesapos && \
  echo "**Finished Task successfully**" \
  
# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
