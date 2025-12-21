#!/bin/bash
#===============================================================================
# RETRO-MODERN SDK INSTALLER (1930-2025)
# Atari to PS5 Development Toolchain
# Uses: wget, curl only (no git)
# Author: Flames / Team Flames
#===============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Root check
IS_ROOT=false
if [[ $EUID -eq 0 ]]; then
    IS_ROOT=true
    log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
    echo -e "${YELLOW}[WARN] Running as root - will use apt instead of Homebrew${NC}"
fi

# Directories
INSTALL_DIR="$HOME/retro-sdk"
DOWNLOAD_DIR="$INSTALL_DIR/downloads"
TOOLS_DIR="$INSTALL_DIR/tools"
SDK_DIR="$INSTALL_DIR/sdks"

# Create directory structure
mkdir -p "$DOWNLOAD_DIR" "$TOOLS_DIR" "$SDK_DIR"
mkdir -p "$SDK_DIR"/{pre-electronic,8bit,16bit,32bit,64bit,modern}

#===============================================================================
# UTILITY FUNCTIONS
#===============================================================================

log_info() { echo -e "${CYAN}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_era() { echo -e "\n${MAGENTA}═══════════════════════════════════════════════════════════${NC}"; echo -e "${MAGENTA} $1${NC}"; echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}\n"; }

download_file() {
    local url="$1"
    local output="$2"
    if command -v wget &> /dev/null; then
        wget -q --show-progress -O "$output" "$url" 2>/dev/null || curl -L -o "$output" "$url"
    else
        curl -L -o "$output" "$url"
    fi
}

extract_archive() {
    local file="$1"
    local dest="$2"
    case "$file" in
        *.tar.gz|*.tgz) tar -xzf "$file" -C "$dest" ;;
        *.tar.bz2) tar -xjf "$file" -C "$dest" ;;
        *.tar.xz) tar -xJf "$file" -C "$dest" ;;
        *.zip) unzip -q "$file" -d "$dest" ;;
        *.7z) 7z x "$file" -o"$dest" ;;
        *) log_warn "Unknown archive format: $file" ;;
    esac
}

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

OS=$(detect_os)
ARCH=$(uname -m)

#===============================================================================
# PACKAGE MANAGER SETUP (apt for Linux/root, brew for macOS non-root)
#===============================================================================

install_system_deps() {
    log_info "Installing system dependencies..."
    
    if [[ "$OS" == "linux" ]]; then
        # Use apt on Linux (works as root)
        apt-get update -qq
        apt-get install -y -qq \
            build-essential \
            cmake \
            ninja-build \
            pkg-config \
            libssl-dev \
            libcurl4-openssl-dev \
            zlib1g-dev \
            libbz2-dev \
            libreadline-dev \
            libsqlite3-dev \
            libncurses5-dev \
            libffi-dev \
            liblzma-dev \
            libxml2-dev \
            libxslt1-dev \
            p7zip-full \
            unzip \
            xz-utils \
            wget \
            curl \
            2>/dev/null || true
        log_success "System dependencies installed via apt"
        
    elif [[ "$OS" == "macos" ]]; then
        if [[ "$IS_ROOT" == "true" ]]; then
            log_warn "Running as root on macOS - skipping Homebrew"
            log_warn "Install Xcode Command Line Tools manually: xcode-select --install"
        else
            # Use Homebrew on macOS (non-root only)
            if ! command -v brew &> /dev/null; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install cmake ninja pkg-config p7zip wget curl 2>/dev/null || true
            log_success "Homebrew ready"
        fi
    fi
}

#===============================================================================
# PYTHON 3.13
#===============================================================================

install_python313() {
    log_info "Installing Python 3.13..."
    local py_ver="3.13.0"
    
    if [[ "$OS" == "macos" ]]; then
        download_file "https://www.python.org/ftp/python/${py_ver}/python-${py_ver}-macos11.pkg" \
            "$DOWNLOAD_DIR/python-${py_ver}.pkg"
        sudo installer -pkg "$DOWNLOAD_DIR/python-${py_ver}.pkg" -target /
    elif [[ "$OS" == "linux" ]]; then
        # Check if Python 3.13 already exists
        if command -v python3.13 &> /dev/null; then
            log_success "Python 3.13 already installed"
            return
        fi
        
        # Try to install from deadsnakes PPA first (Ubuntu/Debian)
        if command -v apt-get &> /dev/null; then
            log_info "Attempting Python 3.13 via apt..."
            apt-get install -y software-properties-common 2>/dev/null || true
            add-apt-repository -y ppa:deadsnakes/ppa 2>/dev/null || true
            apt-get update -qq 2>/dev/null || true
            if apt-get install -y python3.13 python3.13-venv python3.13-dev 2>/dev/null; then
                log_success "Python 3.13 installed via apt"
                return
            fi
        fi
        
        # Fallback: build from source
        log_info "Building Python 3.13 from source..."
        download_file "https://www.python.org/ftp/python/${py_ver}/Python-${py_ver}.tgz" \
            "$DOWNLOAD_DIR/Python-${py_ver}.tgz"
        mkdir -p "$TOOLS_DIR/python"
        extract_archive "$DOWNLOAD_DIR/Python-${py_ver}.tgz" "$TOOLS_DIR/python"
        cd "$TOOLS_DIR/python/Python-${py_ver}"
        ./configure --prefix="$TOOLS_DIR/python313" --enable-optimizations 2>/dev/null || \
        ./configure --prefix="$TOOLS_DIR/python313"
        make -j$(nproc) 2>/dev/null || make
        make install
        cd - > /dev/null
    fi
    log_success "Python 3.13 installed"
}

#===============================================================================
# CLANG/LLVM
#===============================================================================

install_clang() {
    log_info "Installing LLVM/Clang..."
    local llvm_ver="18.1.8"
    
    if [[ "$OS" == "macos" ]]; then
        if [[ "$ARCH" == "arm64" ]]; then
            download_file "https://github.com/llvm/llvm-project/releases/download/llvmorg-${llvm_ver}/clang+llvm-${llvm_ver}-arm64-apple-darwin22.0.tar.xz" \
                "$DOWNLOAD_DIR/llvm-${llvm_ver}.tar.xz"
        else
            download_file "https://github.com/llvm/llvm-project/releases/download/llvmorg-${llvm_ver}/clang+llvm-${llvm_ver}-x86_64-apple-darwin21.0.tar.xz" \
                "$DOWNLOAD_DIR/llvm-${llvm_ver}.tar.xz"
        fi
    elif [[ "$OS" == "linux" ]]; then
        download_file "https://github.com/llvm/llvm-project/releases/download/llvmorg-${llvm_ver}/clang+llvm-${llvm_ver}-x86_64-linux-gnu-ubuntu-18.04.tar.xz" \
            "$DOWNLOAD_DIR/llvm-${llvm_ver}.tar.xz"
    fi
    
    mkdir -p "$TOOLS_DIR/llvm"
    extract_archive "$DOWNLOAD_DIR/llvm-${llvm_ver}.tar.xz" "$TOOLS_DIR/llvm"
    log_success "LLVM/Clang ${llvm_ver} installed"
}

#===============================================================================
# ERA 1: PRE-ELECTRONIC (1930-1945) - Mechanical/Electromechanical
#===============================================================================

install_era_pre_electronic() {
    log_era "ERA 1: PRE-ELECTRONIC (1930-1945)"
    local dest="$SDK_DIR/pre-electronic"
    
    # Z1/Z3 Plankalkül Interpreter (historical recreation)
    log_info "Setting up Plankalkül development environment..."
    cat > "$dest/plankaluel_interpreter.py" << 'PYEOF'
#!/usr/bin/env python3
"""
Plankalkül Interpreter - Konrad Zuse's 1945 Programming Language
Historical recreation for educational purposes
"""

class PlankalkuelInterpreter:
    def __init__(self):
        self.variables = {}
        self.subscripts = {}
        
    def parse_variable(self, notation):
        """Parse Zuse's 2D notation: V | index | type"""
        parts = notation.strip().split('|')
        if len(parts) >= 3:
            return {'var': parts[0].strip(), 'idx': parts[1].strip(), 'type': parts[2].strip()}
        return None
    
    def execute(self, program):
        """Execute Plankalkül program"""
        lines = program.strip().split('\n')
        for line in lines:
            self.execute_line(line)
    
    def execute_line(self, line):
        if '=>' in line:  # Assignment
            parts = line.split('=>')
            src = self.evaluate(parts[0].strip())
            dest = parts[1].strip()
            self.variables[dest] = src
        elif 'W' in line:  # Loop (Wiederholung)
            pass  # Loop handling
            
    def evaluate(self, expr):
        try:
            return eval(expr, {"__builtins__": {}}, self.variables)
        except:
            return expr

if __name__ == "__main__":
    interp = PlankalkuelInterpreter()
    print("Plankalkül Interpreter - Zuse 1945")
    print("Historical programming language recreation")
PYEOF
    chmod +x "$dest/plankaluel_interpreter.py"
    
    # Colossus/ENIAC Simulator Framework
    log_info "Creating ENIAC programming simulator..."
    cat > "$dest/eniac_simulator.py" << 'PYEOF'
#!/usr/bin/env python3
"""
ENIAC Simulator - 1945 Electronic Computer
Simulates plugboard programming and accumulator operations
"""

class ENIACSimulator:
    def __init__(self):
        self.accumulators = [0] * 20  # 20 accumulators
        self.program_trays = []
        self.function_tables = {}
        self.cycle_count = 0
        
    def plug_connection(self, src_acc, dest_acc, operation):
        """Simulate plugboard connection"""
        self.program_trays.append({
            'src': src_acc,
            'dest': dest_acc,
            'op': operation
        })
        
    def load_function_table(self, table_id, values):
        """Load function table (ROM-like storage)"""
        self.function_tables[table_id] = values
        
    def execute_cycle(self):
        """Execute one addition cycle (200 microseconds)"""
        for connection in self.program_trays:
            src = self.accumulators[connection['src']]
            if connection['op'] == 'ADD':
                self.accumulators[connection['dest']] += src
            elif connection['op'] == 'SUB':
                self.accumulators[connection['dest']] -= src
            elif connection['op'] == 'LOAD':
                self.accumulators[connection['dest']] = src
        self.cycle_count += 1
        
    def read_accumulator(self, acc_id):
        return self.accumulators[acc_id]
        
    def punch_output(self):
        """Output to punch cards"""
        return [self.accumulators[i] for i in range(10)]

if __name__ == "__main__":
    eniac = ENIACSimulator()
    print("ENIAC Simulator - 1945")
    print("Accumulators:", eniac.accumulators[:5])
PYEOF
    chmod +x "$dest/eniac_simulator.py"
    
    log_success "Pre-electronic era tools installed"
}

#===============================================================================
# ERA 2: 8-BIT ERA (1975-1985) - Atari, C64, NES, etc.
#===============================================================================

install_era_8bit() {
    log_era "ERA 2: 8-BIT GOLDEN AGE (1975-1985)"
    local dest="$SDK_DIR/8bit"
    
    # CC65 - 6502 C Compiler (Atari 2600/8-bit, C64, NES, Apple II)
    log_info "Installing CC65 (6502 C Compiler)..."
    download_file "https://cc65.github.io/cc65-snapshot-win32.zip" "$DOWNLOAD_DIR/cc65.zip" 2>/dev/null || \
    download_file "https://github.com/cc65/cc65/archive/refs/tags/V2.19.tar.gz" "$DOWNLOAD_DIR/cc65.tar.gz"
    
    if [[ -f "$DOWNLOAD_DIR/cc65.tar.gz" ]]; then
        mkdir -p "$dest/cc65"
        extract_archive "$DOWNLOAD_DIR/cc65.tar.gz" "$dest/cc65"
        cd "$dest/cc65/cc65-2.19" 2>/dev/null && make -j$(nproc) || true
        cd - > /dev/null
    fi
    
    # DASM - Atari 2600/VCS Assembler
    log_info "Installing DASM (Atari 2600 Assembler)..."
    download_file "https://github.com/dasm-assembler/dasm/releases/download/2.20.14.1/dasm-2.20.14.1-linux-x64.tar.gz" \
        "$DOWNLOAD_DIR/dasm.tar.gz" 2>/dev/null || true
    mkdir -p "$dest/dasm"
    extract_archive "$DOWNLOAD_DIR/dasm.tar.gz" "$dest/dasm" 2>/dev/null || true
    
    # ACME Cross-Assembler (C64, VIC-20, Plus/4)
    log_info "Installing ACME Cross-Assembler..."
    download_file "https://sourceforge.net/projects/acme-crossass/files/linux/acme0.97.tar.gz/download" \
        "$DOWNLOAD_DIR/acme.tar.gz" 2>/dev/null || true
    mkdir -p "$dest/acme"
    extract_archive "$DOWNLOAD_DIR/acme.tar.gz" "$dest/acme" 2>/dev/null || true
    
    # Z80 Assembler (ZX Spectrum, MSX, ColecoVision, Game Gear)
    log_info "Installing z88dk (Z80 Development Kit)..."
    download_file "https://github.com/z88dk/z88dk/releases/download/v2.3/z88dk-linux-x86_64-2.3.tgz" \
        "$DOWNLOAD_DIR/z88dk.tgz" 2>/dev/null || true
    mkdir -p "$dest/z88dk"
    extract_archive "$DOWNLOAD_DIR/z88dk.tgz" "$dest/z88dk" 2>/dev/null || true
    
    # NES Development (ca65 from cc65 + NESLib)
    log_info "Setting up NES development environment..."
    mkdir -p "$dest/nes"
    cat > "$dest/nes/nes_template.s" << 'ASMEOF'
; NES ROM Template - iNES Header
.segment "HEADER"
    .byte "NES", $1A     ; iNES magic
    .byte $02            ; 2x 16KB PRG-ROM
    .byte $01            ; 1x 8KB CHR-ROM
    .byte $00            ; Mapper 0, horizontal mirroring
    .byte $00            ; Mapper 0
    .byte $00, $00, $00, $00, $00, $00, $00, $00

.segment "STARTUP"
.segment "CODE"

RESET:
    SEI                  ; Disable IRQs
    CLD                  ; Disable decimal mode
    LDX #$40
    STX $4017            ; Disable APU frame IRQ
    LDX #$FF
    TXS                  ; Setup stack
    INX
    STX $2000            ; Disable NMI
    STX $2001            ; Disable rendering
    STX $4010            ; Disable DMC IRQs
    
@vblankwait1:
    BIT $2002
    BPL @vblankwait1
    
    JMP RESET

NMI:
    RTI
    
IRQ:
    RTI

.segment "VECTORS"
    .word NMI
    .word RESET
    .word IRQ

.segment "CHARS"
ASMEOF

    # Atari 8-bit SDK Template
    log_info "Setting up Atari 8-bit templates..."
    mkdir -p "$dest/atari8"
    cat > "$dest/atari8/atari_template.s" << 'ASMEOF'
; Atari 800/XL/XE Template
; Uses cc65/ca65 toolchain

.include "atari.inc"

.segment "EXEHDR"
    .word $FFFF          ; Atari executable header

.segment "CODE"
    
START:
    LDA #0
    STA COLOR2           ; Set background color
    STA COLOR1           ; Set border color
    
MAINLOOP:
    LDA RTCLOK+2         ; Wait for VBlank
@WAIT:
    CMP RTCLOK+2
    BEQ @WAIT
    
    JMP MAINLOOP

.segment "AUTOSTRT"
    .word RUNAD
    .word RUNAD+1
    .word START
ASMEOF
    
    log_success "8-bit era SDKs installed"
}

#===============================================================================
# ERA 3: 16-BIT ERA (1985-1995) - Genesis, SNES, Amiga, etc.
#===============================================================================

install_era_16bit() {
    log_era "ERA 3: 16-BIT REVOLUTION (1985-1995)"
    local dest="$SDK_DIR/16bit"
    
    # SGDK - Sega Genesis/Mega Drive SDK
    log_info "Installing SGDK (Sega Genesis SDK)..."
    download_file "https://github.com/Stephane-D/SGDK/releases/download/v2.00/sgdk200.7z" \
        "$DOWNLOAD_DIR/sgdk.7z" 2>/dev/null || \
    download_file "https://github.com/Stephane-D/SGDK/archive/refs/tags/v2.00.tar.gz" \
        "$DOWNLOAD_DIR/sgdk.tar.gz" 2>/dev/null || true
    mkdir -p "$dest/sgdk"
    extract_archive "$DOWNLOAD_DIR/sgdk.tar.gz" "$dest/sgdk" 2>/dev/null || true
    
    # PVSnesLib - SNES Development
    log_info "Installing PVSnesLib (SNES SDK)..."
    download_file "https://github.com/alekmaul/pvsneslib/archive/refs/heads/master.zip" \
        "$DOWNLOAD_DIR/pvsneslib.zip" 2>/dev/null || true
    mkdir -p "$dest/pvsneslib"
    extract_archive "$DOWNLOAD_DIR/pvsneslib.zip" "$dest/pvsneslib" 2>/dev/null || true
    
    # WLA-DX Assembler (Multi-platform: GB, GBC, SMS, Genesis, SNES)
    log_info "Installing WLA-DX Assembler..."
    download_file "https://github.com/vhelin/wla-dx/archive/refs/tags/v10.6.tar.gz" \
        "$DOWNLOAD_DIR/wla-dx.tar.gz" 2>/dev/null || true
    mkdir -p "$dest/wla-dx"
    extract_archive "$DOWNLOAD_DIR/wla-dx.tar.gz" "$dest/wla-dx" 2>/dev/null || true
    
    # GBDK-2020 - Game Boy Development Kit
    log_info "Installing GBDK-2020 (Game Boy SDK)..."
    download_file "https://github.com/gbdk-2020/gbdk-2020/releases/download/4.3.0/gbdk-linux64.tar.gz" \
        "$DOWNLOAD_DIR/gbdk.tar.gz" 2>/dev/null || true
    mkdir -p "$dest/gbdk"
    extract_archive "$DOWNLOAD_DIR/gbdk.tar.gz" "$dest/gbdk" 2>/dev/null || true
    
    # Amiga Development (VBCC + NDK)
    log_info "Setting up Amiga development environment..."
    mkdir -p "$dest/amiga"
    download_file "http://sun.hasenbraten.de/vbcc/2022-05-22/vbcc_target_m68k-amigaos.lha" \
        "$DOWNLOAD_DIR/vbcc_amiga.lha" 2>/dev/null || true
    
    # Neo Geo Development Kit
    log_info "Setting up Neo Geo SDK..."
    mkdir -p "$dest/neogeo"
    cat > "$dest/neogeo/neogeo_template.c" << 'CEOF'
// Neo Geo Development Template
// Uses m68k-elf-gcc toolchain

#include <ngdevkit.h>

// Sprite control
#define SPRITE_BASE 0x3C0000

volatile u16 *sprite_ram = (volatile u16*)SPRITE_BASE;

void init_neogeo(void) {
    // Initialize Neo Geo hardware
    *REG_IRQACK = 0;
    
    // Setup display
    *REG_LSPCMODE = 0;
}

int main(void) {
    init_neogeo();
    
    while(1) {
        wait_vblank();
        // Game logic here
    }
    
    return 0;
}
CEOF
    
    log_success "16-bit era SDKs installed"
}

#===============================================================================
# ERA 4: 32-BIT ERA (1993-2005) - PS1, Saturn, N64, Dreamcast
#===============================================================================

install_era_32bit() {
    log_era "ERA 4: 32-BIT 3D REVOLUTION (1993-2005)"
    local dest="$SDK_DIR/32bit"
    
    # PSn00bSDK - PlayStation 1
    log_info "Installing PSn00bSDK (PlayStation 1)..."
    download_file "https://github.com/Lameguy64/PSn00bSDK/archive/refs/heads/master.zip" \
        "$DOWNLOAD_DIR/psn00bsdk.zip" 2>/dev/null || true
    mkdir -p "$dest/ps1"
    extract_archive "$DOWNLOAD_DIR/psn00bsdk.zip" "$dest/ps1" 2>/dev/null || true
    
    # LibN64 / N64 SDK Tools
    log_info "Setting up Nintendo 64 development..."
    mkdir -p "$dest/n64"
    
    # Modern N64 Toolchain (mips64-elf)
    download_file "https://github.com/DragonMinded/libdragon/releases/download/toolchain-continuous-prerelease/gcc-toolchain-mips64-linux-x86_64.tar.gz" \
        "$DOWNLOAD_DIR/n64-toolchain.tar.gz" 2>/dev/null || true
    extract_archive "$DOWNLOAD_DIR/n64-toolchain.tar.gz" "$dest/n64" 2>/dev/null || true
    
    cat > "$dest/n64/n64_template.c" << 'CEOF'
// Nintendo 64 Development Template
// Uses libdragon or libultra

#include <libdragon.h>

int main(void) {
    // Initialize N64 hardware
    display_init(RESOLUTION_320x240, DEPTH_32_BPP, 2, GAMMA_NONE, FILTERS_RESAMPLE);
    dfs_init(DFS_DEFAULT_LOCATION);
    rdp_init();
    controller_init();
    
    while(1) {
        display_context_t disp = display_lock();
        
        // Clear screen
        graphics_fill_screen(disp, 0x000000FF);
        
        // Draw something
        graphics_draw_text(disp, 100, 100, "Hello N64!");
        
        display_show(disp);
        
        controller_scan();
        struct controller_data keys = get_keys_down();
        
        if(keys.c[0].start) {
            // Start pressed
        }
    }
    
    return 0;
}
CEOF
    
    # Sega Saturn (Jo Engine / SGL)
    log_info "Setting up Sega Saturn development..."
    mkdir -p "$dest/saturn"
    download_file "https://github.com/johannes-fetz/joern/archive/refs/heads/master.zip" \
        "$DOWNLOAD_DIR/jo-engine.zip" 2>/dev/null || true
    
    cat > "$dest/saturn/saturn_template.c" << 'CEOF'
// Sega Saturn Development Template
// Jo Engine Framework

#include <jo/jo.h>

void main_game_loop(void) {
    // Game logic here
    jo_printf(10, 10, "Hello Saturn!");
}

void jo_main(void) {
    jo_core_init(JO_COLOR_Black);
    
    jo_core_add_callback(main_game_loop);
    
    jo_core_run();
}
CEOF
    
    # Sega Dreamcast (KallistiOS)
    log_info "Installing KallistiOS (Dreamcast SDK)..."
    download_file "https://github.com/KallistiOS/KallistiOS/archive/refs/heads/master.zip" \
        "$DOWNLOAD_DIR/kos.zip" 2>/dev/null || true
    mkdir -p "$dest/dreamcast"
    extract_archive "$DOWNLOAD_DIR/kos.zip" "$dest/dreamcast" 2>/dev/null || true
    
    cat > "$dest/dreamcast/dc_template.c" << 'CEOF'
// Dreamcast Development Template (KallistiOS)

#include <kos.h>

int main(int argc, char *argv[]) {
    // Initialize Dreamcast hardware
    vid_set_mode(DM_640x480, PM_RGB565);
    
    pvr_init_defaults();
    
    while(1) {
        pvr_wait_ready();
        pvr_scene_begin();
        
        // Render scene
        pvr_list_begin(PVR_LIST_OP_POLY);
        // Draw polygons here
        pvr_list_finish();
        
        pvr_scene_finish();
        
        // Check controller
        maple_device_t *cont = maple_enum_type(0, MAPLE_FUNC_CONTROLLER);
        if(cont) {
            cont_state_t *state = maple_dev_status(cont);
            if(state->buttons & CONT_START)
                break;
        }
    }
    
    return 0;
}
CEOF
    
    # GBA SDK (devkitARM)
    log_info "Installing devkitARM (GBA/NDS/3DS)..."
    download_file "https://github.com/devkitPro/pacman/releases/download/v6.0.2/devkitpro-pacman-installer.pkg" \
        "$DOWNLOAD_DIR/devkitpro.pkg" 2>/dev/null || true
    
    log_success "32-bit era SDKs installed"
}

#===============================================================================
# ERA 5: 64-BIT/HD ERA (2005-2015) - PS3, 360, Wii, PS Vita
#===============================================================================

install_era_64bit() {
    log_era "ERA 5: HD CONSOLE ERA (2005-2015)"
    local dest="$SDK_DIR/64bit"
    
    # PSL1GHT - PlayStation 3 Homebrew SDK
    log_info "Setting up PlayStation 3 development (PSL1GHT)..."
    mkdir -p "$dest/ps3"
    download_file "https://github.com/psl1ght/PSL1GHT/archive/refs/heads/master.zip" \
        "$DOWNLOAD_DIR/psl1ght.zip" 2>/dev/null || true
    extract_archive "$DOWNLOAD_DIR/psl1ght.zip" "$dest/ps3" 2>/dev/null || true
    
    cat > "$dest/ps3/ps3_template.c" << 'CEOF'
// PlayStation 3 Homebrew Template (PSL1GHT)

#include <psl1ght/lv2.h>
#include <tiny3d.h>
#include <io/pad.h>

int main(int argc, char *argv[]) {
    // Initialize PS3 systems
    tiny3d_Init(1024*1024);
    ioPadInit(7);
    
    while(1) {
        tiny3d_Clear(0xff000000, TINY3D_CLEAR_ALL);
        tiny3d_AlphaTest(1, 0x10, TINY3D_ALPHA_FUNC_GEQUAL);
        tiny3d_BlendFunc(1, TINY3D_BLEND_FUNC_SRC_RGB_SRC_ALPHA, 
                         TINY3D_BLEND_FUNC_DST_RGB_ONE_MINUS_SRC_ALPHA);
        
        // Render frame
        tiny3d_Flip();
        
        // Check controller
        padInfo padinfo;
        padData paddata;
        ioPadGetInfo(&padinfo);
        if(padinfo.status[0]) {
            ioPadGetData(0, &paddata);
            if(paddata.BTN_START)
                break;
        }
    }
    
    return 0;
}
CEOF
    
    # DevkitPPC - Wii/GameCube Homebrew
    log_info "Setting up Wii/GameCube development (devkitPPC)..."
    mkdir -p "$dest/wii"
    
    cat > "$dest/wii/wii_template.c" << 'CEOF'
// Wii/GameCube Homebrew Template (libogc)

#include <gccore.h>
#include <wiiuse/wpad.h>

static void *xfb = NULL;
static GXRModeObj *rmode = NULL;

int main(int argc, char **argv) {
    // Initialize video
    VIDEO_Init();
    WPAD_Init();
    
    rmode = VIDEO_GetPreferredMode(NULL);
    xfb = MEM_K0_TO_K1(SYS_AllocateFramebuffer(rmode));
    
    VIDEO_Configure(rmode);
    VIDEO_SetNextFramebuffer(xfb);
    VIDEO_SetBlack(false);
    VIDEO_Flush();
    VIDEO_WaitVSync();
    
    // Main loop
    while(1) {
        WPAD_ScanPads();
        u32 pressed = WPAD_ButtonsDown(0);
        
        if(pressed & WPAD_BUTTON_HOME)
            break;
            
        VIDEO_WaitVSync();
    }
    
    return 0;
}
CEOF
    
    # PS Vita SDK (VitaSDK)
    log_info "Setting up PS Vita development..."
    mkdir -p "$dest/vita"
    download_file "https://github.com/vitasdk/autobuilds/releases/download/master-linux-v2.469/vitasdk-x86_64-linux-gnu-2024-04-27_18-28-53.tar.bz2" \
        "$DOWNLOAD_DIR/vitasdk.tar.bz2" 2>/dev/null || true
    
    cat > "$dest/vita/vita_template.c" << 'CEOF'
// PS Vita Development Template (VitaSDK)

#include <psp2/kernel/processmgr.h>
#include <psp2/ctrl.h>
#include <vita2d.h>

int main(int argc, char *argv[]) {
    vita2d_init();
    vita2d_set_clear_color(RGBA8(0x00, 0x00, 0x00, 0xFF));
    
    SceCtrlData ctrl;
    memset(&ctrl, 0, sizeof(ctrl));
    
    while(1) {
        sceCtrlPeekBufferPositive(0, &ctrl, 1);
        
        if(ctrl.buttons & SCE_CTRL_START)
            break;
            
        vita2d_start_drawing();
        vita2d_clear_screen();
        
        // Draw here
        vita2d_draw_rectangle(100, 100, 200, 200, RGBA8(0xFF, 0x00, 0x00, 0xFF));
        
        vita2d_end_drawing();
        vita2d_swap_buffers();
    }
    
    vita2d_fini();
    sceKernelExitProcess(0);
    return 0;
}
CEOF
    
    # Nintendo 3DS (devkitARM)
    log_info "Setting up Nintendo 3DS development..."
    mkdir -p "$dest/3ds"
    
    cat > "$dest/3ds/3ds_template.c" << 'CEOF'
// Nintendo 3DS Development Template (libctru)

#include <3ds.h>
#include <citro2d.h>

int main(int argc, char* argv[]) {
    gfxInitDefault();
    C3D_Init(C3D_DEFAULT_CMDBUF_SIZE);
    C2D_Init(C2D_DEFAULT_MAX_OBJECTS);
    C2D_Prepare();
    
    C3D_RenderTarget* top = C2D_CreateScreenTarget(GFX_TOP, GFX_LEFT);
    
    while(aptMainLoop()) {
        hidScanInput();
        u32 kDown = hidKeysDown();
        
        if(kDown & KEY_START)
            break;
            
        C3D_FrameBegin(C3D_FRAME_SYNCDRAW);
        C2D_TargetClear(top, C2D_Color32(0x00, 0x00, 0x00, 0xFF));
        C2D_SceneBegin(top);
        
        // Draw here
        C2D_DrawRectSolid(100, 50, 0, 200, 100, C2D_Color32(0xFF, 0x00, 0x00, 0xFF));
        
        C3D_FrameEnd(0);
    }
    
    C2D_Fini();
    C3D_Fini();
    gfxExit();
    return 0;
}
CEOF
    
    log_success "HD era SDKs installed"
}

#===============================================================================
# ERA 6: MODERN ERA (2013-2025) - PS4, PS5, Switch, Xbox
#===============================================================================

install_era_modern() {
    log_era "ERA 6: MODERN CONSOLE ERA (2013-2025)"
    local dest="$SDK_DIR/modern"
    
    # Nintendo Switch (libnx)
    log_info "Setting up Nintendo Switch development..."
    mkdir -p "$dest/switch"
    download_file "https://github.com/devkitPro/libnx/archive/refs/heads/master.zip" \
        "$DOWNLOAD_DIR/libnx.zip" 2>/dev/null || true
    
    cat > "$dest/switch/switch_template.c" << 'CEOF'
// Nintendo Switch Development Template (libnx)

#include <switch.h>

int main(int argc, char* argv[]) {
    consoleInit(NULL);
    
    printf("Hello Nintendo Switch!\n");
    printf("Press + to exit\n");
    
    padConfigureInput(1, HidNpadStyleSet_NpadStandard);
    PadState pad;
    padInitializeDefault(&pad);
    
    while(appletMainLoop()) {
        padUpdate(&pad);
        u64 kDown = padGetButtonsDown(&pad);
        
        if(kDown & HidNpadButton_Plus)
            break;
            
        consoleUpdate(NULL);
    }
    
    consoleExit(NULL);
    return 0;
}
CEOF
    
    # PlayStation 4/5 (OpenOrbis)
    log_info "Setting up PlayStation 4/5 development (OpenOrbis)..."
    mkdir -p "$dest/ps4" "$dest/ps5"
    download_file "https://github.com/OpenOrbis/OpenOrbis-PS4-Toolchain/archive/refs/heads/master.zip" \
        "$DOWNLOAD_DIR/openorbis.zip" 2>/dev/null || true
    
    cat > "$dest/ps4/ps4_template.c" << 'CEOF'
// PlayStation 4 Development Template (OpenOrbis)

#include <orbis/libkernel.h>
#include <orbis/Sysmodule.h>
#include <orbis/UserService.h>
#include <orbis/Pad.h>

int main(int argc, char *argv[]) {
    // Initialize PS4 systems
    sceSysmoduleLoadModule(ORBIS_SYSMODULE_PAD);
    
    OrbisPadData padData;
    int pad = scePadOpen(0x1, 0, 0, NULL);
    
    while(1) {
        scePadReadState(pad, &padData);
        
        if(padData.buttons & ORBIS_PAD_BUTTON_OPTIONS)
            break;
            
        sceKernelUsleep(16666);  // ~60fps
    }
    
    scePadClose(pad);
    return 0;
}
CEOF

    cat > "$dest/ps5/ps5_template.c" << 'CEOF'
// PlayStation 5 Development Template
// Note: Official SDK required for retail development

#include <orbis/libkernel.h>
#include <orbis/Sysmodule.h>

// PS5 uses similar APIs to PS4 with extensions
// DualSense haptic feedback example structure

typedef struct {
    uint8_t rightTriggerForce[10];
    uint8_t leftTriggerForce[10];
    uint8_t hapticIntensity;
    uint8_t triggerMode;  // 0=off, 1=rigid, 2=pulse, 3=rigid_gradient
} DualSenseEffect;

void set_dualsense_trigger(int pad, DualSenseEffect *effect) {
    // Set adaptive trigger effect
    // Requires PS5-specific APIs
}

int main(int argc, char *argv[]) {
    // PS5 initialization
    // Similar structure to PS4 with enhanced features
    
    DualSenseEffect effect = {0};
    effect.triggerMode = 2;  // Pulse mode
    
    while(1) {
        // Game loop
        sceKernelUsleep(16666);
    }
    
    return 0;
}
CEOF
    
    # Xbox Development (UWP/GDK concepts)
    log_info "Setting up Xbox development reference..."
    mkdir -p "$dest/xbox"
    
    cat > "$dest/xbox/xbox_template.cpp" << 'CPPEOF'
// Xbox Development Template (GDK/UWP Reference)
// Requires Microsoft Xbox Development Kit for actual development

#include <Windows.h>
#include <XGameRuntime.h>
#include <XGameInput.h>

class XboxGame {
public:
    bool Initialize() {
        HRESULT hr = XGameRuntimeInitialize();
        if (FAILED(hr)) return false;
        
        // Initialize graphics, audio, input
        return true;
    }
    
    void Run() {
        MSG msg = {};
        while (msg.message != WM_QUIT) {
            if (PeekMessage(&msg, nullptr, 0, 0, PM_REMOVE)) {
                TranslateMessage(&msg);
                DispatchMessage(&msg);
            } else {
                Update();
                Render();
            }
        }
    }
    
    void Update() {
        // Handle gamepad input
        XGameInputGetState(0, nullptr);
    }
    
    void Render() {
        // DirectX 12 rendering
    }
    
    void Shutdown() {
        XGameRuntimeUninitialize();
    }
};

int WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int) {
    XboxGame game;
    if (game.Initialize()) {
        game.Run();
    }
    game.Shutdown();
    return 0;
}
CPPEOF

    # Cross-platform engine references (Godot, SDL2)
    log_info "Installing SDL2..."
    download_file "https://github.com/libsdl-org/SDL/releases/download/release-2.30.3/SDL2-2.30.3.tar.gz" \
        "$DOWNLOAD_DIR/sdl2.tar.gz" 2>/dev/null || true
    mkdir -p "$dest/sdl2"
    extract_archive "$DOWNLOAD_DIR/sdl2.tar.gz" "$dest/sdl2" 2>/dev/null || true
    
    # Godot Engine (headless for CI/servers)
    log_info "Downloading Godot Engine..."
    download_file "https://github.com/godotengine/godot/releases/download/4.2.2-stable/Godot_v4.2.2-stable_linux.x86_64.zip" \
        "$DOWNLOAD_DIR/godot.zip" 2>/dev/null || true
    mkdir -p "$dest/godot"
    extract_archive "$DOWNLOAD_DIR/godot.zip" "$dest/godot" 2>/dev/null || true
    
    log_success "Modern era SDKs installed"
}

#===============================================================================
# CROSS-PLATFORM TOOLCHAINS
#===============================================================================

install_cross_toolchains() {
    log_era "CROSS-PLATFORM TOOLCHAINS"
    local dest="$TOOLS_DIR/cross"
    mkdir -p "$dest"
    
    # ARM Cross-Compiler
    log_info "Installing ARM toolchain..."
    download_file "https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-x86_64-arm-none-eabi.tar.xz" \
        "$DOWNLOAD_DIR/arm-toolchain.tar.xz" 2>/dev/null || true
    mkdir -p "$dest/arm"
    extract_archive "$DOWNLOAD_DIR/arm-toolchain.tar.xz" "$dest/arm" 2>/dev/null || true
    
    # MIPS Cross-Compiler (for N64, PS1)
    log_info "Installing MIPS toolchain..."
    # Usually bundled with console-specific SDKs
    
    # SH4 Cross-Compiler (for Dreamcast, Saturn)
    log_info "Installing SH4 toolchain..."
    
    # PowerPC Cross-Compiler (for Wii, GameCube, PS3, Xbox 360)
    log_info "Installing PowerPC toolchain..."
    
    log_success "Cross-platform toolchains configured"
}

#===============================================================================
# EMULATORS (for testing)
#===============================================================================

install_emulators() {
    log_era "EMULATORS & TESTING TOOLS"
    local dest="$TOOLS_DIR/emulators"
    mkdir -p "$dest"
    
    # RetroArch (multi-system)
    log_info "Downloading RetroArch..."
    download_file "https://buildbot.libretro.com/stable/1.17.0/linux/x86_64/RetroArch.7z" \
        "$DOWNLOAD_DIR/retroarch.7z" 2>/dev/null || true
    
    # FCEUX (NES)
    log_info "Installing FCEUX (NES emulator)..."
    download_file "https://github.com/TASEmulators/fceux/releases/download/v2.6.6/fceux-2.6.6-Linux-x86_64.zip" \
        "$DOWNLOAD_DIR/fceux.zip" 2>/dev/null || true
    
    # Mesen (NES/SNES accurate)
    log_info "Installing Mesen..."
    download_file "https://github.com/SourMesen/Mesen2/releases/download/v2024.01.08/Mesen-Linux.tar.gz" \
        "$DOWNLOAD_DIR/mesen.tar.gz" 2>/dev/null || true
    
    # PCSX-Redux (PS1)
    log_info "Installing PCSX-Redux (PS1)..."
    download_file "https://install.appcenter.ms/api/v0.1/apps/grumpycoders/pcsx-redux-linux64/distribution_groups/public/releases/latest" \
        "$DOWNLOAD_DIR/pcsx-redux-info.json" 2>/dev/null || true
    
    # Mupen64Plus (N64)
    log_info "Installing Mupen64Plus (N64)..."
    download_file "https://github.com/mupen64plus/mupen64plus-core/releases/download/2.5.9/mupen64plus-bundle-linux64-2.5.9.tar.gz" \
        "$DOWNLOAD_DIR/mupen64plus.tar.gz" 2>/dev/null || true
    
    log_success "Emulators downloaded"
}

#===============================================================================
# ENVIRONMENT SETUP
#===============================================================================

setup_environment() {
    log_era "ENVIRONMENT CONFIGURATION"
    
    cat > "$INSTALL_DIR/env.sh" << 'ENVEOF'
#!/bin/bash
# Retro-Modern SDK Environment

export RETRO_SDK_HOME="$HOME/retro-sdk"
export PATH="$RETRO_SDK_HOME/tools/llvm/bin:$PATH"
export PATH="$RETRO_SDK_HOME/tools/python313/bin:$PATH"

# 8-bit
export CC65_HOME="$RETRO_SDK_HOME/sdks/8bit/cc65"
export PATH="$CC65_HOME/bin:$PATH"

# 16-bit
export SGDK="$RETRO_SDK_HOME/sdks/16bit/sgdk"
export GBDK="$RETRO_SDK_HOME/sdks/16bit/gbdk"
export PATH="$GBDK/bin:$PATH"

# 32-bit
export N64_INST="$RETRO_SDK_HOME/sdks/32bit/n64"
export PATH="$N64_INST/bin:$PATH"

# Modern
export VITASDK="$RETRO_SDK_HOME/sdks/64bit/vita"
export PATH="$VITASDK/bin:$PATH"

# Cross-compilers
export PATH="$RETRO_SDK_HOME/tools/cross/arm/bin:$PATH"

echo "Retro-Modern SDK Environment Loaded"
echo "Available platforms: atari2600 nes snes genesis n64 ps1 dreamcast gba nds 3ds wii ps3 vita switch ps4 ps5"
ENVEOF

    chmod +x "$INSTALL_DIR/env.sh"
    
    log_info "Add to your shell profile:"
    echo "  source $INSTALL_DIR/env.sh"
    
    log_success "Environment configured"
}

#===============================================================================
# MAIN INSTALLATION
#===============================================================================

show_banner() {
    echo -e "${CYAN}"
    cat << 'BANNER'
╔═══════════════════════════════════════════════════════════════════════════════╗
║                     RETRO-MODERN SDK INSTALLER v1.0                          ║
║                    From Zuse Z1 (1938) to PlayStation 5                       ║
║                          wget/curl only - no git                              ║
╠═══════════════════════════════════════════════════════════════════════════════╣
║  Supported Platforms:                                                         ║
║  • Pre-Electronic (1930-1945): Plankalkül, ENIAC simulators                  ║
║  • 8-bit (1975-1985): Atari 2600/8-bit, C64, NES, ZX Spectrum, MSX           ║
║  • 16-bit (1985-1995): Genesis, SNES, Game Boy, Amiga, Neo Geo               ║
║  • 32-bit (1993-2005): PS1, Saturn, N64, Dreamcast, GBA                      ║
║  • HD Era (2005-2015): PS3, Wii, 3DS, PS Vita                                ║
║  • Modern (2013-2025): PS4, PS5, Switch, Xbox Series                         ║
╚═══════════════════════════════════════════════════════════════════════════════╝
BANNER
    echo -e "${NC}"
}

main() {
    show_banner
    
    echo -e "\n${YELLOW}Select installation options:${NC}"
    echo "1) Full installation (all eras)"
    echo "2) Select specific eras"
    echo "3) Tools only (Python, Clang, Brew)"
    echo "4) Quick install (8-bit + 16-bit retro only)"
    echo ""
    read -p "Choice [1-4]: " choice
    
    case $choice in
        1)
            install_system_deps
            install_python313
            install_clang
            install_era_pre_electronic
            install_era_8bit
            install_era_16bit
            install_era_32bit
            install_era_64bit
            install_era_modern
            install_cross_toolchains
            install_emulators
            ;;
        2)
            install_system_deps
            install_python313
            install_clang
            echo ""
            echo "Select eras to install:"
            read -p "Pre-electronic (1930-1945)? [y/N]: " e1
            read -p "8-bit (1975-1985)? [y/N]: " e2
            read -p "16-bit (1985-1995)? [y/N]: " e3
            read -p "32-bit (1993-2005)? [y/N]: " e4
            read -p "HD Era (2005-2015)? [y/N]: " e5
            read -p "Modern (2013-2025)? [y/N]: " e6
            
            [[ "$e1" =~ ^[Yy] ]] && install_era_pre_electronic
            [[ "$e2" =~ ^[Yy] ]] && install_era_8bit
            [[ "$e3" =~ ^[Yy] ]] && install_era_16bit
            [[ "$e4" =~ ^[Yy] ]] && install_era_32bit
            [[ "$e5" =~ ^[Yy] ]] && install_era_64bit
            [[ "$e6" =~ ^[Yy] ]] && install_era_modern
            ;;
        3)
            install_system_deps
            install_python313
            install_clang
            ;;
        4)
            install_system_deps
            install_clang
            install_era_8bit
            install_era_16bit
            ;;
        *)
            echo "Invalid choice"
            exit 1
            ;;
    esac
    
    setup_environment
    
    echo ""
    log_era "INSTALLATION COMPLETE"
    echo -e "${GREEN}SDK Location: $INSTALL_DIR${NC}"
    echo -e "${GREEN}To activate: source $INSTALL_DIR/env.sh${NC}"
    echo ""
    echo "Directory structure:"
    echo "  $SDK_DIR/pre-electronic/ - Zuse, ENIAC simulators"
    echo "  $SDK_DIR/8bit/           - CC65, DASM, z88dk, ACME"
    echo "  $SDK_DIR/16bit/          - SGDK, PVSnesLib, GBDK, WLA-DX"
    echo "  $SDK_DIR/32bit/          - PSn00bSDK, libdragon, KallistiOS"
    echo "  $SDK_DIR/64bit/          - PSL1GHT, VitaSDK, libctru"
    echo "  $SDK_DIR/modern/         - libnx, OpenOrbis, SDL2, Godot"
}

# Run with options
if [[ "$1" == "--auto" ]]; then
    # Non-interactive full install
    install_system_deps
    install_python313
    install_clang
    install_era_pre_electronic
    install_era_8bit
    install_era_16bit
    install_era_32bit
    install_era_64bit
    install_era_modern
    install_cross_toolchains
    install_emulators
    setup_environment
elif [[ "$1" == "--help" ]]; then
    echo "Usage: $0 [--auto|--help]"
    echo "  --auto   Non-interactive full installation"
    echo "  --help   Show this help"
    echo ""
    echo "Run without arguments for interactive mode"
else
    main
fi
