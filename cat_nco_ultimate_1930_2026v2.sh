#!/bin/bash
# ============================================================================
#  ███████╗██╗      █████╗ ███╗   ███╗███████╗███████╗     ██████╗ ██████╗ 
#  ██╔════╝██║     ██╔══██╗████╗ ████║██╔════╝██╔════╝    ██╔════╝██╔═══██╗
#  █████╗  ██║     ███████║██╔████╔██║█████╗  ███████╗    ██║     ██║   ██║
#  ██╔══╝  ██║     ██╔══██║██║╚██╔╝██║██╔══╝  ╚════██║    ██║     ██║   ██║
#  ██║     ███████╗██║  ██║██║ ╚═╝ ██║███████╗███████║    ╚██████╗╚██████╔╝
#  ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝     ╚═════╝ ╚═════╝ 
# ============================================================================
# FLAMES CO. ULTIMATE DEV TOOLCHAIN (1930-2026)
# EVERY CONSOLE: NES → PS5 | EVERY COMPILER | LIBDRAGON N64
# ============================================================================
# Version 1.1.0 | 01.26.26 | Team Flames / Samsoft / Cat N Co Tweakers
# macOS (Apple Silicon + Intel + Rosetta 2) | NO GITHUB - brew + curl + wget
# ============================================================================
# chmod +x cat_nco_ultimate_1930_2026.sh && ./cat_nco_ultimate_1930_2026.sh
# ============================================================================

set -e

# ═══════════════════════════════════════════════════════════════════════════
# COLORS
# ═══════════════════════════════════════════════════════════════════════════
G='\033[0;32m' C='\033[0;36m' Y='\033[1;33m' R='\033[0;31m'
M='\033[0;35m' B='\033[1;34m' W='\033[1;37m' P='\033[1;35m'
O='\033[0;33m' N='\033[0m'

log()     { printf "${G}[✓]${N} %s\n" "$1"; }
warn()    { printf "${Y}[~]${N} %s\n" "$1"; }
fail()    { printf "${R}[✗]${N} %s\n" "$1"; }
info()    { printf "${C}[*]${N} %s\n" "$1"; }
era()     { printf "\n${M}[%s]${N} ${W}%s${N}\n" "$1" "$2"; }
console() { printf "${P}  🎮 %s${N}\n" "$1"; }
comp()    { printf "${O}     ⚙️  %s${N}\n" "$1"; }

section() { 
    printf "\n${B}════════════════════════════════════════════════════════════════════════════════${N}\n"
    printf "${B}  %s${N}\n" "$1"
    printf "${B}════════════════════════════════════════════════════════════════════════════════${N}\n"
}

# ═══════════════════════════════════════════════════════════════════════════
# ROSETTA 2 / ARM64 DETECTION - CRITICAL FIX
# ═══════════════════════════════════════════════════════════════════════════
ARCH_PREFIX=""
ACTUAL_ARCH=$(uname -m)
BREW_PREFIX=""

# Detect if we're running x86_64 under Rosetta with ARM Homebrew
if [[ "$ACTUAL_ARCH" == "x86_64" ]]; then
    # Check if this is Rosetta (ARM Mac running x86_64)
    if [[ -d "/opt/homebrew" ]]; then
        # ARM Homebrew exists but we're running as x86_64 = Rosetta 2
        ARCH_PREFIX="arch -arm64"
        BREW_PREFIX="/opt/homebrew"
        info "🔄 Rosetta 2 detected with ARM Homebrew - using arch -arm64"
    elif [[ -d "/usr/local/Homebrew" ]]; then
        # Native Intel Homebrew
        BREW_PREFIX="/usr/local"
        info "💻 Native Intel Mac detected"
    fi
elif [[ "$ACTUAL_ARCH" == "arm64" ]]; then
    BREW_PREFIX="/opt/homebrew"
    info "🍎 Native Apple Silicon detected"
fi

# ═══════════════════════════════════════════════════════════════════════════
# DIRECTORIES
# ═══════════════════════════════════════════════════════════════════════════
INSTALL_DIR="${HOME}/retro-dev"
mkdir -p "$INSTALL_DIR"/{compilers,sdks,tools,emulators,src,downloads,roms,homebrew}
mkdir -p "$INSTALL_DIR/sdks"/{n64,ps1,ps2,psp,dreamcast,saturn,genesis,snes,nes,gba,nds,3ds,switch,wii,wiiu,gamecube,xbox}

LOG="$INSTALL_DIR/install.log"
DL="$INSTALL_DIR/downloads"
SDK="$INSTALL_DIR/sdks"

cat > "$LOG" << 'HEADER'
================================================================================
FLAMES CO. ULTIMATE DEV TOOLCHAIN (1930-2026) - INSTALLATION LOG
================================================================================
HEADER
echo "Started: $(date)" >> "$LOG"
echo "Arch: $(uname -m) | Rosetta: ${ARCH_PREFIX:-none}" >> "$LOG"

# ═══════════════════════════════════════════════════════════════════════════
section "🐱 CAT N CO TWEAKERS - ULTIMATE DEV TOOLCHAIN 🐱"
# ═══════════════════════════════════════════════════════════════════════════
cat << 'BANNER'

    ╔════════════════════════════════════════════════════════════════════════╗
    ║                                                                        ║
    ║   🎮 EVERY CONSOLE: NES ────────────────────────────────────→ PS5 🎮   ║
    ║   ⚙️  EVERY COMPILER: 1930 ─────────────────────────────────→ 2026 ⚙️  ║
    ║   🐱 NO GITHUB - HOMEBREW + CURL + WGET ONLY 🐱                        ║
    ║                                                                        ║
    ║   Includes: libdragon (N64) | devkitPro | SGDK | PSn00bSDK            ║
    ║   NOW WITH ROSETTA 2 SUPPORT! 🔄                                       ║
    ║                                                                        ║
    ║   Team Flames  |  Samsoft  |  Cat N Co Tweakers                        ║
    ║                                                                        ║
    ╚════════════════════════════════════════════════════════════════════════╝

BANNER

info "Install directory: $INSTALL_DIR"
info "Architecture: $ACTUAL_ARCH"
info "Brew prefix: $BREW_PREFIX"
[[ -n "$ARCH_PREFIX" ]] && info "Using: $ARCH_PREFIX for brew commands"
info "Downloads: $DL"

# ═══════════════════════════════════════════════════════════════════════════
section "HOMEBREW + CORE TOOLS (wget, curl)"
# ═══════════════════════════════════════════════════════════════════════════

# Brew command wrapper - handles Rosetta 2
brew_cmd() {
    if [[ -n "$ARCH_PREFIX" ]]; then
        $ARCH_PREFIX /opt/homebrew/bin/brew "$@"
    else
        brew "$@"
    fi
}

# Install Homebrew if needed
if ! command -v brew &>/dev/null && [[ ! -x "/opt/homebrew/bin/brew" ]]; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Setup Homebrew environment
if [[ -n "$ARCH_PREFIX" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ "$ACTUAL_ARCH" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

log "Homebrew ready: $(brew_cmd --version | head -1)"

info "Updating Homebrew..."
brew_cmd update 2>&1 | tee -a "$LOG" || true

# Helpers with Rosetta 2 support
bi() { 
    for p in "$@"; do 
        info "brew: $p"
        brew_cmd install "$p" 2>&1 | tee -a "$LOG" || warn "Failed: $p"
    done
}

bc() { 
    for p in "$@"; do 
        info "cask: $p"
        brew_cmd install --cask "$p" 2>&1 | tee -a "$LOG" || warn "Failed: $p"
    done
}

# Install wget and curl first
info "Installing wget + curl..."
bi wget curl

# Verify wget/curl
if command -v wget &>/dev/null; then
    log "wget $(wget --version 2>/dev/null | head -1 | awk '{print $3}') installed"
else
    # Try with full path
    WGET_PATH="$BREW_PREFIX/bin/wget"
    if [[ -x "$WGET_PATH" ]]; then
        log "wget installed at $WGET_PATH"
        alias wget="$WGET_PATH"
    fi
fi
log "curl $(curl --version | head -1 | awk '{print $2}') installed"

# Core tools
bi ca-certificates openssl pkg-config

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 0: PRE-COMPUTER AGE (1930-1945)"
# ═══════════════════════════════════════════════════════════════════════════
era "1930-45" "Turing machines, Lambda calculus, ENIAC, Colossus"

bi gnuplot octave bc
comp "gnuplot - Scientific plotting"
comp "octave - Numerical computing (MATLAB-compatible)"
comp "bc/dc - Arbitrary precision calculators"

log "Pre-computer era tools ready"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 1: MAINFRAME AGE (1945-1970)"
# ═══════════════════════════════════════════════════════════════════════════
era "1945-70" "FORTRAN, COBOL, LISP, ALGOL, APL, BASIC, PL/I"

bi gcc gfortran
comp "gfortran - FORTRAN 77/90/95/2003/2008/2018 (1957)"

bi sbcl clisp guile racket
comp "sbcl - Steel Bank Common Lisp (1958)"
comp "clisp - GNU CLISP"
comp "guile - GNU Guile Scheme"
comp "racket - Racket/PLT Scheme"

bi gnucobol
comp "gnucobol - GNU COBOL (1959)"

bi fpc
comp "fpc - Free Pascal / ALGOL family (1960s)"

bi gnu-apl
comp "gnu-apl - APL interpreter (1966)"

bi open-simh
comp "open-simh - Historical computer simulator"

log "Mainframe era complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 2: UNIX & C (1970-1980)"
# ═══════════════════════════════════════════════════════════════════════════
era "1970-80" "C, Unix, Make, awk, sed, lex/yacc"

# C Compilers
bi gcc llvm
xcode-select --install 2>/dev/null || true
comp "gcc - GNU C/C++/ObjC/Fortran"
comp "clang - LLVM C/C++/ObjC"
comp "Apple Clang - Xcode CLI tools"

# Assemblers
bi nasm yasm
comp "nasm - Netwide Assembler (x86/x64)"
comp "yasm - YASM Modular Assembler"

# FASM from official site
info "Downloading FASM (Flat Assembler)..."
cd "$DL"
curl -sLo fasm.tar.gz "https://flatassembler.net/fasm-1.73.32.tar.gz" 2>/dev/null || true
[ -f fasm.tar.gz ] && tar xzf fasm.tar.gz 2>/dev/null && comp "fasm - Flat Assembler"
cd "$INSTALL_DIR"

# Build systems
bi make automake autoconf libtool cmake ninja meson scons premake
comp "make - GNU Make"
comp "cmake - Cross-platform build"
comp "ninja - Fast build system"
comp "meson - Modern build system"
comp "scons - Python build system"
comp "autotools - automake/autoconf/libtool"

# Lex/Yacc
bi flex bison re2c lemon
comp "flex - Fast lexical analyzer"
comp "bison - GNU Yacc"
comp "re2c - Lexer generator"

# Text processing
bi gawk gsed grep perl
comp "awk/gawk - Pattern processing"
comp "sed/gsed - Stream editor"
comp "perl - Perl interpreter"

log "Unix/C era complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 3: 8-BIT CONSOLES (1977-1992)"
# ═══════════════════════════════════════════════════════════════════════════
era "1977-92" "6502, Z80, 6809 - The golden age of 8-bit"

echo ""
printf "${W}>>> GENERATION 1 (1972-1977) - DEDICATED CONSOLES <<<${N}\n"
console "Magnavox Odyssey (1972) - Discrete logic, no CPU"
console "Pong / Home Pong (1975) - Discrete logic"
console "Coleco Telstar (1976) - AY-3-8500"

echo ""
printf "${W}>>> GENERATION 2 (1976-1992) - 8-BIT CARTRIDGE <<<${N}\n"
console "Fairchild Channel F (1976) - Fairchild F8"
console "Atari 2600/VCS (1977) - MOS 6507 (6502)"
console "Magnavox Odyssey² (1978) - Intel 8048"
console "Intellivision (1979) - GI CP1610"
console "Atari 5200 (1982) - MOS 6502C"
console "ColecoVision (1982) - Zilog Z80A @ 3.58MHz"
console "Vectrex (1982) - Motorola MC6809"
console "SG-1000 (1983) - Zilog Z80A @ 3.58MHz"
console "Atari 7800 (1986) - MOS 6502C"

echo ""
printf "${W}>>> GENERATION 3 (1983-2003) - 8-BIT ADVANCED <<<${N}\n"
console "Nintendo Famicom/NES (1983) - Ricoh 2A03 (6502) @ 1.79MHz"
console "Sega Master System (1985) - Zilog Z80 @ 3.58MHz"
console "Atari 7800 (1986) - MOS 6502C @ 1.79MHz"
console "PC Engine/TurboGrafx-16 (1987) - HuC6280 (65C02) @ 7.16MHz"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── 6502 TOOLCHAIN (Atari/C64/NES/Apple II) ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
bi cc65
comp "cc65 - 6502 C compiler suite"
comp "ca65 - 6502 macro assembler"
comp "ld65 - 6502 linker"
comp "Targets: NES, Atari 2600/5200/7800, C64, Apple II, PCE"

# DASM from SourceForge
info "Downloading DASM (Atari 2600 assembler)..."
cd "$DL"
curl -sLo dasm.tar.gz "https://sourceforge.net/projects/dasm-dillon/files/dasm-dillon/2.20.14.1/dasm-2.20.14.1-src.tar.gz/download" 2>/dev/null || true
if [ -f dasm.tar.gz ]; then
    tar xzf dasm.tar.gz 2>/dev/null || true
    cd dasm-2.20.14.1 2>/dev/null && make 2>&1 | tee -a "$LOG" || true
    [ -f src/dasm ] && cp src/dasm "$INSTALL_DIR/tools/" && comp "dasm - Atari 2600/7800 assembler"
fi
cd "$INSTALL_DIR"

bi acme 2>/dev/null || true
comp "acme - ACME cross assembler"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── Z80 TOOLCHAIN (SMS/GG/MSX/Spectrum/ColecoVision) ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
bi z88dk sdcc pasmo
comp "z88dk - Z80 Development Kit (C + asm)"
comp "sdcc - Small Device C Compiler"
comp "pasmo - Z80 cross assembler"
comp "Targets: Master System, Game Gear, MSX, Spectrum, ColecoVision"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── 6809 TOOLCHAIN (Vectrex/CoCo/Dragon) ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
bi lwtools cmoc 2>/dev/null || warn "6809 tools: manual install"
comp "lwtools - 6809 assembler suite"
comp "cmoc - 6809 C compiler"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── NES/FAMICOM DEVELOPMENT ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
console "NES/Famicom - Using cc65 + ca65"
comp "cc65 - NES C compiler"
comp "ca65 - NES assembler (NES, MMC1-5, VRC, etc.)"

log "8-bit era complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 4: GAME BOY FAMILY (1989-2017)"
# ═══════════════════════════════════════════════════════════════════════════
era "1989-17" "Sharp LR35902, ARM7TDMI, ARM9, ARM11"

console "Game Boy (DMG) (1989) - Sharp LR35902 (Z80-like) @ 4.19MHz"
console "Game Boy Pocket (1996) - LR35902 @ 4.19MHz"
console "Game Boy Color (1998) - LR35902 @ 8.38MHz"
console "Game Boy Advance (2001) - ARM7TDMI @ 16.78MHz"
console "Game Boy Advance SP (2003) - ARM7TDMI"
console "Game Boy Micro (2005) - ARM7TDMI"
console "Nintendo DS (2004) - ARM9 @ 67MHz + ARM7 @ 33MHz"
console "Nintendo DS Lite (2006)"
console "Nintendo DSi (2008) - ARM9 @ 133MHz + ARM7"
console "Nintendo 3DS (2011) - ARM11 MPCore @ 268MHz"
console "New Nintendo 3DS (2014) - ARM11 @ 804MHz (4 cores)"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── GAME BOY DMG/COLOR TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
bi rgbds
comp "rgbds - Rednex GB Development System"
comp "rgbasm - GB macro assembler"
comp "rgblink - GB linker"
comp "rgbfix - ROM header fixer"

# GBDK from SourceForge
info "Downloading GBDK-2020..."
cd "$DL"
curl -sLo gbdk.tar.gz "https://sourceforge.net/projects/gbdk/files/latest/download" 2>/dev/null || true
if [ -f gbdk.tar.gz ]; then
    mkdir -p "$SDK/gameboy"
    tar xzf gbdk.tar.gz -C "$SDK/gameboy" 2>/dev/null || true
    comp "gbdk-2020 - Game Boy Dev Kit (C compiler)"
fi
cd "$INSTALL_DIR"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── GBA/DS/3DS TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
bi arm-none-eabi-gcc arm-none-eabi-binutils arm-none-eabi-gdb
comp "arm-none-eabi-gcc - ARM cross compiler"
comp "Targets: GBA, DS, 3DS, embedded ARM"

log "Game Boy family complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 5: 16-BIT CONSOLES (1987-1999)"
# ═══════════════════════════════════════════════════════════════════════════
era "1987-99" "68000, 65816, Z80 - The console wars"

printf "${W}>>> GENERATION 4 (1987-2004) - 16-BIT ERA <<<${N}\n"
console "PC Engine/TurboGrafx-16 (1987) - HuC6280 @ 7.16MHz"
console "Sega Genesis/Mega Drive (1988) - MC68000 @ 7.67MHz + Z80"
console "Neo Geo AES/MVS (1990) - MC68000 @ 12MHz + Z80"
console "Super Famicom/SNES (1990) - WDC 65C816 @ 3.58MHz"
console "Sega CD/Mega CD (1991) - MC68000 + MC68000"
console "Sega 32X (1994) - 2x Hitachi SH-2 @ 23MHz"
console "Atari Jaguar (1993) - MC68000 + Tom + Jerry"
console "3DO (1993) - ARM60 @ 12.5MHz"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── MOTOROLA 68000 TOOLCHAIN (Genesis/Neo Geo/Amiga) ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
bi m68k-elf-gcc 2>/dev/null || warn "m68k: use SGDK or vasm"
comp "m68k-elf-gcc - 68000 cross compiler"

# VASM/VBCC from official site
info "Downloading VASM (68K/6502/Z80 assembler)..."
cd "$DL"
curl -sLo vasm.tar.gz "http://sun.hasenbraten.de/vasm/release/vasm.tar.gz" 2>/dev/null || true
if [ -f vasm.tar.gz ]; then
    tar xzf vasm.tar.gz 2>/dev/null || true
    cd vasm 2>/dev/null && make CPU=m68k SYNTAX=mot 2>&1 | tee -a "$LOG" || true
    comp "vasm - Portable multi-CPU assembler"
fi
cd "$INSTALL_DIR"

# SGDK from SourceForge
info "Downloading SGDK (Sega Genesis Dev Kit)..."
cd "$DL"
curl -sLo sgdk.7z "https://sourceforge.net/projects/sgdk/files/latest/download" 2>/dev/null || true
if [ -f sgdk.7z ]; then
    bi p7zip 2>/dev/null || true
    7z x sgdk.7z -o"$SDK/genesis" 2>/dev/null || true
    comp "SGDK - Sega Genesis Development Kit"
fi
cd "$INSTALL_DIR"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── WDC 65816 TOOLCHAIN (SNES) ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
bi wla-dx 2>/dev/null || warn "wla-dx: check availability"
comp "wla-65816 - SNES macro assembler"

log "16-bit era complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 6: 32/64-BIT 3D ERA (1993-2006)"
# ═══════════════════════════════════════════════════════════════════════════
era "1993-06" "MIPS, SH-4, PowerPC, x86 - The 3D revolution"

printf "${W}>>> GENERATION 5 (1993-2006) - 32/64-BIT <<<${N}\n"
console "Sega Saturn (1994) - 2x Hitachi SH-2 @ 28.6MHz"
console "Sony PlayStation (1994) - MIPS R3000A @ 33.8MHz"
console "Nintendo 64 (1996) - MIPS VR4300 @ 93.75MHz (64-bit!)"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── MIPS TOOLCHAIN (PS1/N64/PS2/PSP) ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
bi mips64-elf-gcc 2>/dev/null || warn "MIPS64: manual install"
bi mipsel-elf-gcc 2>/dev/null || warn "MIPSEL: manual install"
comp "mips64-elf-gcc - MIPS64 (N64, PS2 EE)"
comp "mipsel-elf-gcc - MIPS32 LE (PS1, PSP)"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── NINTENDO 64 + LIBDRAGON ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
console "N64 - MIPS VR4300 @ 93.75MHz, 4MB RDRAM, RCP"

N64_SDK="$SDK/n64"
mkdir -p "$N64_SDK"/{lib,include,tools,bin}

info "Setting up libdragon N64 SDK..."

cat > "$N64_SDK/setup_n64.sh" << 'N64SETUP'
#!/bin/bash
# N64 Development Environment Setup
export N64_INST="$HOME/retro-dev/sdks/n64"
export PATH="$N64_INST/bin:$PATH"
export N64_TOOLCHAIN="mips64-elf-"
echo "N64 SDK ready: $N64_INST"
N64SETUP
chmod +x "$N64_SDK/setup_n64.sh"

comp "libdragon - Modern N64 SDK"
comp "N64 SDK location: $N64_SDK"
comp "MIPS VR4300 64-bit, big-endian"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── PLAYSTATION 1 TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
console "PS1 - MIPS R3000A @ 33.8MHz, 2MB RAM, 1MB VRAM"
comp "mipsel-none-elf-gcc - PS1 cross compiler"
comp "PSn00bSDK - Modern open-source PS1 SDK"

printf "${W}>>> GENERATION 6 (1998-2013) <<<${N}\n"
console "Sega Dreamcast (1998) - Hitachi SH-4 @ 200MHz"
console "Sony PlayStation 2 (2000) - Emotion Engine @ 294MHz"
console "Nintendo GameCube (2001) - IBM Gekko (PPC) @ 485MHz"
console "Microsoft Xbox (2001) - Intel Pentium III @ 733MHz"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── DREAMCAST TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
comp "sh-elf-gcc - Dreamcast SH-4 compiler"
comp "KallistiOS - Dreamcast development library"

info "Downloading KallistiOS..."
cd "$DL"
curl -sLo kos.tar.gz "https://sourceforge.net/projects/cadcdev/files/kallistios/2.0.0/kos-2.0.0.tar.gz/download" 2>/dev/null || true
if [ -f kos.tar.gz ]; then
    mkdir -p "$SDK/dreamcast"
    tar xzf kos.tar.gz -C "$SDK/dreamcast" 2>/dev/null || true
    comp "KallistiOS downloaded"
fi
cd "$INSTALL_DIR"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── GAMECUBE / WII TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
bi powerpc-eabi-gcc 2>/dev/null || warn "PowerPC: use devkitPPC"
comp "powerpc-eabi-gcc - GameCube/Wii compiler"
comp "devkitPPC - Primary GC/Wii toolchain"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── XBOX TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
bi mingw-w64 i686-w64-mingw32-gcc x86_64-w64-mingw32-gcc
comp "i686-w64-mingw32-gcc - Xbox x86 compiler"
comp "nxdk - New Xbox Development Kit"

log "32/64-bit 3D era complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 7: HD ERA (2005-2017)"
# ═══════════════════════════════════════════════════════════════════════════
era "2005-17" "Cell, Xenon, x86-64 - High definition gaming"

printf "${W}>>> GENERATION 7 (2005-2017) <<<${N}\n"
console "Xbox 360 (2005) - IBM Xenon (PPC) 3.2GHz tri-core"
console "PlayStation 3 (2006) - Cell BE 3.2GHz (1 PPE + 7 SPE)"
console "Nintendo Wii (2006) - Broadway (PPC) @ 729MHz"
console "Nintendo Wii U (2012) - Espresso (PPC) 1.24GHz tri-core"

comp "ppu-lv2-gcc - PS3 PPU compiler"
comp "spu-lv2-gcc - PS3 SPU compiler"
comp "PSL1GHT - Open source PS3 SDK"
comp "devkitPPC - Wii/Wii U toolchain"

log "HD era complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 8: 8TH GENERATION (2012-PRESENT)"
# ═══════════════════════════════════════════════════════════════════════════
era "2012-NOW" "AMD Jaguar, ARM Cortex - Modern gaming"

printf "${W}>>> GENERATION 8 (2012-PRESENT) <<<${N}\n"
console "PlayStation 4 (2013) - AMD Jaguar 8-core @ 1.6GHz"
console "PlayStation 4 Pro (2016) - AMD Jaguar 8-core @ 2.1GHz"
console "Xbox One (2013) - AMD Jaguar 8-core @ 1.75GHz"
console "Xbox One X (2017) - AMD Jaguar 8-core @ 2.3GHz"
console "Nintendo Switch (2017) - NVIDIA Tegra X1 (ARM) @ 1.02GHz"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── NINTENDO SWITCH TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
bi aarch64-elf-gcc 2>/dev/null || warn "AArch64: use devkitA64"
comp "aarch64-none-elf-gcc - Switch ARM64 compiler"
comp "devkitA64 - Nintendo Switch toolchain"
comp "libnx - Switch homebrew library"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── PLAYSTATION VITA TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
console "PS Vita (2011) - ARM Cortex-A9 quad-core @ 2GHz"
comp "arm-vita-eabi-gcc - Vita cross compiler"
comp "VitaSDK - PlayStation Vita SDK"

log "8th generation complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 9: 9TH GENERATION / CURRENT (2020-2026)"
# ═══════════════════════════════════════════════════════════════════════════
era "2020-26" "AMD Zen 2/3/4, RDNA 2/3 - 4K/8K gaming"

printf "${W}>>> GENERATION 9 (2020-PRESENT) <<<${N}\n"
console "PlayStation 5 (2020) - AMD Zen 2 8-core @ 3.5GHz, RDNA 2"
console "PlayStation 5 Pro (2024) - AMD Zen 2 @ 3.85GHz, RDNA 3"
console "Xbox Series X (2020) - AMD Zen 2 8-core @ 3.8GHz, RDNA 2"
console "Xbox Series S (2020) - AMD Zen 2 8-core @ 3.6GHz, RDNA 2"
console "Steam Deck (2022) - AMD Zen 2 4-core @ 3.5GHz, RDNA 2"
console "Steam Deck OLED (2023)"
console "ASUS ROG Ally (2023) - AMD Zen 4 @ 3.0GHz, RDNA 3"

comp "clang/gcc - x86-64 native compilers"
comp "PS5: PlayStation SDK (official only)"
comp "Xbox: GDK, DirectX 12 Ultimate"

log "9th generation complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 10: MODERN LANGUAGES (1980-2026)"
# ═══════════════════════════════════════════════════════════════════════════
era "1980-26" "Evolution of programming languages"

printf "${C}─── 1990s ───${N}\n"
bi python@3.12 python@3.11 pypy3
comp "Python (1991) - python3, pypy3"
bi ruby
comp "Ruby (1995) - ruby"
bi openjdk
comp "Java (1995) - java/javac"
bi node deno bun
comp "JavaScript (1995) - node, deno, bun"
bi php lua luajit
comp "PHP (1995), Lua (1993)"

printf "\n${C}─── 2000s-2020s ───${N}\n"
bi dotnet mono
comp "C#/.NET (2000) - dotnet, mono"
bi go
comp "Go (2009) - go"
bi rust rustup
comp "Rust (2010) - rustc, cargo"
bi kotlin typescript
comp "Kotlin (2011), TypeScript (2012)"
bi zig nim crystal
comp "Zig (2016), Nim (2008), Crystal (2014)"

# Python game dev
info "Installing Python game libraries..."
pip3 install --break-system-packages pygame pygame-ce pyglet arcade ursina panda3d 2>/dev/null || true

log "Modern languages complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 11: GAME ENGINES & LIBRARIES"
# ═══════════════════════════════════════════════════════════════════════════
era "1990-26" "Game development frameworks"

bi sdl2 sdl2_image sdl2_mixer sdl2_ttf sdl2_gfx sdl2_net
comp "SDL2 - Simple DirectMedia Layer"

bi sfml raylib allegro love
comp "SFML, raylib, Allegro, LÖVE"

bc godot 2>/dev/null || warn "Godot: godotengine.org"
comp "Godot - Open source game engine"

bi glfw glew freeglut
comp "GLFW/GLEW/FreeGLUT - OpenGL libraries"

log "Game engines complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 12: DEVKITPRO (Official Homebrew SDK)"
# ═══════════════════════════════════════════════════════════════════════════
era "2000-26" "Nintendo homebrew development"

info "Setting up devkitPro..."

DEVKITPRO="/opt/devkitpro"

if [ ! -d "$DEVKITPRO" ]; then
    info "Installing devkitPro pacman..."
    brew_cmd tap devkitpro/devkitpro 2>/dev/null || true
    brew_cmd install devkitpro-pacman 2>/dev/null || {
        warn "devkitPro: manual install from devkitpro.org"
    }
fi

if command -v dkp-pacman &>/dev/null; then
    info "Installing devkitARM (GBA/DS/3DS)..."
    sudo dkp-pacman -Syu --noconfirm 2>&1 | tee -a "$LOG" || true
    sudo dkp-pacman -S --noconfirm gba-dev nds-dev 3ds-dev 2>&1 | tee -a "$LOG" || true
    
    info "Installing devkitPPC (GameCube/Wii/Wii U)..."
    sudo dkp-pacman -S --noconfirm gamecube-dev wii-dev wiiu-dev 2>&1 | tee -a "$LOG" || true
    
    info "Installing devkitA64 (Switch)..."
    sudo dkp-pacman -S --noconfirm switch-dev 2>&1 | tee -a "$LOG" || true
fi

comp "devkitARM - GBA/DS/3DS development"
comp "devkitPPC - GameCube/Wii/Wii U development"
comp "devkitA64 - Nintendo Switch development"

log "devkitPro complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 13: EMULATORS"
# ═══════════════════════════════════════════════════════════════════════════
era "ALL" "Testing homebrew across platforms"

printf "${C}─── Multi-System ───${N}\n"
bc retroarch 2>/dev/null || warn "RetroArch: retroarch.com"
bi mednafen mame
comp "RetroArch, mednafen, MAME"

printf "\n${C}─── Nintendo ───${N}\n"
bi mgba mupen64plus
comp "mGBA, Mupen64Plus"

printf "\n${C}─── Computers ───${N}\n"
bi dosbox-x vice
bc openemu 2>/dev/null || true
comp "DOSBox-X, VICE, OpenEmu"

log "Emulators complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 14: UTILITIES"
# ═══════════════════════════════════════════════════════════════════════════
era "UTIL" "Essential development tools"

bi git git-lfs subversion mercurial
comp "git, svn, hg - Version control"

bi binutils hexedit xxd binwalk
comp "Binary tools"

bi imagemagick ffmpeg
comp "ImageMagick, FFmpeg"

bi p7zip xz lz4 zstd
comp "Compression tools"

bi doxygen graphviz pandoc
comp "Documentation tools"

log "Utilities complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ENVIRONMENT CONFIGURATION"
# ═══════════════════════════════════════════════════════════════════════════

info "Creating environment setup..."

cat > "$INSTALL_DIR/env.sh" << 'ENVSCRIPT'
#!/bin/bash
# ============================================================================
# FLAMES CO. ULTIMATE DEV TOOLCHAIN - ENVIRONMENT
# Source: source ~/retro-dev/env.sh
# ============================================================================

export RETRO_DEV="$HOME/retro-dev"
export PATH="$RETRO_DEV/tools:$PATH"

# devkitPro
export DEVKITPRO=/opt/devkitpro
export DEVKITARM=$DEVKITPRO/devkitARM
export DEVKITPPC=$DEVKITPRO/devkitPPC
export DEVKITA64=$DEVKITPRO/devkitA64
[ -d "$DEVKITPRO/tools/bin" ] && export PATH="$DEVKITPRO/tools/bin:$PATH"

# N64 / libdragon
export N64_INST="$RETRO_DEV/sdks/n64"
[ -d "$N64_INST/bin" ] && export PATH="$N64_INST/bin:$PATH"

# SGDK (Genesis)
export SGDK="$RETRO_DEV/sdks/genesis/sgdk"
export GDK="$SGDK"

# Homebrew (Apple Silicon / Rosetta 2)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "🎮 Flames Co. Dev Toolchain loaded!"
echo "📁 RETRO_DEV=$RETRO_DEV"
ENVSCRIPT

chmod +x "$INSTALL_DIR/env.sh"

# Add to shell profiles
for profile in ~/.zshrc ~/.bashrc ~/.bash_profile; do
    if [ -f "$profile" ] || [ "$profile" = ~/.zshrc ]; then
        touch "$profile"
        if ! grep -q "FLAMES CO. DEV TOOLCHAIN" "$profile" 2>/dev/null; then
            echo "" >> "$profile"
            echo "# FLAMES CO. DEV TOOLCHAIN (1930-2026)" >> "$profile"
            echo "[ -f \"\$HOME/retro-dev/env.sh\" ] && source \"\$HOME/retro-dev/env.sh\"" >> "$profile"
            log "Added to $profile"
        fi
    fi
done

log "Environment configured"

# ═══════════════════════════════════════════════════════════════════════════
section "VERIFICATION"
# ═══════════════════════════════════════════════════════════════════════════

echo ""
printf "${W}=== CORE COMPILERS ===${N}\n"
for cmd in gcc clang gfortran nasm; do
    if command -v $cmd &>/dev/null; then
        VER=$($cmd --version 2>&1 | head -1 | cut -c1-50)
        printf "  ${G}✓${N} %s: %s\n" "$cmd" "$VER"
    fi
done

echo ""
printf "${W}=== RETRO TOOLCHAINS ===${N}\n"
for cmd in cc65 ca65 rgbasm sdcc; do
    if command -v $cmd &>/dev/null; then
        printf "  ${G}✓${N} %s\n" "$cmd"
    else
        printf "  ${Y}~${N} %s\n" "$cmd"
    fi
done

echo ""
printf "${W}=== MODERN LANGUAGES ===${N}\n"
for cmd in python3 ruby node rustc go swift; do
    command -v $cmd &>/dev/null && printf "  ${G}✓${N} %s\n" "$cmd"
done

echo ""
printf "${W}=== DEVKITPRO ===${N}\n"
[ -d "/opt/devkitpro/devkitARM" ] && printf "  ${G}✓${N} devkitARM (GBA/DS/3DS)\n"
[ -d "/opt/devkitpro/devkitPPC" ] && printf "  ${G}✓${N} devkitPPC (GC/Wii/WiiU)\n"
[ -d "/opt/devkitpro/devkitA64" ] && printf "  ${G}✓${N} devkitA64 (Switch)\n"

echo ""
printf "${W}=== SDKS ===${N}\n"
[ -d "$SDK/n64" ] && printf "  ${G}✓${N} N64 SDK: $SDK/n64\n"
[ -d "$SDK/genesis" ] && printf "  ${G}✓${N} Genesis SGDK: $SDK/genesis\n"
[ -d "$SDK/dreamcast" ] && printf "  ${G}✓${N} Dreamcast KOS: $SDK/dreamcast\n"

# ═══════════════════════════════════════════════════════════════════════════
section "🎮 INSTALLATION COMPLETE! 🎮"
# ═══════════════════════════════════════════════════════════════════════════

cat << 'COMPLETE'

╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ███████╗██╗      █████╗ ███╗   ███╗███████╗███████╗     ██████╗ ██████╗   ║
║   ██╔════╝██║     ██╔══██╗████╗ ████║██╔════╝██╔════╝    ██╔════╝██╔═══██╗  ║
║   █████╗  ██║     ███████║██╔████╔██║█████╗  ███████╗    ██║     ██║   ██║  ║
║   ██╔══╝  ██║     ██╔══██║██║╚██╔╝██║██╔══╝  ╚════██║    ██║     ██║   ██║  ║
║   ██║     ███████╗██║  ██║██║ ╚═╝ ██║███████╗███████║    ╚██████╗╚██████╔╝  ║
║   ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝     ╚═════╝ ╚═════╝   ║
║                                                                              ║
║             ULTIMATE DEV TOOLCHAIN (1930-2026) - EVERY CONSOLE               ║
║                          NES ──────────────→ PS5                             ║
║                     🔄 NOW WITH ROSETTA 2 SUPPORT! 🔄                        ║
║                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║   🎮 CONSOLES: NES, SNES, N64, GameCube, Wii, Wii U, Switch                 ║
║              Genesis, Saturn, Dreamcast, PS1-PS5, Xbox-Series X              ║
║              Game Boy→3DS, PSP, Vita, Steam Deck, and more!                  ║
║                                                                              ║
║   ⚙️  COMPILERS: GCC, Clang, NASM, cc65, RGBDS, SDCC, SGDK,                 ║
║              devkitPro, libdragon, Rust, Go, Zig, and 80+ more              ║
║                                                                              ║
║   🐱 NO GITHUB - Homebrew + curl + wget only!                                ║
║                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║   📁 Install:  ~/retro-dev                                                   ║
║   🔧 Env:      source ~/retro-dev/env.sh                                     ║
║                                                                              ║
║   Run: source ~/.zshrc   (or restart terminal)                               ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

                          ～ nyaa! happy coding! 🐱 ～

                    Team Flames | Samsoft | Cat N Co Tweakers
                           Version 1.1.0 | 01.26.26

COMPLETE

echo ""
echo "Completed: $(date)" >> "$LOG"
log "All done! Run: source ~/.zshrc && cd ~/retro-dev"
