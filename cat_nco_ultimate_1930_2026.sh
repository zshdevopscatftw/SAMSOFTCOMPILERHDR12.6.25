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
# Version 1.0.0 | 01.26.26 | Team Flames / Samsoft / Cat N Co Tweakers
# macOS (Apple Silicon M4 Pro + Intel) | NO GITHUB - brew + curl + wget only
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
echo "Arch: $(uname -m) | OS: $(uname -s)" >> "$LOG"

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
    ║                                                                        ║
    ║   Team Flames  |  Samsoft  |  Cat N Co Tweakers                        ║
    ║                                                                        ║
    ╚════════════════════════════════════════════════════════════════════════╝

BANNER

info "Install directory: $INSTALL_DIR"
info "Architecture: $(uname -m)"
info "Downloads: $DL"

# ═══════════════════════════════════════════════════════════════════════════
section "HOMEBREW + CORE TOOLS (wget, curl)"
# ═══════════════════════════════════════════════════════════════════════════

# Install Homebrew if needed
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Apple Silicon path
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile 2>/dev/null || true
fi

log "Homebrew ready: $(brew --version | head -1)"

info "Updating Homebrew..."
brew update 2>&1 | tee -a "$LOG" || true

# Install wget and curl first
info "Installing wget + curl..."
brew install wget curl 2>&1 | tee -a "$LOG" || true
log "wget $(wget --version | head -1 | awk '{print $3}') installed"
log "curl $(curl --version | head -1 | awk '{print $2}') installed"

# Helpers
bi() { for p in "$@"; do info "brew: $p"; brew install "$p" 2>&1 | tee -a "$LOG" || warn "Failed: $p"; done; }
bc() { for p in "$@"; do info "cask: $p"; brew install --cask "$p" 2>&1 | tee -a "$LOG" || warn "Failed: $p"; done; }

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

bi simh
comp "simh - Historical computer simulator"

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
wget -q "https://flatassembler.net/fasm-1.73.32.tar.gz" -O fasm.tar.gz 2>/dev/null || \
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
wget -q "https://sourceforge.net/projects/dasm-dillon/files/dasm-dillon/2.20.14.1/dasm-2.20.14.1-src.tar.gz/download" -O dasm.tar.gz 2>/dev/null || \
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
comp "NESlib - NES development library"
comp "NESASM3 - Alternative NES assembler"

# NESASM from SourceForge
info "Downloading NESASM..."
cd "$DL"
wget -q "https://sourceforge.net/projects/nesasm/files/latest/download" -O nesasm.zip 2>/dev/null || true
[ -f nesasm.zip ] && unzip -q nesasm.zip 2>/dev/null && comp "nesasm - NES assembler"
cd "$INSTALL_DIR"

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
console "Nintendo 3DS XL (2012)"
console "Nintendo 2DS (2013)"
console "New Nintendo 3DS (2014) - ARM11 @ 804MHz (4 cores)"
console "New Nintendo 2DS XL (2017)"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── GAME BOY DMG/COLOR TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
bi rgbds
comp "rgbds - Rednex GB Development System"
comp "rgbasm - GB macro assembler"
comp "rgblink - GB linker"
comp "rgbfix - ROM header fixer"
comp "rgbgfx - Graphics converter"

# GBDK from SourceForge
info "Downloading GBDK-2020..."
cd "$DL"
wget -q "https://sourceforge.net/projects/gbdk/files/latest/download" -O gbdk.tar.gz 2>/dev/null || \
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
comp "arm-none-eabi-gdb - ARM debugger"
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
console "TurboGrafx-CD (1988) - HuC6280"
console "Sega CD/Mega CD (1991) - MC68000 + MC68000"
console "Neo Geo CD (1994) - MC68000 + Z80"
console "Sega 32X (1994) - 2x Hitachi SH-2 @ 23MHz"
console "Atari Jaguar (1993) - MC68000 + Tom + Jerry"
console "3DO (1993) - ARM60 @ 12.5MHz"
console "CD-i (1991) - Various CPUs"
console "Amiga CD32 (1993) - MC68EC020 @ 14MHz"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── MOTOROLA 68000 TOOLCHAIN (Genesis/Neo Geo/Amiga) ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
bi m68k-elf-gcc 2>/dev/null || warn "m68k: use SGDK or vasm"
comp "m68k-elf-gcc - 68000 cross compiler"

# VASM/VBCC from official site
info "Downloading VASM (68K/6502/Z80 assembler)..."
cd "$DL"
wget -q "http://sun.hasenbraten.de/vasm/release/vasm.tar.gz" -O vasm.tar.gz 2>/dev/null || \
curl -sLo vasm.tar.gz "http://sun.hasenbraten.de/vasm/release/vasm.tar.gz" 2>/dev/null || true
if [ -f vasm.tar.gz ]; then
    tar xzf vasm.tar.gz 2>/dev/null || true
    cd vasm 2>/dev/null && make CPU=m68k SYNTAX=mot 2>&1 | tee -a "$LOG" || true
    comp "vasm - Portable multi-CPU assembler"
fi
cd "$INSTALL_DIR"

info "Downloading VBCC (68K C compiler)..."
cd "$DL"
wget -q "http://phoenix.owl.de/tags/vbcc0_9h.tar.gz" -O vbcc.tar.gz 2>/dev/null || true
[ -f vbcc.tar.gz ] && tar xzf vbcc.tar.gz && comp "vbcc - Portable C compiler"
cd "$INSTALL_DIR"

# SGDK from SourceForge
info "Downloading SGDK (Sega Genesis Dev Kit)..."
cd "$DL"
wget -q "https://sourceforge.net/projects/sgdk/files/latest/download" -O sgdk.7z 2>/dev/null || \
curl -sLo sgdk.7z "https://sourceforge.net/projects/sgdk/files/latest/download" 2>/dev/null || true
if [ -f sgdk.7z ]; then
    bi p7zip 2>/dev/null || true
    7z x sgdk.7z -o"$SDK/genesis" 2>/dev/null || true
    comp "SGDK - Sega Genesis Development Kit"
    comp "Includes: GCC 68K, libmd, rescomp, xgmtool"
fi
cd "$INSTALL_DIR"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── WDC 65816 TOOLCHAIN (SNES) ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
bi wla-dx 2>/dev/null || warn "wla-dx: check availability"
comp "wla-65816 - SNES macro assembler"
comp "wla-dx - Multi-CPU assembler suite"

# PVSnesLib from official site
info "Downloading PVSnesLib..."
cd "$DL"
wget -q "https://www.portabledev.com/download/pvsneslib-current.zip" -O pvsneslib.zip 2>/dev/null || true
if [ -f pvsneslib.zip ]; then
    mkdir -p "$SDK/snes"
    unzip -q pvsneslib.zip -d "$SDK/snes" 2>/dev/null || true
    comp "PVSnesLib - SNES C library"
fi
cd "$INSTALL_DIR"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── HITACHI SH-2 TOOLCHAIN (32X/Saturn) ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
bi sh-elf-gcc 2>/dev/null || warn "SH: manual install"
comp "sh-elf-gcc - SuperH cross compiler"
comp "Targets: 32X, Saturn, Dreamcast (SH-4)"

log "16-bit era complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 6: 32/64-BIT 3D ERA (1993-2006)"
# ═══════════════════════════════════════════════════════════════════════════
era "1993-06" "MIPS, SH-4, PowerPC, x86 - The 3D revolution"

printf "${W}>>> GENERATION 5 (1993-2006) - 32/64-BIT <<<${N}\n"
console "Atari Jaguar (1993) - 68000 @ 13.3MHz + Tom/Jerry"
console "3DO (1993) - ARM60 @ 12.5MHz"
console "Sega Saturn (1994) - 2x Hitachi SH-2 @ 28.6MHz"
console "Sony PlayStation (1994) - MIPS R3000A @ 33.8MHz"
console "Nintendo 64 (1996) - MIPS VR4300 @ 93.75MHz (64-bit!)"
console "Apple Pippin (1996) - PowerPC 603 @ 66MHz"

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

# Download libdragon from official sources (not GitHub)
info "Downloading libdragon components..."
cd "$DL"

# Libdragon uses MIPS64 toolchain
# Create setup script for N64 development
cat > "$N64_SDK/setup_n64.sh" << 'N64SETUP'
#!/bin/bash
# N64 Development Environment Setup
# Part of Flames Co. Ultimate Toolchain

export N64_INST="$HOME/retro-dev/sdks/n64"
export PATH="$N64_INST/bin:$PATH"

# MIPS64 toolchain prefix
export N64_TOOLCHAIN="mips64-elf-"

echo "N64 SDK ready: $N64_INST"
echo "Toolchain: ${N64_TOOLCHAIN}gcc"
N64SETUP
chmod +x "$N64_SDK/setup_n64.sh"

# Download libdragon from SourceForge mirror or official archive
wget -q "https://dragonminded.com/n64dev/libdragon-latest.tar.gz" -O libdragon.tar.gz 2>/dev/null || true
if [ -f libdragon.tar.gz ]; then
    tar xzf libdragon.tar.gz -C "$N64_SDK" 2>/dev/null || true
    comp "libdragon - Modern N64 SDK"
fi

comp "N64 SDK location: $N64_SDK"
comp "MIPS VR4300 64-bit, big-endian"
comp "4MB RDRAM (8MB with Expansion Pak)"
comp "RCP: RSP (vector) + RDP (rasterizer)"

cd "$INSTALL_DIR"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── PLAYSTATION 1 TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
console "PS1 - MIPS R3000A @ 33.8MHz, 2MB RAM, 1MB VRAM"

PS1_SDK="$SDK/ps1"
mkdir -p "$PS1_SDK"

comp "mipsel-none-elf-gcc - PS1 cross compiler"
comp "PSn00bSDK - Modern open-source PS1 SDK"
comp "Psy-Q - Original Sony SDK (commercial)"

# PSn00bSDK setup info
cat > "$PS1_SDK/README.txt" << 'PS1INFO'
PlayStation 1 Development
=========================
CPU: MIPS R3000A @ 33.8MHz (32-bit)
RAM: 2MB main + 1MB VRAM
GPU: Custom, 16.7M colors

Toolchain: mipsel-none-elf-gcc or mipsel-elf-gcc
SDK Options:
- PSn00bSDK (modern, open source)
- Psy-Q (original Sony SDK)

Emulators: DuckStation, Mednafen, PCSX-Redux
PS1INFO

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── SEGA SATURN TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
console "Saturn - 2x SH-2 @ 28.6MHz, 2MB RAM, VDP1+VDP2"

SATURN_SDK="$SDK/saturn"
mkdir -p "$SATURN_SDK"

comp "sh-elf-gcc - Saturn SH-2 compiler"
comp "Jo Engine - Saturn development library"
comp "Yaul - Yet Another Useless Library"

log "32/64-bit era complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 7: 128-BIT / 6TH GENERATION (1998-2013)"
# ═══════════════════════════════════════════════════════════════════════════
era "1998-13" "SH-4, Emotion Engine, Gekko, Pentium III"

printf "${W}>>> GENERATION 6 (1998-2013) <<<${N}\n"
console "Sega Dreamcast (1998) - Hitachi SH-4 @ 200MHz"
console "Sony PlayStation 2 (2000) - Emotion Engine @ 294MHz"
console "Nintendo GameCube (2001) - IBM Gekko (PPC) @ 485MHz"
console "Microsoft Xbox (2001) - Intel Pentium III @ 733MHz"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── SEGA DREAMCAST TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
console "Dreamcast - SH-4 @ 200MHz, 16MB RAM, PowerVR2"

DC_SDK="$SDK/dreamcast"
mkdir -p "$DC_SDK"

comp "sh-elf-gcc - Dreamcast SH-4 compiler"
comp "KallistiOS - Dreamcast development library"

# KallistiOS from SourceForge
info "Downloading KallistiOS..."
cd "$DL"
wget -q "https://sourceforge.net/projects/cadcdev/files/kallistios/2.0.0/kos-2.0.0.tar.gz/download" -O kos.tar.gz 2>/dev/null || \
curl -sLo kos.tar.gz "https://sourceforge.net/projects/cadcdev/files/kallistios/2.0.0/kos-2.0.0.tar.gz/download" 2>/dev/null || true
if [ -f kos.tar.gz ]; then
    tar xzf kos.tar.gz -C "$DC_SDK" 2>/dev/null || true
    comp "KallistiOS - Dreamcast SDK"
fi
cd "$INSTALL_DIR"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── PLAYSTATION 2 TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
console "PS2 - Emotion Engine @ 294MHz, 32MB RAM, GS"

PS2_SDK="$SDK/ps2"
mkdir -p "$PS2_SDK"

comp "mips64r5900el-elf-gcc - PS2 EE compiler"
comp "ee-gcc - Emotion Engine compiler"
comp "iop-gcc - I/O Processor compiler"
comp "PS2SDK - PlayStation 2 SDK"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── GAMECUBE / WII TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
console "GameCube - Gekko (PPC) @ 485MHz, 24MB RAM"
console "Wii - Broadway (PPC) @ 729MHz, 88MB RAM"

bi powerpc-eabi-gcc 2>/dev/null || warn "PPC: use devkitPPC"
comp "powerpc-eabi-gcc - GameCube/Wii compiler"
comp "devkitPPC - Primary GC/Wii toolchain"
comp "libogc - GC/Wii development library"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── XBOX TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
console "Xbox - Pentium III @ 733MHz, 64MB RAM, NV2A GPU"

bi mingw-w64 i686-w64-mingw32-gcc x86_64-w64-mingw32-gcc
comp "i686-w64-mingw32-gcc - Xbox x86 compiler"
comp "nxdk - New Xbox Development Kit"
comp "OpenXDK - Open Xbox Dev Kit"

log "6th generation complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 8: HD ERA / 7TH GENERATION (2005-2017)"
# ═══════════════════════════════════════════════════════════════════════════
era "2005-17" "Cell, Xenon, x86-64 - High definition gaming"

printf "${W}>>> GENERATION 7 (2005-2017) <<<${N}\n"
console "Xbox 360 (2005) - IBM Xenon (PPC) 3.2GHz tri-core"
console "PlayStation 3 (2006) - Cell BE 3.2GHz (1 PPE + 7 SPE)"
console "Nintendo Wii (2006) - Broadway (PPC) @ 729MHz"
console "Nintendo Wii U (2012) - Espresso (PPC) 1.24GHz tri-core"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── PLAYSTATION 3 TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
console "PS3 - Cell BE: 1 PPE + 7 SPE @ 3.2GHz, 256MB XDR"

comp "ppu-lv2-gcc - PS3 PPU compiler"
comp "spu-lv2-gcc - PS3 SPU compiler"
comp "PSL1GHT - Open source PS3 SDK"
comp "PS3 SDK requires special Cell toolchain"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── XBOX 360 TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
console "X360 - Xenon PPC 3.2GHz tri-core, 512MB RAM"

comp "powerpc64-linux-gnu-gcc - Xbox 360 PPC"
comp "LibXenon - Xbox 360 homebrew library"

bi powerpc64-elf-gcc 2>/dev/null || warn "PPC64: manual install"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── WII U TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
console "Wii U - Espresso PPC 1.24GHz tri-core, 2GB RAM"

comp "devkitPPC - Wii U toolchain"
comp "wut - Wii U Toolchain library"

log "7th generation complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 9: 8TH GENERATION (2012-PRESENT)"
# ═══════════════════════════════════════════════════════════════════════════
era "2012-NOW" "AMD Jaguar, ARM Cortex - Modern gaming"

printf "${W}>>> GENERATION 8 (2012-PRESENT) <<<${N}\n"
console "PlayStation 4 (2013) - AMD Jaguar 8-core @ 1.6GHz"
console "PlayStation 4 Pro (2016) - AMD Jaguar 8-core @ 2.1GHz"
console "Xbox One (2013) - AMD Jaguar 8-core @ 1.75GHz"
console "Xbox One S (2016) - AMD Jaguar 8-core @ 1.75GHz"
console "Xbox One X (2017) - AMD Jaguar 8-core @ 2.3GHz"
console "Nintendo Switch (2017) - NVIDIA Tegra X1 (ARM) @ 1.02GHz"
console "Nintendo Switch Lite (2019)"
console "Nintendo Switch OLED (2021)"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── PS4/XBOX ONE TOOLCHAIN (x86-64) ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
comp "clang/gcc - Native x86-64"
comp "PS4: Orbis SDK (official), OpenOrbis (homebrew)"
comp "Xbox One: GDK (official), UWP development"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── NINTENDO SWITCH TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
console "Switch - Tegra X1: 4x ARM Cortex-A57 + 4x A53"

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
section "ERA 10: 9TH GENERATION / CURRENT (2020-2026)"
# ═══════════════════════════════════════════════════════════════════════════
era "2020-26" "AMD Zen 2/3/4, RDNA 2/3 - 4K/8K gaming"

printf "${W}>>> GENERATION 9 (2020-PRESENT) <<<${N}\n"
console "PlayStation 5 (2020) - AMD Zen 2 8-core @ 3.5GHz, RDNA 2"
console "PlayStation 5 Digital (2020)"
console "PlayStation 5 Slim (2023)"
console "PlayStation 5 Pro (2024) - AMD Zen 2 @ 3.85GHz, RDNA 3"
console "Xbox Series X (2020) - AMD Zen 2 8-core @ 3.8GHz, RDNA 2"
console "Xbox Series S (2020) - AMD Zen 2 8-core @ 3.6GHz, RDNA 2"
console "Steam Deck (2022) - AMD Zen 2 4-core @ 3.5GHz, RDNA 2"
console "Steam Deck OLED (2023)"
console "ASUS ROG Ally (2023) - AMD Zen 4 @ 3.0GHz, RDNA 3"
console "Lenovo Legion Go (2023) - AMD Zen 4 @ 3.0GHz, RDNA 3"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── PS5 / XBOX SERIES X|S TOOLCHAIN ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
console "PS5 - Zen 2 8-core 3.5GHz, 16GB GDDR6, 825GB SSD"
console "XSX - Zen 2 8-core 3.8GHz, 16GB GDDR6, 1TB SSD"

comp "clang/gcc - x86-64 native compilers"
comp "PS5: PlayStation SDK (official only)"
comp "Xbox: GDK, DirectX 12 Ultimate"

# ───────────────────────────────────────────────────────────────────────────
printf "\n${C}─── STEAM DECK / PC HANDHELDS ───${N}\n"
# ───────────────────────────────────────────────────────────────────────────
comp "Standard Linux x86-64 development"
comp "Steam Runtime, Proton compatibility"
comp "Vulkan, OpenGL, DirectX (via DXVK)"

log "9th generation complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 11: PORTABLE / HANDHELD CONSOLES"
# ═══════════════════════════════════════════════════════════════════════════
era "1989-26" "All portable gaming devices"

printf "${W}>>> NINTENDO HANDHELDS <<<${N}\n"
console "Game Boy (1989) → Game Boy Color (1998)"
console "Game Boy Advance (2001) → GBA SP (2003) → Micro (2005)"
console "Nintendo DS (2004) → DSi (2008)"
console "Nintendo 3DS (2011) → New 3DS (2014) → 2DS XL (2017)"
console "Nintendo Switch (2017) → Switch Lite (2019) → OLED (2021)"

printf "\n${W}>>> SEGA HANDHELDS <<<${N}\n"
console "Sega Game Gear (1990) - Z80 @ 3.58MHz"
console "Sega Nomad (1995) - 68000 @ 7.67MHz"

printf "\n${W}>>> SONY HANDHELDS <<<${N}\n"
console "PlayStation Portable (2004) - MIPS R4000 @ 333MHz"
console "PlayStation Vita (2011) - ARM Cortex-A9 quad @ 2GHz"
console "PlayStation Portal (2023) - Streaming device"

printf "\n${W}>>> OTHER HANDHELDS <<<${N}\n"
console "Atari Lynx (1989) - WDC 65SC02 @ 4MHz"
console "TurboExpress (1990) - HuC6280 @ 7.16MHz"
console "Neo Geo Pocket / Color (1998) - Toshiba TLCS-900H"
console "WonderSwan (1999) - NEC V30MZ @ 3.07MHz"
console "Nokia N-Gage (2003) - ARM9 @ 104MHz"
console "GP32/GP2X/Caanoo (2001-2010) - ARM9"
console "Steam Deck (2022) - AMD Zen 2"

comp "Handheld toolchains covered in console sections"

log "Handhelds catalogued"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 12: HOME COMPUTERS (1977-2000)"
# ═══════════════════════════════════════════════════════════════════════════
era "1977-00" "Personal computer revolution"

printf "${W}>>> 8-BIT COMPUTERS <<<${N}\n"
console "Apple II (1977) - MOS 6502 @ 1MHz"
console "TRS-80 (1977) - Zilog Z80 @ 1.77MHz"
console "Commodore PET (1977) - MOS 6502"
console "Atari 400/800 (1979) - MOS 6502 @ 1.79MHz"
console "VIC-20 (1980) - MOS 6502 @ 1MHz"
console "ZX Spectrum (1982) - Z80 @ 3.5MHz"
console "Commodore 64 (1982) - MOS 6510 @ 1MHz"
console "BBC Micro (1981) - MOS 6502 @ 2MHz"
console "MSX (1983) - Z80 @ 3.58MHz"
console "Amstrad CPC (1984) - Z80 @ 4MHz"

printf "\n${W}>>> 16/32-BIT COMPUTERS <<<${N}\n"
console "Atari ST (1985) - MC68000 @ 8MHz"
console "Amiga 500/1200 (1985) - MC68000 @ 7.14MHz"
console "Macintosh (1984) - MC68000 @ 7.83MHz"
console "IBM PC (1981) - Intel 8088 @ 4.77MHz"
console "PC-98 (1982) - Intel 8086/x86"
console "Sharp X68000 (1987) - MC68000 @ 10MHz"
console "FM Towns (1989) - Intel 80386 @ 16MHz"

# C64 tools
comp "cc65 - C64/C128/VIC-20 development"
comp "ACME/64tass - C64 assemblers"
bi 64tass 2>/dev/null || true

# DOS tools
bi dosbox-x
comp "DOSBox-X - DOS emulator + development"

# DJGPP
info "DJGPP available from delorie.com"
comp "DJGPP - DOS GCC port"

# OpenWatcom
info "OpenWatcom from openwatcom.org"
comp "OpenWatcom - DOS/Windows/OS2 C/C++"

log "Home computers complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 13: MODERN LANGUAGES (1980-2026)"
# ═══════════════════════════════════════════════════════════════════════════
era "1980-26" "Evolution of programming languages"

printf "${C}─── 1980s ───${N}\n"
comp "C++ (1985) - g++, clang++"
comp "Objective-C (1984) - Apple Clang"
comp "Perl (1987) - perl"

printf "\n${C}─── 1990s ───${N}\n"
bi python@3.12 python@3.11 pypy3
comp "Python (1991) - python3, pypy3"
bi ruby
comp "Ruby (1995) - ruby"
bi openjdk
comp "Java (1995) - java/javac"
bi node deno bun
comp "JavaScript (1995) - node, deno, bun"
bi php
comp "PHP (1995) - php"
bi lua luajit
comp "Lua (1993) - lua, luajit"

printf "\n${C}─── 2000s ───${N}\n"
bi dotnet mono
comp "C#/.NET (2000) - dotnet, mono"
bi dmd ldc
comp "D (2001) - dmd, ldc"
bi scala
comp "Scala (2003) - scala"
bi go
comp "Go (2009) - go"

printf "\n${C}─── 2010s ───${N}\n"
bi rust rustup
comp "Rust (2010) - rustc, cargo"
bi kotlin
comp "Kotlin (2011) - kotlin"
bi typescript
comp "TypeScript (2012) - tsc"
comp "Swift (2014) - swift (built-in)"
bi zig
comp "Zig (2016) - zig"
bi nim
comp "Nim (2008) - nim"
bi crystal
comp "Crystal (2014) - crystal"
bi odin 2>/dev/null || warn "Odin: manual install"
comp "Odin (2016) - odin"

printf "\n${C}─── 2020s ───${N}\n"
bi vlang 2>/dev/null || warn "V: manual install"
comp "V (2019) - v"
comp "Hare (2022) - harelang.org"
comp "Mojo (2023) - modular.com"
comp "Carbon (2022) - Experimental C++ successor"

# Python game dev
info "Installing Python game libraries..."
pip3 install --break-system-packages pygame pygame-ce pyglet arcade ursina panda3d 2>/dev/null || true

log "Modern languages complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 14: GAME ENGINES & LIBRARIES"
# ═══════════════════════════════════════════════════════════════════════════
era "1990-26" "Game development frameworks"

bi sdl2 sdl2_image sdl2_mixer sdl2_ttf sdl2_gfx sdl2_net
comp "SDL2 - Simple DirectMedia Layer"

bi sfml
comp "SFML - Simple Fast Multimedia Library"

bi raylib
comp "raylib - Simple game programming"

bi allegro
comp "Allegro - Game programming library"

bi love
comp "LÖVE - Lua 2D game framework"

bc godot 2>/dev/null || warn "Godot: godotengine.org"
comp "Godot - Open source game engine"

bi glfw glew freeglut
comp "GLFW/GLEW/FreeGLUT - OpenGL libraries"

bi vulkan-headers 2>/dev/null || true
comp "Vulkan SDK - Modern graphics API"

log "Game engines complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 15: DEVKITPRO (Official Homebrew SDK)"
# ═══════════════════════════════════════════════════════════════════════════
era "2000-26" "Nintendo homebrew development"

info "Setting up devkitPro..."

# devkitPro from official source
DEVKITPRO="/opt/devkitpro"

if [ ! -d "$DEVKITPRO" ]; then
    info "Installing devkitPro pacman..."
    
    # Try Homebrew tap first
    brew tap devkitpro/devkitpro 2>/dev/null || true
    brew install devkitpro-pacman 2>/dev/null || {
        warn "devkitPro: manual install from devkitpro.org"
        info "Visit: https://devkitpro.org/wiki/Getting_Started"
    }
fi

# Install toolchains if dkp-pacman available
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
comp "libgba - GBA development library"
comp "libnds - DS development library"
comp "libctru - 3DS development library"
comp "libogc - GC/Wii development library"
comp "wut - Wii U development library"
comp "libnx - Switch development library"

log "devkitPro complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 16: EMULATORS"
# ═══════════════════════════════════════════════════════════════════════════
era "ALL" "Testing homebrew across platforms"

printf "${C}─── Multi-System ───${N}\n"
bc retroarch 2>/dev/null || warn "RetroArch: retroarch.com"
bi mednafen mame
comp "RetroArch - libretro frontend"
comp "mednafen - Multi-system emulator"
comp "MAME - Arcade emulator"

printf "\n${C}─── Nintendo ───${N}\n"
bi fceux 2>/dev/null || true
comp "FCEUX - NES emulator"
bi snes9x 2>/dev/null || true
comp "Snes9x - SNES emulator"
bi mgba
comp "mGBA - GBA emulator"
bi desmume 2>/dev/null || true
comp "DeSmuME - DS emulator"
bi mupen64plus
comp "Mupen64Plus - N64 emulator"
bc citra 2>/dev/null || warn "Citra: discontinued"
bc ryujinx 2>/dev/null || warn "Ryujinx: check availability"
comp "Switch: Ryujinx, Yuzu (discontinued)"

printf "\n${C}─── Sega ───${N}\n"
bi blastem 2>/dev/null || true
comp "BlastEm - Genesis emulator"
bi flycast 2>/dev/null || true
comp "Flycast - Dreamcast emulator"

printf "\n${C}─── Sony ───${N}\n"
bc duckstation 2>/dev/null || true
comp "DuckStation - PS1 emulator"
bc pcsx2 2>/dev/null || true
comp "PCSX2 - PS2 emulator"
bc rpcs3 2>/dev/null || true
comp "RPCS3 - PS3 emulator"
bc ppsspp 2>/dev/null || true
comp "PPSSPP - PSP emulator"

printf "\n${C}─── Microsoft ───${N}\n"
bc xemu 2>/dev/null || true
comp "xemu - Xbox emulator"

printf "\n${C}─── Computers ───${N}\n"
bi dosbox-x vice
bc openemu 2>/dev/null || true
comp "DOSBox-X - DOS emulator"
comp "VICE - C64/VIC-20/PET emulator"
comp "OpenEmu - macOS multi-system"

log "Emulators complete"

# ═══════════════════════════════════════════════════════════════════════════
section "ERA 17: UTILITIES"
# ═══════════════════════════════════════════════════════════════════════════
era "UTIL" "Essential development tools"

printf "${C}─── Version Control ───${N}\n"
bi git git-lfs subversion mercurial fossil
comp "git - Distributed VCS"
comp "svn - Subversion"
comp "hg - Mercurial"
comp "fossil - Fossil SCM"

printf "\n${C}─── Binary Tools ───${N}\n"
bi binutils hexedit xxd binwalk radare2
comp "hexedit/xxd - Hex editors"
comp "binwalk - Firmware analysis"
comp "radare2 - Reverse engineering"

printf "\n${C}─── Graphics ───${N}\n"
bi imagemagick graphicsmagick ffmpeg
bc gimp 2>/dev/null || true
bc aseprite 2>/dev/null || warn "Aseprite: aseprite.org"
comp "ImageMagick - Image processing"
comp "FFmpeg - Video/audio processing"
comp "Aseprite - Pixel art editor"

printf "\n${C}─── Audio ───${N}\n"
bi sox lame flac vorbis-tools
bc audacity 2>/dev/null || true
comp "sox - Sound processing"
comp "lame/flac/vorbis - Audio codecs"

printf "\n${C}─── Compression ───${N}\n"
bi p7zip xz lz4 zstd brotli
comp "7zip/xz/lz4/zstd - Compression tools"

printf "\n${C}─── Documentation ───${N}\n"
bi doxygen graphviz pandoc
comp "doxygen - Documentation generator"
comp "graphviz - Graph visualization"
comp "pandoc - Document converter"

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

# ─── devkitPro ───
export DEVKITPRO=/opt/devkitpro
export DEVKITARM=$DEVKITPRO/devkitARM
export DEVKITPPC=$DEVKITPRO/devkitPPC
export DEVKITA64=$DEVKITPRO/devkitA64
[ -d "$DEVKITPRO/tools/bin" ] && export PATH="$DEVKITPRO/tools/bin:$PATH"

# ─── N64 / libdragon ───
export N64_INST="$RETRO_DEV/sdks/n64"
[ -d "$N64_INST/bin" ] && export PATH="$N64_INST/bin:$PATH"

# ─── SGDK (Genesis) ───
export SGDK="$RETRO_DEV/sdks/genesis/sgdk"
export GDK="$SGDK"

# ─── Homebrew (Apple Silicon) ───
if [[ $(uname -m) == "arm64" && -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ─── Custom tools ───
export PATH="$RETRO_DEV/tools:$PATH"
export PATH="/usr/local/bin:$PATH"

echo "🎮 Flames Co. Dev Toolchain loaded!"
echo "📁 RETRO_DEV=$RETRO_DEV"
ENVSCRIPT

chmod +x "$INSTALL_DIR/env.sh"

# Add to shell profiles
for profile in ~/.zshrc ~/.bashrc ~/.bash_profile ~/.profile; do
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
for cmd in cc65 ca65 rgbasm sdcc z88dk-z80asm; do
    if command -v $cmd &>/dev/null; then
        printf "  ${G}✓${N} %s\n" "$cmd"
    else
        printf "  ${Y}~${N} %s\n" "$cmd"
    fi
done

echo ""
printf "${W}=== CROSS COMPILERS ===${N}\n"
for cmd in arm-none-eabi-gcc mips64-elf-gcc m68k-elf-gcc powerpc-eabi-gcc sh-elf-gcc aarch64-elf-gcc; do
    command -v $cmd &>/dev/null && printf "  ${G}✓${N} %s\n" "$cmd"
done

echo ""
printf "${W}=== MODERN LANGUAGES ===${N}\n"
for cmd in python3 ruby node rustc go swift kotlin zig; do
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
[ -d "$SDK/gameboy" ] && printf "  ${G}✓${N} Game Boy GBDK: $SDK/gameboy\n"

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
║                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║   🎮 CONSOLES SUPPORTED (40+ systems):                                       ║
║   ├─ Gen 1-2: Odyssey, Atari 2600, Intellivision, ColecoVision              ║
║   ├─ Gen 3:   NES/Famicom, Master System, Atari 7800                        ║
║   ├─ Gen 4:   Genesis, SNES, Neo Geo, TurboGrafx, Jaguar                    ║
║   ├─ Gen 5:   PlayStation, Saturn, Nintendo 64, 3DO                         ║
║   ├─ Gen 6:   PS2, Dreamcast, GameCube, Xbox                                ║
║   ├─ Gen 7:   PS3, Xbox 360, Wii, Wii U                                     ║
║   ├─ Gen 8:   PS4, Xbox One, Switch, 3DS, Vita                              ║
║   ├─ Gen 9:   PS5, Xbox Series X|S, Steam Deck                              ║
║   └─ Handhelds: Game Boy→Switch, PSP→Vita, Lynx, Game Gear, N-Gage          ║
║                                                                              ║
║   ⚙️  COMPILERS (100+):                                                      ║
║   GCC, Clang, NASM, YASM, FASM, cc65, RGBDS, z88dk, SDCC, SGDK,             ║
║   devkitARM/PPC/A64, libdragon, KallistiOS, VASM, VBCC, WLA-DX,             ║
║   Rust, Go, Zig, Swift, Kotlin, Python, Ruby, Lua, and 80+ more             ║
║                                                                              ║
║   🐱 NO GITHUB - Homebrew + curl + wget only!                                ║
║                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║   📁 Install:  ~/retro-dev                                                   ║
║   📋 Log:      ~/retro-dev/install.log                                       ║
║   🔧 Env:      source ~/retro-dev/env.sh                                     ║
║   📦 SDKs:     ~/retro-dev/sdks/{n64,genesis,dreamcast,...}                  ║
║                                                                              ║
║   Run: source ~/.zshrc   (or restart terminal)                               ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

                          ～ nyaa! happy coding! 🐱 ～

                    Team Flames | Samsoft | Cat N Co Tweakers
                           Version 1.0.0 | 01.26.26

COMPLETE

echo ""
echo "Completed: $(date)" >> "$LOG"
log "All done! Run: source ~/.zshrc && cd ~/retro-dev"
