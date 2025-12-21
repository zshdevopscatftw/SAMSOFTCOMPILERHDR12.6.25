#!/bin/bash
#===============================================================================
#  CAT'S TWEAKER ADDITIONS - v1.9
#  libdragon (wget/curl, no git), Atari-PS5 SDK, Python 3.13
#  by Flames / Team Flames 🐱
#===============================================================================

# ============================================================================
step "PYTHON 3.13"
# ============================================================================

if $IS_MAC; then
    if brew list python@3.13 &>/dev/null; then
        ok "Python 3.13 (via brew)"
    else
        info "Installing Python 3.13..."
        brew install python@3.13 >> "$LOG" 2>&1 && ok "Python 3.13" || fail "Python 3.13"
    fi
    add_path "export PATH=\"/opt/homebrew/opt/python@3.13/bin:\$PATH\""
else
    info "Installing Python 3.13..."
    sudo add-apt-repository -y ppa:deadsnakes/ppa >> "$LOG" 2>&1
    sudo apt-get update -qq >> "$LOG" 2>&1
    sudo apt-get install -y python3.13 python3.13-venv python3.13-dev >> "$LOG" 2>&1 && ok "Python 3.13" || fail "Python 3.13"
fi

# ============================================================================
step "LIBDRAGON N64 SDK (wget/curl - no git)"
# ============================================================================

cd "$HOME" || cd /tmp

# Download prebuilt MIPS64 toolchain first
mkdir -p "$COMPILERS/n64"
cd "$COMPILERS/n64"

if $IS_MAC; then
    TC_URL="https://github.com/DragonMinded/libdragon/releases/download/toolchain-continuous-prerelease/gcc-toolchain-mips64-macos.tar.gz"
else
    TC_URL="https://github.com/DragonMinded/libdragon/releases/download/toolchain-continuous-prerelease/gcc-toolchain-mips64-linux-x86_64.tar.gz"
fi

info "Downloading N64 toolchain (mips64-elf-gcc)..."
if dl "$TC_URL" tc.tar.gz; then
    tar xzf tc.tar.gz >> "$LOG" 2>&1
    rm -f tc.tar.gz
    ok "N64 toolchain (mips64-elf-gcc)"
else
    fail "N64 toolchain download"
fi

# Set N64_INST for libdragon build
export N64_INST="$COMPILERS/n64"
export PATH="$N64_INST/bin:$PATH"

# Download and build libdragon from source (wget, no git)
cd "$HOME" || cd /tmp
rm -rf libdragon-trunk libdragon.zip 2>/dev/null

info "Downloading libdragon source..."
if dl "https://github.com/DragonMinded/libdragon/archive/refs/heads/trunk.tar.gz" libdragon.tar.gz; then
    tar xzf libdragon.tar.gz >> "$LOG" 2>&1
    rm -f libdragon.tar.gz
    cd libdragon-trunk
    
    info "Building libdragon..."
    make clean >> "$LOG" 2>&1 || true
    if make -j$NCPU >> "$LOG" 2>&1; then
        ok "libdragon build"
        info "Installing libdragon..."
        make install INSTALLDIR="$N64_INST" >> "$LOG" 2>&1 && ok "libdragon install" || fail "libdragon install"
    else
        fail "libdragon build"
    fi
    
    # Build tools
    info "Building libdragon tools..."
    cd tools
    make -j$NCPU >> "$LOG" 2>&1 && ok "libdragon tools" || fail "libdragon tools"
    make install INSTALLDIR="$N64_INST" >> "$LOG" 2>&1 || true
    
    cd "$HOME" || cd /tmp
    rm -rf libdragon-trunk
else
    fail "libdragon download"
fi

add_path "export N64_INST=\"$COMPILERS/n64\"; export PATH=\"\$N64_INST/bin:\$PATH\""

# ============================================================================
step "ATARI SDK (2600/5200/7800/Lynx/Jaguar)"
# ============================================================================

mkdir -p "$SDKS/atari"
cd "$SDKS/atari"

# DASM (Atari 2600/VCS)
DASM_URL="https://github.com/dasm-assembler/dasm/releases/download/2.20.14.1/dasm-2.20.14.1-linux-x64.tar.gz"
$IS_MAC && DASM_URL="https://github.com/dasm-assembler/dasm/releases/download/2.20.14.1/dasm-2.20.14.1-osx-x64.tar.gz"
dl "$DASM_URL" dasm.tar.gz && tar xzf dasm.tar.gz >> "$LOG" 2>&1 && ok "DASM (Atari 2600)" || fail "DASM"
rm -f dasm.tar.gz

# CC65 (Atari 8-bit/Lynx)
if $IS_MAC; then
    brew install cc65 >> "$LOG" 2>&1 && ok "CC65 (Atari 8-bit/Lynx)" || fail "CC65"
else
    mkdir -p "$SDKS/atari/cc65"
    cd "$SDKS/atari/cc65"
    dl "https://github.com/cc65/cc65/archive/refs/tags/V2.19.tar.gz" cc65.tar.gz && \
    tar xzf cc65.tar.gz >> "$LOG" 2>&1 && cd cc65-2.19 && \
    make -j$NCPU >> "$LOG" 2>&1 && ok "CC65 (Atari 8-bit/Lynx)" || fail "CC65"
    rm -f "$SDKS/atari/cc65/cc65.tar.gz"
    add_path "export PATH=\"$SDKS/atari/cc65/cc65-2.19/bin:\$PATH\""
fi

# Atari Jaguar SDK (RMAC + RLN)
mkdir -p "$SDKS/atari/jaguar"
cd "$SDKS/atari/jaguar"

info "Downloading Jaguar SDK (RMAC/RLN)..."
dl "https://github.com/cubanismo/rmern/releases/download/v2.2.24/rmac-2.2.24-linux-amd64.tar.gz" rmac.tar.gz 2>/dev/null || \
dl "https://github.com/42Bastian/rmern/archive/refs/heads/master.tar.gz" rmac.tar.gz 2>/dev/null
if [[ -f rmac.tar.gz ]]; then
    tar xzf rmac.tar.gz >> "$LOG" 2>&1 && ok "Jaguar SDK (RMAC)" || fail "Jaguar SDK"
    rm -f rmac.tar.gz
else
    info "Jaguar SDK: build from source at github.com/42Bastian/rmern"
fi

add_path "export PATH=\"$SDKS/atari:\$SDKS/atari/jaguar:\$PATH\""

# ============================================================================
step "PLAYSTATION SDK (PS1/PS2/PSP/PS3/PS4/PS5)"
# ============================================================================

mkdir -p "$SDKS/playstation"
cd "$SDKS/playstation"

# PSn00bSDK (PS1)
info "Downloading PSn00bSDK (PS1)..."
if dl "https://github.com/Lameguy64/PSn00bSDK/archive/refs/heads/master.tar.gz" psn00b.tar.gz; then
    tar xzf psn00b.tar.gz >> "$LOG" 2>&1 && ok "PSn00bSDK (PS1)" || fail "PSn00bSDK"
    rm -f psn00b.tar.gz
else
    fail "PSn00bSDK"
fi

# PS2DEV
if [[ -d "/usr/local/ps2dev" ]]; then
    ok "PS2DEV (existing)"
else
    info "PS2DEV: install from github.com/ps2dev/ps2dev"
fi

# VITASDK (PSVita)
if command -v vita-mksfoex >/dev/null 2>&1; then
    ok "VitaSDK (existing)"
else
    info "VitaSDK: install from vitasdk.org"
fi

# PS4/PS5 homebrew (OpenOrbis)
info "Downloading OpenOrbis SDK (PS4/PS5)..."
mkdir -p "$SDKS/playstation/openorbis"
cd "$SDKS/playstation/openorbis"
if dl "https://github.com/OpenOrbis/OpenOrbis-PS4-Toolchain/archive/refs/heads/master.tar.gz" openorbis.tar.gz; then
    tar xzf openorbis.tar.gz >> "$LOG" 2>&1 && ok "OpenOrbis (PS4/PS5)" || fail "OpenOrbis"
    rm -f openorbis.tar.gz
    add_path "export OO_PS4_TOOLCHAIN=\"$SDKS/playstation/openorbis/OpenOrbis-PS4-Toolchain-master\""
else
    fail "OpenOrbis"
fi

# ============================================================================
step "ENVIRONMENT UPDATE"
# ============================================================================

cat >> "$INSTALL_DIR/env.sh" << 'ENVUPDATE'

# Python 3.13
export PATH="/opt/homebrew/opt/python@3.13/bin:$PATH"

# N64 libdragon (built from source)
export N64_INST="$RETRO_DEV/compilers/n64"
export PATH="$N64_INST/bin:$PATH"

# Atari SDKs
export PATH="$RETRO_DEV/sdks/atari:$PATH"

# PlayStation SDKs
export OO_PS4_TOOLCHAIN="$RETRO_DEV/sdks/playstation/openorbis/OpenOrbis-PS4-Toolchain-master"

echo "  N64:     mips64-elf-gcc --version"
echo "  Atari:   dasm (2600), cc65 (8-bit/Lynx)"
echo "  PS4/5:   OpenOrbis toolchain"
ENVUPDATE

ok "Environment updated"

echo ""
printf "${G}  ╔═══════════════════════════════════════════════════════════════╗${RST}\n"
printf "${G}  ║${RST}  ${W}✨ ADDITIONS INSTALLED! ✨${RST}                                   ${G}║${RST}\n"
printf "${G}  ╠═══════════════════════════════════════════════════════════════╣${RST}\n"
printf "${G}  ║${RST}  Python 3.13 • libdragon • Atari SDK • PS4/PS5 SDK            ${G}║${RST}\n"
printf "${G}  ╚═══════════════════════════════════════════════════════════════╝${RST}\n"
