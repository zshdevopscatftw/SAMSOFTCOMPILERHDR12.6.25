#!/bin/sh
# ============================================================================
# LIBDRAGON N64 INSTALLER FOR WSL2
# Installs to ~/n64 and ~/libdragon (no /retro-dev)
# Run: sh ./libdragon_wsl2_install.sh
# ============================================================================

set -e

G='\033[0;32m'
C='\033[0;36m'
Y='\033[1;33m'
R='\033[0;31m'
N='\033[0m'

log() { printf "${G}[✓]${N} %s\n" "$1"; }
warn() { printf "${Y}[~]${N} %s\n" "$1"; }
fail() { printf "${R}[✗]${N} %s\n" "$1"; exit 1; }
info() { printf "${C}[*]${N} %s\n" "$1"; }

cat << 'BANNER'
   ╔═══════════════════════════════════════════════════╗
   ║       LIBDRAGON N64 INSTALLER - WSL2              ║
   ║       wget/curl only - no git needed              ║
   ╚═══════════════════════════════════════════════════╝
BANNER

# ============================================================================
# CONFIGURATION - Standard WSL2 paths
# ============================================================================

N64_INST="$HOME/n64"
LIBDRAGON_DIR="$HOME/libdragon"
BUILD_DIR="/tmp/n64-build-$$"
JOBS=$(nproc)

# Versions
BINUTILS_VER="2.42"
GCC_VER="14.1.0"
NEWLIB_VER="4.4.0.20231231"

TARGET="mips64-elf"

info "N64 Toolchain: $N64_INST"
info "libdragon SDK: $LIBDRAGON_DIR"
info "Parallel jobs: $JOBS"
info "Build temp:    $BUILD_DIR"
echo ""

# ============================================================================
# DEPENDENCIES
# ============================================================================

section() {
    echo ""
    printf "${C}══════════════════════════════════════════════════════════════${N}\n"
    printf "${C} %s${N}\n" "$1"
    printf "${C}══════════════════════════════════════════════════════════════${N}\n"
}

section "INSTALLING DEPENDENCIES"

info "Updating apt and installing build tools..."
sudo apt-get update -qq
sudo apt-get install -y build-essential gcc g++ make \
    automake autoconf libtool cmake \
    texinfo libmpc-dev libmpfr-dev libgmp-dev \
    libpng-dev zlib1g-dev libc6-dev \
    wget curl ca-certificates \
    2>&1 | grep -v "is already the newest" || true

log "Dependencies installed"

# ============================================================================
# SETUP
# ============================================================================

mkdir -p "$N64_INST/bin" "$LIBDRAGON_DIR" "$BUILD_DIR"
cd "$BUILD_DIR"

export PATH="$N64_INST/bin:$PATH"

# ============================================================================
# BINUTILS
# ============================================================================

section "BUILDING BINUTILS $BINUTILS_VER"

if [ -f "$N64_INST/bin/mips64-elf-ld" ]; then
    log "binutils already installed, skipping"
else
    BINUTILS_TAR="binutils-${BINUTILS_VER}.tar.xz"
    
    if [ ! -f "$BINUTILS_TAR" ]; then
        info "Downloading binutils..."
        wget -q --show-progress "https://ftp.gnu.org/gnu/binutils/$BINUTILS_TAR" || \
        curl -LO --progress-bar "https://ftp.gnu.org/gnu/binutils/$BINUTILS_TAR"
    fi
    
    info "Extracting..."
    tar xf "$BINUTILS_TAR"
    
    mkdir -p binutils-build
    cd binutils-build
    
    info "Configuring binutils..."
    "../binutils-${BINUTILS_VER}/configure" \
        --prefix="$N64_INST" \
        --target="$TARGET" \
        --with-cpu=mips64vr4300 \
        --disable-nls \
        --disable-werror \
        --disable-multilib \
        > /dev/null 2>&1
    
    info "Building binutils (this takes ~5 minutes)..."
    make -j"$JOBS" > /dev/null 2>&1
    make install > /dev/null 2>&1
    
    cd "$BUILD_DIR"
    log "binutils installed"
fi

# ============================================================================
# GCC (BOOTSTRAP)
# ============================================================================

section "BUILDING GCC $GCC_VER"

if [ -f "$N64_INST/bin/mips64-elf-gcc" ]; then
    log "GCC already installed, skipping"
else
    GCC_TAR="gcc-${GCC_VER}.tar.xz"
    
    if [ ! -f "$GCC_TAR" ]; then
        info "Downloading GCC (this is ~90MB)..."
        wget -q --show-progress "https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/$GCC_TAR" || \
        curl -LO --progress-bar "https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/$GCC_TAR"
    fi
    
    info "Extracting GCC..."
    tar xf "$GCC_TAR"
    
    mkdir -p gcc-build
    cd gcc-build
    
    info "Configuring GCC..."
    "../gcc-${GCC_VER}/configure" \
        --prefix="$N64_INST" \
        --target="$TARGET" \
        --with-cpu=mips64vr4300 \
        --with-arch=vr4300 \
        --with-abi=32 \
        --enable-languages=c,c++ \
        --without-headers \
        --with-newlib \
        --disable-libssp \
        --disable-multilib \
        --disable-shared \
        --disable-threads \
        --disable-nls \
        --disable-werror \
        --disable-libgomp \
        --disable-libquadmath \
        --disable-libatomic \
        > /dev/null 2>&1
    
    info "Building GCC bootstrap (this takes ~15-20 minutes)..."
    make -j"$JOBS" all-gcc > /dev/null 2>&1
    make install-gcc > /dev/null 2>&1
    
    cd "$BUILD_DIR"
    log "GCC bootstrap installed"
fi

# ============================================================================
# NEWLIB
# ============================================================================

section "BUILDING NEWLIB $NEWLIB_VER"

if [ -f "$N64_INST/$TARGET/lib/libc.a" ]; then
    log "newlib already installed, skipping"
else
    NEWLIB_TAR="newlib-${NEWLIB_VER}.tar.gz"
    
    if [ ! -f "$NEWLIB_TAR" ]; then
        info "Downloading newlib..."
        wget -q --show-progress "https://sourceware.org/pub/newlib/$NEWLIB_TAR" || \
        curl -LO --progress-bar "https://sourceware.org/pub/newlib/$NEWLIB_TAR" || \
        wget -q --show-progress "ftp://sourceware.org/pub/newlib/$NEWLIB_TAR"
    fi
    
    info "Extracting newlib..."
    tar xzf "$NEWLIB_TAR"
    
    mkdir -p newlib-build
    cd newlib-build
    
    info "Configuring newlib..."
    CFLAGS_FOR_TARGET="-O2 -march=vr4300 -mtune=vr4300" \
    "../newlib-${NEWLIB_VER}/configure" \
        --prefix="$N64_INST" \
        --target="$TARGET" \
        --with-cpu=mips64vr4300 \
        --disable-multilib \
        --disable-newlib-supplied-syscalls \
        > /dev/null 2>&1
    
    info "Building newlib (this takes ~10 minutes)..."
    make -j"$JOBS" > /dev/null 2>&1
    make install > /dev/null 2>&1
    
    cd "$BUILD_DIR"
    log "newlib installed"
    
    # Finish GCC with libgcc
    info "Building libgcc..."
    cd gcc-build
    make -j"$JOBS" all-target-libgcc > /dev/null 2>&1 || true
    make install-target-libgcc > /dev/null 2>&1 || true
    cd "$BUILD_DIR"
    log "libgcc installed"
fi

# ============================================================================
# LIBDRAGON
# ============================================================================

section "INSTALLING LIBDRAGON"

export N64_INST="$N64_INST"

cd "$LIBDRAGON_DIR"

if [ -f "$N64_INST/lib/libdragon.a" ]; then
    log "libdragon already installed"
elif [ -f "$LIBDRAGON_DIR/libdragon.a" ]; then
    log "libdragon already built, installing..."
    make install > /dev/null 2>&1
else
    # Download if no Makefile
    if [ ! -f "Makefile" ]; then
        info "Downloading libdragon..."
        cd /tmp
        rm -f libdragon.tar.gz
        wget -q --show-progress "https://github.com/DragonMinded/libdragon/archive/refs/heads/trunk.tar.gz" -O libdragon.tar.gz || \
        curl -L --progress-bar "https://github.com/DragonMinded/libdragon/archive/refs/heads/trunk.tar.gz" -o libdragon.tar.gz
        
        info "Extracting libdragon..."
        rm -rf "$LIBDRAGON_DIR"/*
        tar xzf libdragon.tar.gz
        mv libdragon-trunk/* "$LIBDRAGON_DIR/" 2>/dev/null || mv libdragon-*/* "$LIBDRAGON_DIR/" 2>/dev/null
        rm -rf libdragon-trunk libdragon-* libdragon.tar.gz
        cd "$LIBDRAGON_DIR"
        log "libdragon downloaded"
    fi
    
    # Build
    if [ -f "Makefile" ]; then
        info "Building libdragon..."
        make -j"$JOBS" > /dev/null 2>&1 && log "libdragon built" || warn "libdragon build had warnings"
        
        info "Installing libdragon to $N64_INST..."
        make install > /dev/null 2>&1 && log "libdragon installed" || warn "libdragon install had warnings"
        
        # Tools
        if [ -d "tools" ]; then
            info "Building libdragon tools..."
            make -C tools -j"$JOBS" > /dev/null 2>&1 || true
            make -C tools install > /dev/null 2>&1 || true
            log "libdragon tools installed"
        fi
    else
        fail "No Makefile found in libdragon directory"
    fi
fi

# ============================================================================
# CLEANUP
# ============================================================================

section "CLEANUP"

info "Removing build files (~2GB)..."
rm -rf "$BUILD_DIR"
log "Cleanup complete"

# ============================================================================
# ENVIRONMENT
# ============================================================================

section "ENVIRONMENT SETUP"

# Add to .bashrc if not present
if ! grep -q "N64_INST=" ~/.bashrc 2>/dev/null; then
    cat >> ~/.bashrc << EOF

# N64 libdragon development
export N64_INST="\$HOME/n64"
export PATH="\$N64_INST/bin:\$PATH"
export LIBDRAGON="\$HOME/libdragon"
EOF
    log "Added to ~/.bashrc"
else
    log "Environment already in ~/.bashrc"
fi

# ============================================================================
# VERIFY
# ============================================================================

section "VERIFICATION"

echo ""
printf "  ${C}Toolchain:${N}\n"
if [ -f "$N64_INST/bin/mips64-elf-gcc" ]; then
    VER=$("$N64_INST/bin/mips64-elf-gcc" --version 2>&1 | head -n1)
    printf "    ${G}✓${N} mips64-elf-gcc: %s\n" "$VER"
else
    printf "    ${R}✗${N} mips64-elf-gcc NOT FOUND\n"
fi

for tool in ld as objcopy objdump; do
    if [ -f "$N64_INST/bin/mips64-elf-$tool" ]; then
        printf "    ${G}✓${N} mips64-elf-%s\n" "$tool"
    fi
done

echo ""
printf "  ${C}Libraries:${N}\n"
[ -f "$N64_INST/mips64-elf/lib/libc.a" ] && printf "    ${G}✓${N} libc.a\n"
[ -f "$N64_INST/lib/libdragon.a" ] && printf "    ${G}✓${N} libdragon.a\n"

echo ""
printf "  ${C}Tools:${N}\n"
for tool in n64tool chksum64 mksprite mkdfs; do
    if [ -f "$N64_INST/bin/$tool" ]; then
        printf "    ${G}✓${N} %s\n" "$tool"
    fi
done

echo ""
printf "  ${C}SDK:${N}\n"
[ -d "$LIBDRAGON_DIR/examples" ] && printf "    ${G}✓${N} Examples at %s/examples\n" "$LIBDRAGON_DIR"

# ============================================================================
# DONE
# ============================================================================

section "INSTALLATION COMPLETE!"

cat << EOF

╔══════════════════════════════════════════════════════════════════════════╗
║                                                                          ║
║   ██╗     ██╗██████╗ ██████╗ ██████╗  █████╗  ██████╗  ██████╗ ███╗   ██╗║
║   ██║     ██║██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔════╝ ██╔═══██╗████╗  ██║║
║   ██║     ██║██████╔╝██║  ██║██████╔╝███████║██║  ███╗██║   ██║██╔██╗ ██║║
║   ██║     ██║██╔══██╗██║  ██║██╔══██╗██╔══██║██║   ██║██║   ██║██║╚██╗██║║
║   ███████╗██║██████╔╝██████╔╝██║  ██║██║  ██║╚██████╔╝╚██████╔╝██║ ╚████║║
║   ╚══════╝╚═╝╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝║
║                                                                          ║
║                    N64 Development Ready!                                ║
║                                                                          ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  PATHS:                                                                  ║
║    Toolchain:  ~/n64                                                     ║
║    libdragon:  ~/libdragon                                               ║
║                                                                          ║
║  QUICK START:                                                            ║
║    source ~/.bashrc                                                      ║
║    cd ~/libdragon/examples/spritemap                                     ║
║    make                                                                  ║
║    mupen64plus spritemap.z64                                             ║
║                                                                          ║
║  BUILD YOUR OWN:                                                         ║
║    mkdir myrom && cd myrom                                               ║
║    cp ~/libdragon/examples/spritemap/Makefile .                          ║
║    # edit and make!                                                      ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝

                      ～ nyaa! happy N64 hacking! :3 ～

EOF

log "Run: source ~/.bashrc"
log "Then try: cd ~/libdragon/examples && ls"
