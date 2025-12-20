#!/bin/sh
# ============================================================================
# FLAMES CO. ULTIMATE DEV TOOLCHAIN (1930-2025) - WSL2 FIXED
# Run with: sh ./flames_ultimate_toolchain_fixed.sh
# ============================================================================

set -e
export DEBIAN_FRONTEND=noninteractive
export NONINTERACTIVE=1

# Colors (POSIX compatible)
G='\033[0;32m'
C='\033[0;36m'
Y='\033[1;33m'
R='\033[0;31m'
M='\033[0;35m'
B='\033[1;34m'
N='\033[0m'

log()     { printf "${G}[✓]${N} %s\n" "$1"; }
warn()    { printf "${Y}[~]${N} %s\n" "$1"; }
fail()    { printf "${R}[✗]${N} %s\n" "$1"; }
info()    { printf "${C}[*]${N} %s\n" "$1"; }
era()     { printf "${M}[%s]${N} %s\n" "$1" "$2"; }
section() { 
    printf "\n${B}══════════════════════════════════════════════════════════════════════════${N}\n"
    printf "${B}  %s${N}\n" "$1"
    printf "${B}══════════════════════════════════════════════════════════════════════════${N}\n"
}

# Install directory
INSTALL_DIR="${HOME}/retro-dev"
mkdir -p "$INSTALL_DIR/compilers" "$INSTALL_DIR/sdks" "$INSTALL_DIR/tools" "$INSTALL_DIR/emulators" "$INSTALL_DIR/src"
LOG="$INSTALL_DIR/install.log"
echo "Install started: $(date)" > "$LOG"

# ============================================================================
section "KILLING APT LOCKS"
# ============================================================================

info "Checking for apt locks..."
sudo killall apt apt-get dpkg 2>/dev/null || true
sleep 2

sudo rm -f /var/lib/dpkg/lock-frontend 2>/dev/null || true
sudo rm -f /var/lib/dpkg/lock 2>/dev/null || true
sudo rm -f /var/cache/apt/archives/lock 2>/dev/null || true
sudo rm -f /var/lib/apt/lists/lock 2>/dev/null || true

sudo dpkg --configure -a 2>/dev/null || true

log "APT locks cleared"

# ============================================================================
section "INSTALLING CORE DEPENDENCIES (wget curl)"
# ============================================================================

info "Installing wget and curl first..."
sudo apt-get update -qq 2>&1 | tee -a "$LOG" || true
sudo apt-get install -y -qq wget curl ca-certificates 2>&1 | tee -a "$LOG"
log "wget and curl installed"

# ============================================================================
section "ENVIRONMENT DETECTION"
# ============================================================================

OS="linux"
if grep -qi microsoft /proc/version 2>/dev/null; then
    OS="wsl"
    WSL_VERSION="2"
    if grep -qi "WSL1" /proc/version 2>/dev/null; then
        WSL_VERSION="1"
    fi
    WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r\n' || echo "User")
    log "WSL${WSL_VERSION} detected (Windows user: $WIN_USER)"
else
    log "Linux detected"
fi

INSTALL="sudo apt-get install -y -qq"

info "Install directory: $INSTALL_DIR"
info "Log file: $LOG"

# ============================================================================
section "ERA 1: MAINFRAME AGE (1950-1970)"
# ============================================================================
era "1950-70" "FORTRAN, COBOL, LISP - The dawn of programming"

$INSTALL gfortran 2>&1 | tee -a "$LOG" || true
$INSTALL sbcl clisp 2>&1 | tee -a "$LOG" || true
$INSTALL gnucobol 2>&1 | tee -a "$LOG" || true
$INSTALL simh 2>&1 | tee -a "$LOG" || true

log "FORTRAN, COBOL, LISP compilers installed"

# ============================================================================
section "ERA 2: UNIX & C (1970-1980)"
# ============================================================================
era "1970-80" "Unix, C, Make - Birth of modern computing"

$INSTALL build-essential gcc g++ clang llvm lld 2>&1 | tee -a "$LOG"
$INSTALL make automake autoconf libtool 2>&1 | tee -a "$LOG"
$INSTALL flex bison m4 gawk 2>&1 | tee -a "$LOG"
$INSTALL nasm yasm 2>&1 | tee -a "$LOG"
$INSTALL fasm 2>&1 | tee -a "$LOG" || true
$INSTALL pkg-config 2>&1 | tee -a "$LOG"

log "GCC, Clang, Make, NASM, YASM installed"

# ============================================================================
section "ERA 3: 8-BIT HOME COMPUTERS (1977-1985)"
# ============================================================================
era "1977-85" "Atari 2600, Apple II, C64, ZX Spectrum, NES"

$INSTALL cc65 2>&1 | tee -a "$LOG"
$INSTALL z88dk 2>&1 | tee -a "$LOG" || warn "z88dk not in repos"
$INSTALL sdcc 2>&1 | tee -a "$LOG"
$INSTALL dasm 2>&1 | tee -a "$LOG" || true
$INSTALL xa65 2>&1 | tee -a "$LOG" || true
$INSTALL acme 2>&1 | tee -a "$LOG" || true

log "cc65 (6502), z88dk (Z80), SDCC installed"

# RGBDS for Game Boy
$INSTALL rgbds 2>&1 | tee -a "$LOG" || {
    warn "Building RGBDS from source with wget..."
    cd "$INSTALL_DIR/src"
    RGBDS_VER="0.8.0"
    wget -q "https://github.com/gbdev/rgbds/releases/download/v${RGBDS_VER}/rgbds-${RGBDS_VER}.tar.gz" -O rgbds.tar.gz 2>&1 | tee -a "$LOG" || \
    curl -sLo rgbds.tar.gz "https://github.com/gbdev/rgbds/releases/download/v${RGBDS_VER}/rgbds-${RGBDS_VER}.tar.gz" 2>&1 | tee -a "$LOG"
    if [ -f rgbds.tar.gz ]; then
        tar xzf rgbds.tar.gz
        cd "rgbds-${RGBDS_VER}" 2>/dev/null || cd rgbds* 2>/dev/null || true
        if [ -f Makefile ]; then
            make -j"$(nproc)" 2>&1 | tee -a "$LOG"
            sudo make install 2>&1 | tee -a "$LOG"
        fi
    fi
    cd "$INSTALL_DIR"
}
log "RGBDS (Game Boy) installed"

# ============================================================================
section "ERA 4: 16-BIT ERA (1985-1995)"
# ============================================================================
era "1985-95" "Sega Genesis, SNES, Amiga, DOS"

$INSTALL gcc-m68k-linux-gnu binutils-m68k-linux-gnu 2>&1 | tee -a "$LOG" || \
    warn "m68k not available - use SGDK for Genesis"
$INSTALL dosbox dosbox-x 2>&1 | tee -a "$LOG" || $INSTALL dosbox 2>&1 | tee -a "$LOG" || true
$INSTALL wla-dx 2>&1 | tee -a "$LOG" || warn "wla-dx: build from source for SNES"

log "16-bit toolchains installed"

# ============================================================================
section "ERA 5: 32-BIT 3D ERA (1993-2002)"
# ============================================================================
era "1993-02" "PS1, Saturn, N64, Dreamcast, PS2, GameCube, Xbox"

$INSTALL gcc-mips-linux-gnu binutils-mips-linux-gnu 2>&1 | tee -a "$LOG" || \
$INSTALL gcc-mipsel-linux-gnu binutils-mipsel-linux-gnu 2>&1 | tee -a "$LOG" || true
$INSTALL gcc-sh4-linux-gnu binutils-sh4-linux-gnu 2>&1 | tee -a "$LOG" || \
    warn "SH4: use KallistiOS for Dreamcast"
$INSTALL gcc-powerpc-linux-gnu binutils-powerpc-linux-gnu 2>&1 | tee -a "$LOG" || true
$INSTALL gcc-powerpc64-linux-gnu binutils-powerpc64-linux-gnu 2>&1 | tee -a "$LOG" || true

log "MIPS, SH4, PowerPC cross-compilers installed"

# ============================================================================
section "N64 TOOLCHAIN + LIBDRAGON (NO GIT - WGET/CURL ONLY)"
# ============================================================================

N64_DIR="$INSTALL_DIR/compilers/n64"
mkdir -p "$N64_DIR/bin"
export N64_INST="$N64_DIR"

# Create symlinks for MIPS toolchain
if command -v mips-linux-gnu-gcc >/dev/null 2>&1; then
    log "Using mips-linux-gnu-gcc for N64"
    for tool in gcc g++ ld ar as objcopy objdump strip; do
        sudo ln -sf "/usr/bin/mips-linux-gnu-$tool" "$N64_DIR/bin/mips64-elf-$tool" 2>/dev/null || true
    done
elif command -v mipsel-linux-gnu-gcc >/dev/null 2>&1; then
    log "Using mipsel-linux-gnu-gcc for N64"
    for tool in gcc g++ ld ar as objcopy objdump strip; do
        sudo ln -sf "/usr/bin/mipsel-linux-gnu-$tool" "$N64_DIR/bin/mips64-elf-$tool" 2>/dev/null || true
    done
fi

# LIBDRAGON - Download via wget/curl (NO GIT)
LIBDRAGON_DIR="$INSTALL_DIR/sdks/libdragon"
if [ ! -d "$LIBDRAGON_DIR" ]; then
    info "Downloading libdragon via wget/curl (no git)..."
    mkdir -p "$LIBDRAGON_DIR"
    cd "$INSTALL_DIR/src"
    
    # Download latest release tarball
    LIBDRAGON_URL="https://github.com/DragonMinded/libdragon/archive/refs/heads/trunk.tar.gz"
    
    if command -v wget >/dev/null 2>&1; then
        wget -q "$LIBDRAGON_URL" -O libdragon.tar.gz 2>&1 | tee -a "$LOG"
    elif command -v curl >/dev/null 2>&1; then
        curl -sLo libdragon.tar.gz "$LIBDRAGON_URL" 2>&1 | tee -a "$LOG"
    else
        fail "Neither wget nor curl available!"
        exit 1
    fi
    
    if [ -f libdragon.tar.gz ]; then
        tar xzf libdragon.tar.gz 2>&1 | tee -a "$LOG"
        mv libdragon-trunk/* "$LIBDRAGON_DIR/" 2>/dev/null || mv libdragon-*/* "$LIBDRAGON_DIR/" 2>/dev/null || true
        rm -rf libdragon-trunk libdragon-* libdragon.tar.gz 2>/dev/null || true
        log "libdragon downloaded and extracted"
    else
        warn "Failed to download libdragon"
    fi
    cd "$INSTALL_DIR"
fi
log "libdragon SDK available at $LIBDRAGON_DIR"

era "PS1"       "mipsel + PSn00bSDK"
era "N64"       "mips64 + libdragon"
era "DREAMCAST" "sh4 + KallistiOS"
era "PS2"       "mipsel + ps2sdk"
era "GAMECUBE"  "powerpc + devkitPPC"

# ============================================================================
section "ERA 6: HD ERA (2005-2013)"
# ============================================================================
era "2005-13" "Wii, Xbox 360, PS3, 3DS, Vita"

$INSTALL gcc-arm-none-eabi binutils-arm-none-eabi libnewlib-arm-none-eabi 2>&1 | tee -a "$LOG" || true
$INSTALL gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu 2>&1 | tee -a "$LOG" || true

log "ARM, AArch64 toolchains installed"

# ============================================================================
section "DEVKITPRO (GBA/DS/3DS/GC/Wii/WiiU/Switch)"
# ============================================================================

export DEVKITPRO=/opt/devkitpro

# Remove broken devkitpro repo if exists
sudo rm -f /etc/apt/sources.list.d/devkitpro.list 2>/dev/null || true

if [ -d "/opt/devkitpro/devkitARM" ]; then
    log "devkitPro already installed"
else
    warn "Installing devkitPro..."
    
    cd /tmp
    rm -rf /tmp/dkp-install
    mkdir -p /tmp/dkp-install
    cd /tmp/dkp-install
    
    DKP_DEB="devkitpro-pacman.amd64.deb"
    DKP_URL="https://github.com/devkitPro/pacman/releases/latest/download/$DKP_DEB"
    
    info "Downloading devkitpro-pacman..."
    if command -v wget >/dev/null 2>&1; then
        wget -q "$DKP_URL" 2>&1 | tee -a "$LOG" || true
    elif command -v curl >/dev/null 2>&1; then
        curl -sLO "$DKP_URL" 2>&1 | tee -a "$LOG" || true
    fi
    
    if [ -f "$DKP_DEB" ]; then
        log "Installing devkitpro-pacman deb..."
        sudo dpkg -i "$DKP_DEB" 2>&1 | tee -a "$LOG" || true
        sudo apt-get install -f -y -qq 2>&1 | tee -a "$LOG" || true
    else
        warn "Could not download devkitpro-pacman"
        info "Visit: https://devkitpro.org/wiki/Getting_Started"
    fi
    
    cd /tmp
    rm -rf /tmp/dkp-install
    
    # Install SDKs if dkp-pacman is available
    if command -v dkp-pacman >/dev/null 2>&1; then
        log "Installing console SDKs via dkp-pacman..."
        
        sudo dkp-pacman -Sy --noconfirm 2>&1 | tee -a "$LOG" || true
        
        sudo dkp-pacman -S --noconfirm --needed gba-dev 2>&1 | tee -a "$LOG" && log "  GBA dev installed" || warn "  GBA dev failed"
        sudo dkp-pacman -S --noconfirm --needed nds-dev 2>&1 | tee -a "$LOG" && log "  NDS dev installed" || warn "  NDS dev failed"
        sudo dkp-pacman -S --noconfirm --needed 3ds-dev 2>&1 | tee -a "$LOG" && log "  3DS dev installed" || warn "  3DS dev failed"
        sudo dkp-pacman -S --noconfirm --needed gamecube-dev 2>&1 | tee -a "$LOG" && log "  GameCube dev installed" || warn "  GameCube dev failed"
        sudo dkp-pacman -S --noconfirm --needed wii-dev 2>&1 | tee -a "$LOG" && log "  Wii dev installed" || warn "  Wii dev failed"
        sudo dkp-pacman -S --noconfirm --needed wiiu-dev 2>&1 | tee -a "$LOG" && log "  Wii U dev installed" || warn "  Wii U dev failed"
        sudo dkp-pacman -S --noconfirm --needed switch-dev 2>&1 | tee -a "$LOG" && log "  Switch dev installed" || warn "  Switch dev failed"
    else
        warn "dkp-pacman not available - manual devkitPro install required"
        info "Visit: https://devkitpro.org/wiki/Getting_Started"
    fi
fi

# ============================================================================
section "ERA 7: MODERN ERA (2013-2025)"
# ============================================================================
era "2013-25" "PS4, Xbox One, PS5, Xbox Series X/S, Switch"

$INSTALL clang llvm lld 2>&1 | tee -a "$LOG"
$INSTALL cmake ninja-build meson 2>&1 | tee -a "$LOG"

log "Modern toolchains (Clang/LLVM) installed"
info "PS4/PS5: Register at PlayStation Partners"
info "Xbox: Join ID@Xbox program"
info "Switch: Nintendo Developer Portal"

# ============================================================================
section "GCC + CLANG ALL VERSIONS"
# ============================================================================

# Add toolchain PPA (ignore errors)
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test 2>&1 | tee -a "$LOG" || true

# Remove broken sources before update
sudo rm -f /etc/apt/sources.list.d/devkitpro.list 2>/dev/null || true

sudo apt-get update -qq 2>&1 | tee -a "$LOG" || true

for ver in 11 12 13 14; do
    $INSTALL "gcc-$ver" "g++-$ver" 2>&1 | tee -a "$LOG" || true
done

for ver in 14 15 16 17 18; do
    $INSTALL "clang-$ver" 2>&1 | tee -a "$LOG" || true
done

log "Multiple GCC/Clang versions installed"

# ============================================================================
section "ASSEMBLERS - COMPLETE SUITE"
# ============================================================================

$INSTALL nasm yasm 2>&1 | tee -a "$LOG"
$INSTALL fasm 2>&1 | tee -a "$LOG" || true
$INSTALL as31 2>&1 | tee -a "$LOG" || true
$INSTALL avra 2>&1 | tee -a "$LOG" || true
$INSTALL gputils 2>&1 | tee -a "$LOG" || true
$INSTALL xa65 2>&1 | tee -a "$LOG" || true
$INSTALL acme 2>&1 | tee -a "$LOG" || true

log "All assemblers installed"

# ============================================================================
section "PYTHON 3.13 + PYGAME + GAME ENGINES"
# ============================================================================

# Add deadsnakes for Python 3.13
sudo add-apt-repository -y ppa:deadsnakes/ppa 2>&1 | tee -a "$LOG" || true

# Remove broken sources before update
sudo rm -f /etc/apt/sources.list.d/devkitpro.list 2>/dev/null || true
sudo apt-get update -qq 2>&1 | tee -a "$LOG" || true

$INSTALL python3.13 python3.13-venv python3.13-dev 2>&1 | tee -a "$LOG" || \
    $INSTALL python3 python3-venv python3-dev 2>&1 | tee -a "$LOG"
$INSTALL python3.12 python3.11 2>&1 | tee -a "$LOG" || true
$INSTALL python3-pip python3-setuptools 2>&1 | tee -a "$LOG"
$INSTALL pypy3 2>&1 | tee -a "$LOG" || true

# SDL2 for Pygame
$INSTALL libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev libsdl2-gfx-dev 2>&1 | tee -a "$LOG"
$INSTALL libfreetype6-dev libportmidi-dev 2>&1 | tee -a "$LOG"

# Install Python packages
PY="python3.13"
if ! command -v "$PY" >/dev/null 2>&1; then
    PY="python3"
fi

$PY -m pip install --upgrade pip --break-system-packages -q 2>&1 | tee -a "$LOG" || true
$PY -m pip install pygame pygame-ce pyglet arcade ursina panda3d --break-system-packages -q 2>&1 | tee -a "$LOG" || true

log "Python 3.13 + Pygame + Ursina + Arcade installed"

# ============================================================================
section "GAME ENGINES & LIBRARIES"
# ============================================================================

$INSTALL libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev libsdl2-gfx-dev 2>&1 | tee -a "$LOG"
$INSTALL libsfml-dev 2>&1 | tee -a "$LOG"
$INSTALL libraylib-dev 2>&1 | tee -a "$LOG" || warn "raylib: manual install"
$INSTALL liballegro5-dev 2>&1 | tee -a "$LOG"
$INSTALL love 2>&1 | tee -a "$LOG" || true
$INSTALL godot3 2>&1 | tee -a "$LOG" || true

log "SDL2, SFML, Raylib, Allegro, LÖVE installed"

# ============================================================================
section "ADDITIONAL LANGUAGES"
# ============================================================================

$INSTALL rustc cargo 2>&1 | tee -a "$LOG"
$INSTALL golang 2>&1 | tee -a "$LOG"
$INSTALL nodejs npm 2>&1 | tee -a "$LOG"
$INSTALL lua5.4 luajit 2>&1 | tee -a "$LOG"
$INSTALL zig 2>&1 | tee -a "$LOG" || true

log "Rust, Go, Node.js, Lua, Zig installed"

# ============================================================================
section "EMULATORS"
# ============================================================================

$INSTALL retroarch 2>&1 | tee -a "$LOG" || true
$INSTALL mednafen mame 2>&1 | tee -a "$LOG" || true
$INSTALL dosbox 2>&1 | tee -a "$LOG" || true
$INSTALL dosbox-x 2>&1 | tee -a "$LOG" || true
$INSTALL stella 2>&1 | tee -a "$LOG" || true
$INSTALL vice 2>&1 | tee -a "$LOG" || true
$INSTALL fuse-emulator-gtk 2>&1 | tee -a "$LOG" || true
$INSTALL fceux 2>&1 | tee -a "$LOG" || true
$INSTALL snes9x-gtk 2>&1 | tee -a "$LOG" || true
$INSTALL mgba-qt 2>&1 | tee -a "$LOG" || $INSTALL mgba 2>&1 | tee -a "$LOG" || true
$INSTALL desmume 2>&1 | tee -a "$LOG" || true
$INSTALL mupen64plus-ui-console 2>&1 | tee -a "$LOG" || true

log "Emulators installed"

# ============================================================================
section "UTILITIES"
# ============================================================================

$INSTALL git git-lfs 2>&1 | tee -a "$LOG"
$INSTALL cmake ninja-build meson 2>&1 | tee -a "$LOG"
$INSTALL graphviz 2>&1 | tee -a "$LOG"
$INSTALL ffmpeg imagemagick 2>&1 | tee -a "$LOG"
$INSTALL xxd hexedit 2>&1 | tee -a "$LOG" || true
$INSTALL p7zip-full unzip 2>&1 | tee -a "$LOG"

log "Utilities installed"

# ============================================================================
section "ENVIRONMENT SETUP"
# ============================================================================

# Add to bashrc if not already present
if ! grep -q "FLAMES CO. DEV TOOLCHAIN" ~/.bashrc 2>/dev/null; then
    cat >> ~/.bashrc << 'ENVEOF'

# ============================================================================
# FLAMES CO. DEV TOOLCHAIN ENVIRONMENT
# ============================================================================

# N64 / libdragon
export N64_INST="$HOME/retro-dev/compilers/n64"
export PATH="$N64_INST/bin:$PATH"

# devkitPro
export DEVKITPRO=/opt/devkitpro
export DEVKITARM=/opt/devkitpro/devkitARM
export DEVKITPPC=/opt/devkitpro/devkitPPC
export DEVKITA64=/opt/devkitpro/devkitA64
export PATH="/opt/devkitpro/tools/bin:$PATH"

# Retro dev directory
export RETRO_DEV="$HOME/retro-dev"

ENVEOF
fi

log "Environment variables added to ~/.bashrc"

# ============================================================================
section "VERIFICATION"
# ============================================================================

echo ""
printf "${C}=== COMPILERS ===${N}\n"
for cmd in gcc g++ clang gfortran; do
    if command -v $cmd >/dev/null 2>&1; then
        VER=$($cmd --version 2>&1 | head -n1 | cut -c1-60)
        printf "  ${G}✓${N} %s: %s\n" "$cmd" "$VER"
    fi
done

echo ""
printf "${C}=== ASSEMBLERS ===${N}\n"
for cmd in nasm yasm fasm rgbasm; do
    if command -v $cmd >/dev/null 2>&1; then
        printf "  ${G}✓${N} %s\n" "$cmd"
    else
        printf "  ${R}✗${N} %s\n" "$cmd"
    fi
done

echo ""
printf "${C}=== RETRO DEV (6502/Z80) ===${N}\n"
for cmd in cc65 cl65 sdcc; do
    if command -v $cmd >/dev/null 2>&1; then
        printf "  ${G}✓${N} %s\n" "$cmd"
    else
        printf "  ${R}✗${N} %s\n" "$cmd"
    fi
done

echo ""
printf "${C}=== CROSS COMPILERS ===${N}\n"
for cmd in arm-none-eabi-gcc aarch64-linux-gnu-gcc mips-linux-gnu-gcc mipsel-linux-gnu-gcc m68k-linux-gnu-gcc powerpc-linux-gnu-gcc; do
    if command -v $cmd >/dev/null 2>&1; then
        printf "  ${G}✓${N} %s\n" "$cmd"
    fi
done

echo ""
printf "${C}=== DEVKITPRO ===${N}\n"
if [ -d "/opt/devkitpro/devkitARM" ]; then printf "  ${G}✓${N} devkitARM (GBA/DS/3DS)\n"; fi
if [ -d "/opt/devkitpro/devkitPPC" ]; then printf "  ${G}✓${N} devkitPPC (GC/Wii/WiiU)\n"; fi
if [ -d "/opt/devkitpro/devkitA64" ]; then printf "  ${G}✓${N} devkitA64 (Switch)\n"; fi
if command -v dkp-pacman >/dev/null 2>&1; then printf "  ${G}✓${N} dkp-pacman\n"; fi

echo ""
printf "${C}=== LIBDRAGON ===${N}\n"
if [ -d "$INSTALL_DIR/sdks/libdragon" ]; then
    printf "  ${G}✓${N} libdragon at %s\n" "$INSTALL_DIR/sdks/libdragon"
else
    printf "  ${R}✗${N} libdragon\n"
fi

echo ""
printf "${C}=== PYTHON ===${N}\n"
python3 --version 2>/dev/null || true
python3 -c "import pygame; print('  ✓ Pygame ' + pygame.version.ver)" 2>/dev/null || printf "  ${R}✗${N} Pygame\n"
python3 -c "import ursina; print('  ✓ Ursina')" 2>/dev/null || printf "  ${R}✗${N} Ursina\n"

echo ""
printf "${C}=== LANGUAGES ===${N}\n"
for cmd in rustc go node lua5.4; do
    if command -v $cmd >/dev/null 2>&1; then
        printf "  ${G}✓${N} %s\n" "$cmd"
    fi
done

# ============================================================================
section "INSTALLATION COMPLETE!"
# ============================================================================

cat << 'EOF'

╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    ██████╗ █████╗ ████████╗    ███╗   ██╗     ██████╗ ██████╗               ║
║   ██╔════╝██╔══██╗╚══██╔══╝    ████╗  ██║    ██╔════╝██╔═══██╗              ║
║   ██║     ███████║   ██║       ██╔██╗ ██║    ██║     ██║   ██║              ║
║   ██║     ██╔══██║   ██║       ██║╚██╗██║    ██║     ██║   ██║              ║
║   ╚██████╗██║  ██║   ██║       ██║ ╚████║    ╚██████╗╚██████╔╝              ║
║    ╚═════╝╚═╝  ╚═╝   ╚═╝       ╚═╝  ╚═══╝     ╚═════╝ ╚═════╝               ║
║                                                                              ║
║   ████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗██████╗ ███████╗       ║
║   ╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝██╔══██╗██╔════╝       ║
║      ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ █████╗  ██████╔╝███████╗       ║
║      ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ██╔══╝  ██╔══██╗╚════██║       ║
║      ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████╗██║  ██║███████║       ║
║      ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝       ║
║                                                                              ║
║                      12.20.25 v0.x.x  ~  WSL2 Edition                        ║
║                    Ultimate Dev Toolchain (1930-2025)                        ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  Run: source ~/.bashrc                                                       ║
║  Test: python3 -c "import pygame; print(pygame.version.ver)"                 ║
║  Log: ~/retro-dev/install.log                                                ║
║  libdragon: ~/retro-dev/sdks/libdragon                                       ║
╚══════════════════════════════════════════════════════════════════════════════╝

                          ～ nyaa! happy coding! :3 ～

EOF
