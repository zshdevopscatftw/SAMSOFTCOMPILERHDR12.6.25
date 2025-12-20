#!/usr/bin/env bash
# ============================================================================
# FLAMES CO. ULTIMATE DEV TOOLCHAIN (1930-2025) - FIXED FOR WSL2
# Run with: bash ./flames_ultimate_toolchain.sh
# NOT: sh ./flames_ultimate_toolchain.sh
# ============================================================================

# Force bash
if [ -z "$BASH_VERSION" ]; then
    exec bash "$0" "$@"
fi

set -e
export DEBIAN_FRONTEND=noninteractive
export NONINTERACTIVE=1

# Colors using printf (more compatible)
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
mkdir -p "$INSTALL_DIR"/{compilers,sdks,tools,emulators,src}
LOG="$INSTALL_DIR/install.log"
echo "Install started: $(date)" > "$LOG"

# ============================================================================
section "KILLING APT LOCKS"
# ============================================================================

# Kill any existing apt/dpkg processes
info "Checking for apt locks..."
sudo killall apt apt-get dpkg 2>/dev/null || true
sleep 2

# Remove lock files if they exist
sudo rm -f /var/lib/dpkg/lock-frontend 2>/dev/null || true
sudo rm -f /var/lib/dpkg/lock 2>/dev/null || true
sudo rm -f /var/cache/apt/archives/lock 2>/dev/null || true
sudo rm -f /var/lib/apt/lists/lock 2>/dev/null || true

# Reconfigure dpkg in case it was interrupted
sudo dpkg --configure -a 2>/dev/null || true

log "APT locks cleared"

# ============================================================================
section "ENVIRONMENT DETECTION"
# ============================================================================

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    ARCH=$(uname -m)
    if [[ "$ARCH" == "arm64" ]]; then
        BREW_PREFIX="/opt/homebrew"
    else
        BREW_PREFIX="/usr/local"
    fi
    log "macOS detected ($ARCH)"
    
    if ! command -v brew &>/dev/null; then
        fail "Homebrew not installed!"
        exit 1
    fi
    
    INSTALL="brew install -q"
    CASK="brew install --cask -q"
    
elif grep -qi microsoft /proc/version 2>/dev/null; then
    OS="wsl"
    WSL_VERSION=$(grep -oP 'WSL\K[0-9]+' /proc/version 2>/dev/null || echo "2")
    WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r\n' || echo "User")
    log "WSL${WSL_VERSION} detected (Windows user: $WIN_USER)"
    
    sudo apt-get update -qq 2>&1 | tee -a "$LOG"
    INSTALL="sudo apt-get install -y -qq"
    
else
    OS="linux"
    log "Linux detected"
    sudo apt-get update -qq 2>&1 | tee -a "$LOG"
    INSTALL="sudo apt-get install -y -qq"
fi

info "Install directory: $INSTALL_DIR"
info "Log file: $LOG"

# ============================================================================
section "ERA 1: MAINFRAME AGE (1950-1970)"
# ============================================================================
era "1950-70" "FORTRAN, COBOL, LISP - The dawn of programming"

if [[ "$OS" == "macos" ]]; then
    $INSTALL gfortran 2>&1 | tee -a "$LOG"
    $INSTALL sbcl 2>&1 | tee -a "$LOG"
    $INSTALL gnu-cobol 2>&1 | tee -a "$LOG" || true
else
    $INSTALL gfortran 2>&1 | tee -a "$LOG" || true
    $INSTALL sbcl clisp 2>&1 | tee -a "$LOG" || true
    $INSTALL gnucobol 2>&1 | tee -a "$LOG" || true
    $INSTALL simh 2>&1 | tee -a "$LOG" || true
fi

log "FORTRAN, COBOL, LISP compilers installed"

# ============================================================================
section "ERA 2: UNIX & C (1970-1980)"
# ============================================================================
era "1970-80" "Unix, C, Make - Birth of modern computing"

if [[ "$OS" == "macos" ]]; then
    $INSTALL gcc llvm 2>&1 | tee -a "$LOG"
    $INSTALL make automake autoconf libtool 2>&1 | tee -a "$LOG"
    $INSTALL flex bison m4 2>&1 | tee -a "$LOG"
    $INSTALL nasm yasm 2>&1 | tee -a "$LOG"
    $INSTALL pkg-config 2>&1 | tee -a "$LOG"
else
    $INSTALL build-essential gcc g++ clang llvm lld 2>&1 | tee -a "$LOG"
    $INSTALL make automake autoconf libtool 2>&1 | tee -a "$LOG"
    $INSTALL flex bison m4 gawk 2>&1 | tee -a "$LOG"
    $INSTALL nasm yasm 2>&1 | tee -a "$LOG"
    $INSTALL fasm 2>&1 | tee -a "$LOG" || true
    $INSTALL pkg-config 2>&1 | tee -a "$LOG"
fi

log "GCC, Clang, Make, NASM, YASM installed"

# ============================================================================
section "ERA 3: 8-BIT HOME COMPUTERS (1977-1985)"
# ============================================================================
era "1977-85" "Atari 2600, Apple II, C64, ZX Spectrum, NES"

if [[ "$OS" == "macos" ]]; then
    $INSTALL cc65 2>&1 | tee -a "$LOG"
    $INSTALL z88dk 2>&1 | tee -a "$LOG"
    $INSTALL sdcc 2>&1 | tee -a "$LOG"
else
    $INSTALL cc65 2>&1 | tee -a "$LOG"
    $INSTALL z88dk 2>&1 | tee -a "$LOG" || warn "z88dk not in repos"
    $INSTALL sdcc 2>&1 | tee -a "$LOG"
    $INSTALL dasm 2>&1 | tee -a "$LOG" || true
    $INSTALL xa65 2>&1 | tee -a "$LOG" || true
    $INSTALL acme 2>&1 | tee -a "$LOG" || true
fi

log "cc65 (6502), z88dk (Z80), SDCC installed"
era "ATARI 2600" "cc65 + dasm"
era "NES"        "cc65 -t nes"
era "C64"        "cc65 -t c64"
era "APPLE II"   "cc65 -t apple2"
era "ZX SPECTRUM" "z88dk +zx"

# RGBDS for Game Boy
if [[ "$OS" == "macos" ]]; then
    $INSTALL rgbds 2>&1 | tee -a "$LOG"
else
    $INSTALL rgbds 2>&1 | tee -a "$LOG" || {
        warn "Building RGBDS from source..."
        cd "$INSTALL_DIR/src"
        git clone --depth 1 https://github.com/gbdev/rgbds.git 2>&1 | tee -a "$LOG" || true
        if [[ -d rgbds ]]; then
            cd rgbds
            make -j$(nproc) 2>&1 | tee -a "$LOG"
            sudo make install 2>&1 | tee -a "$LOG"
        fi
    }
fi
log "RGBDS (Game Boy) installed"

# ============================================================================
section "ERA 4: 16-BIT ERA (1985-1995)"
# ============================================================================
era "1985-95" "Sega Genesis, SNES, Amiga, DOS"

if [[ "$OS" == "macos" ]]; then
    brew tap messense/macos-cross-toolchains 2>/dev/null || true
    $INSTALL m68k-elf-gcc 2>&1 | tee -a "$LOG" || warn "m68k: use SGDK"
    $INSTALL dosbox-x 2>&1 | tee -a "$LOG"
else
    $INSTALL gcc-m68k-linux-gnu binutils-m68k-linux-gnu 2>&1 | tee -a "$LOG" || \
        warn "m68k not available - use SGDK for Genesis"
    $INSTALL dosbox dosbox-x 2>&1 | tee -a "$LOG" || $INSTALL dosbox 2>&1 | tee -a "$LOG" || true
    $INSTALL wla-dx 2>&1 | tee -a "$LOG" || warn "wla-dx: build from source for SNES"
fi

log "16-bit toolchains installed"
era "GENESIS" "m68k-elf-gcc or SGDK"
era "SNES"    "wla-65816 or PVSnesLib"
era "DOS"     "OpenWatcom/DJGPP in DOSBox"

# ============================================================================
section "ERA 5: 32-BIT 3D ERA (1993-2002)"
# ============================================================================
era "1993-02" "PS1, Saturn, N64, Dreamcast, PS2, GameCube, Xbox"

if [[ "$OS" == "macos" ]]; then
    $INSTALL mips64-elf-gcc 2>&1 | tee -a "$LOG" || warn "MIPS: build or use SDK"
    $INSTALL powerpc-elf-gcc 2>&1 | tee -a "$LOG" || warn "PPC: use devkitPPC"
else
    $INSTALL gcc-mips-linux-gnu binutils-mips-linux-gnu 2>&1 | tee -a "$LOG" || \
    $INSTALL gcc-mipsel-linux-gnu binutils-mipsel-linux-gnu 2>&1 | tee -a "$LOG" || true
    $INSTALL gcc-sh4-linux-gnu binutils-sh4-linux-gnu 2>&1 | tee -a "$LOG" || \
        warn "SH4: use KallistiOS for Dreamcast"
    $INSTALL gcc-powerpc-linux-gnu binutils-powerpc-linux-gnu 2>&1 | tee -a "$LOG" || true
    $INSTALL gcc-powerpc64-linux-gnu binutils-powerpc64-linux-gnu 2>&1 | tee -a "$LOG" || true
fi

log "MIPS, SH4, PowerPC cross-compilers installed"

# --- N64 / LIBDRAGON ---
section "N64 TOOLCHAIN + LIBDRAGON"

N64_DIR="$INSTALL_DIR/compilers/n64"
mkdir -p "$N64_DIR/bin"
export N64_INST="$N64_DIR"

if command -v mips-linux-gnu-gcc &>/dev/null; then
    log "Using mips-linux-gnu-gcc for N64"
    for tool in gcc g++ ld ar as objcopy objdump strip; do
        sudo ln -sf "/usr/bin/mips-linux-gnu-$tool" "$N64_DIR/bin/mips64-elf-$tool" 2>/dev/null || true
    done
elif command -v mipsel-linux-gnu-gcc &>/dev/null; then
    log "Using mipsel-linux-gnu-gcc for N64"
    for tool in gcc g++ ld ar as objcopy objdump strip; do
        sudo ln -sf "/usr/bin/mipsel-linux-gnu-$tool" "$N64_DIR/bin/mips64-elf-$tool" 2>/dev/null || true
    done
fi

LIBDRAGON_DIR="$INSTALL_DIR/sdks/libdragon"
if [[ ! -d "$LIBDRAGON_DIR" ]]; then
    info "Cloning libdragon..."
    git clone --depth 1 https://github.com/DragonMinded/libdragon.git "$LIBDRAGON_DIR" 2>&1 | tee -a "$LOG" || true
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

if [[ "$OS" != "macos" ]]; then
    $INSTALL gcc-arm-none-eabi binutils-arm-none-eabi libnewlib-arm-none-eabi 2>&1 | tee -a "$LOG" || true
    $INSTALL gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu 2>&1 | tee -a "$LOG" || true
else
    $INSTALL arm-none-eabi-gcc 2>&1 | tee -a "$LOG" || true
    $INSTALL aarch64-elf-gcc 2>&1 | tee -a "$LOG" || true
fi

log "ARM, AArch64 toolchains installed"

# ============================================================================
section "DEVKITPRO (GBA/DS/3DS/GC/Wii/WiiU/Switch)"
# ============================================================================

export DEVKITPRO=/opt/devkitpro

# Remove broken devkitpro repo if exists
sudo rm -f /etc/apt/sources.list.d/devkitpro.list 2>/dev/null || true

if [[ -d "/opt/devkitpro/devkitARM" ]]; then
    log "devkitPro already installed"
else
    if [[ "$OS" == "macos" ]]; then
        warn "Installing devkitPro via Homebrew..."
        brew tap devkitpro/devkitpro 2>&1 | tee -a "$LOG" || true
        brew install devkitpro-pacman 2>&1 | tee -a "$LOG" || true
    else
        warn "Installing devkitPro..."
        
        # Download and install deb directly (most reliable method)
        cd /tmp
        
        # Get the latest devkitpro-pacman deb
        info "Downloading devkitpro-pacman..."
        
        # Clean any previous attempts
        rm -rf /tmp/dkp-install
        mkdir -p /tmp/dkp-install
        cd /tmp/dkp-install
        
        # Try to download the deb package directly
        DKP_DEB="devkitpro-pacman.amd64.deb"
        
        # Method 1: Direct download from GitHub releases
        if command -v wget &>/dev/null; then
            wget -q "https://github.com/devkitPro/pacman/releases/latest/download/$DKP_DEB" 2>&1 | tee -a "$LOG" || true
        elif command -v curl &>/dev/null; then
            curl -sLO "https://github.com/devkitPro/pacman/releases/latest/download/$DKP_DEB" 2>&1 | tee -a "$LOG" || true
        fi
        
        if [[ -f "$DKP_DEB" ]]; then
            log "Installing devkitpro-pacman deb..."
            sudo dpkg -i "$DKP_DEB" 2>&1 | tee -a "$LOG" || true
            sudo apt-get install -f -y -qq 2>&1 | tee -a "$LOG" || true
        else
            warn "Could not download devkitpro-pacman, trying alternate method..."
            
            # Method 2: Build from source
            git clone --depth 1 https://github.com/devkitPro/pacman.git 2>&1 | tee -a "$LOG" || true
            if [[ -d "pacman" ]]; then
                cd pacman
                # Check for pre-built deb in repo
                if ls pkg/*.deb 1>/dev/null 2>&1; then
                    sudo dpkg -i pkg/*.deb 2>&1 | tee -a "$LOG" || true
                fi
            fi
        fi
        
        cd /tmp
        rm -rf /tmp/dkp-install
    fi
    
    # Install SDKs if dkp-pacman is available
    if command -v dkp-pacman &>/dev/null; then
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

if [[ "$OS" == "macos" ]]; then
    $INSTALL llvm 2>&1 | tee -a "$LOG"
    $INSTALL cmake ninja meson 2>&1 | tee -a "$LOG"
else
    $INSTALL clang llvm lld 2>&1 | tee -a "$LOG"
    $INSTALL cmake ninja-build meson 2>&1 | tee -a "$LOG"
fi

log "Modern toolchains (Clang/LLVM) installed"
info "PS4/PS5: Register at PlayStation Partners"
info "Xbox: Join ID@Xbox program"
info "Switch: Nintendo Developer Portal"

# ============================================================================
section "GCC + CLANG ALL VERSIONS"
# ============================================================================

if [[ "$OS" == "macos" ]]; then
    for ver in 11 12 13 14; do
        $INSTALL "gcc@$ver" 2>&1 | tee -a "$LOG" || true
    done
    for ver in 15 16 17 18; do
        $INSTALL "llvm@$ver" 2>&1 | tee -a "$LOG" || true
    done
else
    # Add toolchain PPA (ignore errors)
    sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test 2>&1 | tee -a "$LOG" || true
    
    # Remove broken devkitpro source before update
    sudo rm -f /etc/apt/sources.list.d/devkitpro.list 2>/dev/null || true
    
    sudo apt-get update -qq 2>&1 | tee -a "$LOG" || true
    
    for ver in 11 12 13 14; do
        $INSTALL "gcc-$ver" "g++-$ver" 2>&1 | tee -a "$LOG" || true
    done
    
    for ver in 14 15 16 17 18; do
        $INSTALL "clang-$ver" 2>&1 | tee -a "$LOG" || true
    done
fi

log "Multiple GCC/Clang versions installed"

# ============================================================================
section "ASSEMBLERS - COMPLETE SUITE"
# ============================================================================

if [[ "$OS" == "macos" ]]; then
    $INSTALL nasm yasm 2>&1 | tee -a "$LOG"
    $INSTALL rgbds 2>&1 | tee -a "$LOG"
else
    $INSTALL nasm yasm 2>&1 | tee -a "$LOG"
    $INSTALL fasm 2>&1 | tee -a "$LOG" || true
    $INSTALL as31 2>&1 | tee -a "$LOG" || true
    $INSTALL avra 2>&1 | tee -a "$LOG" || true
    $INSTALL gputils 2>&1 | tee -a "$LOG" || true
    $INSTALL xa65 2>&1 | tee -a "$LOG" || true
    $INSTALL acme 2>&1 | tee -a "$LOG" || true
fi

log "All assemblers installed"

# ============================================================================
section "PYTHON 3.13 + PYGAME + GAME ENGINES"
# ============================================================================

if [[ "$OS" == "macos" ]]; then
    $INSTALL python@3.13 python@3.12 python@3.11 2>&1 | tee -a "$LOG"
    $INSTALL pypy3 pipx 2>&1 | tee -a "$LOG"
    
    brew link --overwrite python@3.13 2>/dev/null || true
    
    PY="$BREW_PREFIX/bin/python3.13"
    $PY -m pip install --upgrade pip -q 2>&1 | tee -a "$LOG"
    $PY -m pip install pygame pygame-ce pyglet arcade ursina panda3d -q 2>&1 | tee -a "$LOG"
else
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
    command -v $PY &>/dev/null || PY="python3"
    
    $PY -m pip install --upgrade pip --break-system-packages -q 2>&1 | tee -a "$LOG" || true
    $PY -m pip install pygame pygame-ce pyglet arcade ursina panda3d --break-system-packages -q 2>&1 | tee -a "$LOG" || true
fi

log "Python 3.13 + Pygame + Ursina + Arcade installed"

# ============================================================================
section "GAME ENGINES & LIBRARIES"
# ============================================================================

if [[ "$OS" == "macos" ]]; then
    $INSTALL sdl2 sdl2_image sdl2_mixer sdl2_ttf sdl2_gfx 2>&1 | tee -a "$LOG"
    $INSTALL sfml raylib allegro 2>&1 | tee -a "$LOG"
    $INSTALL love 2>&1 | tee -a "$LOG"
    $CASK godot 2>&1 | tee -a "$LOG" || true
    $CASK unity-hub 2>&1 | tee -a "$LOG" || true
else
    $INSTALL libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev libsdl2-gfx-dev 2>&1 | tee -a "$LOG"
    $INSTALL libsfml-dev 2>&1 | tee -a "$LOG"
    $INSTALL libraylib-dev 2>&1 | tee -a "$LOG" || warn "raylib: manual install"
    $INSTALL liballegro5-dev 2>&1 | tee -a "$LOG"
    $INSTALL love 2>&1 | tee -a "$LOG" || true
    $INSTALL godot3 2>&1 | tee -a "$LOG" || true
fi

log "SDL2, SFML, Raylib, Allegro, LÖVE installed"

# ============================================================================
section "ADDITIONAL LANGUAGES"
# ============================================================================

if [[ "$OS" == "macos" ]]; then
    $INSTALL rust go node npm 2>&1 | tee -a "$LOG"
    $INSTALL lua luajit 2>&1 | tee -a "$LOG"
    $INSTALL zig 2>&1 | tee -a "$LOG" || true
else
    $INSTALL rustc cargo 2>&1 | tee -a "$LOG"
    $INSTALL golang 2>&1 | tee -a "$LOG"
    $INSTALL nodejs npm 2>&1 | tee -a "$LOG"
    $INSTALL lua5.4 luajit 2>&1 | tee -a "$LOG"
    $INSTALL zig 2>&1 | tee -a "$LOG" || true
fi

log "Rust, Go, Node.js, Lua, Zig installed"

# ============================================================================
section "EMULATORS"
# ============================================================================

if [[ "$OS" == "macos" ]]; then
    $INSTALL mednafen 2>&1 | tee -a "$LOG"
    $INSTALL dosbox-x 2>&1 | tee -a "$LOG"
    $CASK retroarch 2>&1 | tee -a "$LOG" || true
    $CASK openemu 2>&1 | tee -a "$LOG" || true
else
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
fi

log "Emulators installed"

# ============================================================================
section "UTILITIES"
# ============================================================================

if [[ "$OS" == "macos" ]]; then
    $INSTALL git git-lfs 2>&1 | tee -a "$LOG"
    $INSTALL cmake ninja meson 2>&1 | tee -a "$LOG"
    $INSTALL graphviz 2>&1 | tee -a "$LOG"
    $INSTALL ffmpeg imagemagick 2>&1 | tee -a "$LOG"
else
    $INSTALL git git-lfs 2>&1 | tee -a "$LOG"
    $INSTALL cmake ninja-build meson 2>&1 | tee -a "$LOG"
    $INSTALL graphviz 2>&1 | tee -a "$LOG"
    $INSTALL ffmpeg imagemagick 2>&1 | tee -a "$LOG"
    $INSTALL xxd hexedit 2>&1 | tee -a "$LOG" || true
    $INSTALL p7zip-full unzip wget curl 2>&1 | tee -a "$LOG"
fi

log "Utilities installed"

# ============================================================================
section "ENVIRONMENT SETUP"
# ============================================================================

# Backup existing bashrc additions
grep -q "FLAMES CO. DEV TOOLCHAIN" ~/.bashrc 2>/dev/null || cat >> ~/.bashrc << 'ENVEOF'

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

log "Environment variables added to ~/.bashrc"

# ============================================================================
section "VERIFICATION"
# ============================================================================

echo ""
printf "${C}=== COMPILERS ===${N}\n"
for cmd in gcc g++ clang gfortran; do
    if command -v $cmd &>/dev/null; then
        VER=$($cmd --version 2>&1 | head -n1 | cut -c1-60)
        printf "  ${G}✓${N} %s: %s\n" "$cmd" "$VER"
    fi
done

echo ""
printf "${C}=== ASSEMBLERS ===${N}\n"
for cmd in nasm yasm fasm rgbasm; do
    if command -v $cmd &>/dev/null; then
        printf "  ${G}✓${N} %s\n" "$cmd"
    else
        printf "  ${R}✗${N} %s\n" "$cmd"
    fi
done

echo ""
printf "${C}=== RETRO DEV (6502/Z80) ===${N}\n"
for cmd in cc65 cl65 sdcc; do
    if command -v $cmd &>/dev/null; then
        printf "  ${G}✓${N} %s\n" "$cmd"
    else
        printf "  ${R}✗${N} %s\n" "$cmd"
    fi
done

echo ""
printf "${C}=== CROSS COMPILERS ===${N}\n"
for cmd in arm-none-eabi-gcc aarch64-linux-gnu-gcc mips-linux-gnu-gcc mipsel-linux-gnu-gcc m68k-linux-gnu-gcc powerpc-linux-gnu-gcc; do
    if command -v $cmd &>/dev/null; then
        printf "  ${G}✓${N} %s\n" "$cmd"
    fi
done

echo ""
printf "${C}=== DEVKITPRO ===${N}\n"
[[ -d "/opt/devkitpro/devkitARM" ]] && printf "  ${G}✓${N} devkitARM (GBA/DS/3DS)\n"
[[ -d "/opt/devkitpro/devkitPPC" ]] && printf "  ${G}✓${N} devkitPPC (GC/Wii/WiiU)\n"
[[ -d "/opt/devkitpro/devkitA64" ]] && printf "  ${G}✓${N} devkitA64 (Switch)\n"
command -v dkp-pacman &>/dev/null && printf "  ${G}✓${N} dkp-pacman\n"

echo ""
printf "${C}=== PYTHON ===${N}\n"
python3 --version 2>/dev/null || true
python3 -c "import pygame; print(f'  ✓ Pygame {pygame.version.ver}')" 2>/dev/null || printf "  ${R}✗${N} Pygame\n"
python3 -c "import ursina; print('  ✓ Ursina')" 2>/dev/null || printf "  ${R}✗${N} Ursina\n"

echo ""
printf "${C}=== LANGUAGES ===${N}\n"
for cmd in rustc go node lua5.4; do
    if command -v $cmd &>/dev/null; then
        printf "  ${G}✓${N} %s\n" "$cmd"
    fi
done

# ============================================================================
section "INSTALLATION COMPLETE!"
# ============================================================================

cat << 'EOF'

╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ███████╗██╗      █████╗ ███╗   ███╗███████╗███████╗    ██████╗ ███████╗   ║
║   ██╔════╝██║     ██╔══██╗████╗ ████║██╔════╝██╔════╝    ██╔══██╗██╔════╝   ║
║   █████╗  ██║     ███████║██╔████╔██║█████╗  ███████╗    ██║  ██║█████╗     ║
║   ██╔══╝  ██║     ██╔══██║██║╚██╔╝██║██╔══╝  ╚════██║    ██║  ██║██╔══╝     ║
║   ██║     ███████╗██║  ██║██║ ╚═╝ ██║███████╗███████║    ██████╔╝███████╗   ║
║   ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝    ╚═════╝ ╚══════╝   ║
║                                                                              ║
║                    ULTIMATE DEV TOOLCHAIN (1930-2025)                        ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  Run: source ~/.bashrc                                                       ║
║  Test: python3 -c "import pygame; print(pygame.version.ver)"                 ║
║  Log: ~/retro-dev/install.log                                                ║
╚══════════════════════════════════════════════════════════════════════════════╝

                          ～ nyaa! happy coding! :3 ～

EOF
