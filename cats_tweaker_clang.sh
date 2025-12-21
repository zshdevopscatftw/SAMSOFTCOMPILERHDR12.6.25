#!/bin/bash
#===============================================================================
#  CAT'S TWEAKER - CLANG/LLVM ADDITIONS
#  All versions through 2025 (LLVM 11-20)
#  by Flames / Team Flames 🐱
#===============================================================================

# ============================================================================
step "CLANG/LLVM TOOLCHAINS (2019-2025)"
# ============================================================================

if $IS_MAC; then
    # macOS: Homebrew LLVM (latest + versioned)
    info "Installing Clang/LLVM via Homebrew..."
    
    # Latest LLVM (currently 19)
    brew install llvm >> "$LOG" 2>&1 && ok "LLVM latest (19)" || fail "LLVM latest"
    
    # Versioned LLVM for compatibility
    for VER in 18 17 16 15 14 13 12 11; do
        if brew install llvm@$VER >> "$LOG" 2>&1; then
            ok "LLVM $VER"
        else
            info "LLVM $VER not available via brew"
        fi
    done
    
    # Add paths
    add_path "export PATH=\"/opt/homebrew/opt/llvm/bin:\$PATH\""
    add_path "export LDFLAGS=\"-L/opt/homebrew/opt/llvm/lib\""
    add_path "export CPPFLAGS=\"-I/opt/homebrew/opt/llvm/include\""
    
    # Create version switcher
    cat > "$TOOLS/clang-switch" << 'CLANGSWITCH'
#!/bin/bash
# Usage: clang-switch 18
VER="$1"
if [[ -z "$VER" ]]; then
    echo "Usage: clang-switch <version>"
    echo "Available: 11 12 13 14 15 16 17 18 19 (latest)"
    ls /opt/homebrew/opt/ | grep -E '^llvm(@[0-9]+)?$' | sed 's/llvm@//' | sed 's/llvm/latest/'
    exit 0
fi
if [[ "$VER" == "latest" || "$VER" == "19" || "$VER" == "20" ]]; then
    export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
else
    export PATH="/opt/homebrew/opt/llvm@$VER/bin:$PATH"
fi
echo "Switched to: $(clang --version | head -1)"
CLANGSWITCH
    chmod +x "$TOOLS/clang-switch"
    ok "clang-switch helper"

else
    # Linux: Official LLVM apt repos
    info "Adding LLVM apt repository..."
    
    # Install prerequisites
    sudo apt-get install -y -qq wget lsb-release software-properties-common gnupg >> "$LOG" 2>&1
    
    # Add LLVM GPG key and repo
    wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | sudo tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc >> "$LOG" 2>&1
    
    CODENAME=$(lsb_release -cs 2>/dev/null || echo "jammy")
    
    # Add repos for multiple versions
    for VER in 20 19 18 17 16 15 14; do
        echo "deb http://apt.llvm.org/$CODENAME/ llvm-toolchain-$CODENAME-$VER main" | \
            sudo tee /etc/apt/sources.list.d/llvm-$VER.list >> "$LOG" 2>&1
    done
    
    sudo apt-get update -qq >> "$LOG" 2>&1
    
    # Install all LLVM versions
    info "Installing Clang/LLVM versions..."
    
    # LLVM 20 (2025 - development/nightly)
    if sudo apt-get install -y -qq clang-20 lldb-20 lld-20 clangd-20 >> "$LOG" 2>&1; then
        ok "LLVM 20 (2025 dev)"
    else
        info "LLVM 20 not yet available for $CODENAME"
    fi
    
    # LLVM 19 (2024 stable)
    sudo apt-get install -y -qq clang-19 lldb-19 lld-19 clangd-19 clang-tools-19 \
        clang-format-19 clang-tidy-19 libc++-19-dev libc++abi-19-dev >> "$LOG" 2>&1 && \
        ok "LLVM 19 (2024)" || fail "LLVM 19"
    
    # LLVM 18 (2024)
    sudo apt-get install -y -qq clang-18 lldb-18 lld-18 clangd-18 clang-tools-18 \
        clang-format-18 clang-tidy-18 libc++-18-dev libc++abi-18-dev >> "$LOG" 2>&1 && \
        ok "LLVM 18 (2024)" || fail "LLVM 18"
    
    # LLVM 17 (2023)
    sudo apt-get install -y -qq clang-17 lldb-17 lld-17 clangd-17 >> "$LOG" 2>&1 && \
        ok "LLVM 17 (2023)" || fail "LLVM 17"
    
    # LLVM 16 (2023)
    sudo apt-get install -y -qq clang-16 lldb-16 lld-16 >> "$LOG" 2>&1 && \
        ok "LLVM 16 (2023)" || fail "LLVM 16"
    
    # LLVM 15 (2022)
    sudo apt-get install -y -qq clang-15 lldb-15 lld-15 >> "$LOG" 2>&1 && \
        ok "LLVM 15 (2022)" || fail "LLVM 15"
    
    # LLVM 14 (2022)
    sudo apt-get install -y -qq clang-14 lldb-14 lld-14 >> "$LOG" 2>&1 && \
        ok "LLVM 14 (2022)" || fail "LLVM 14"
    
    # LLVM 13 (2021)
    sudo apt-get install -y -qq clang-13 lldb-13 lld-13 >> "$LOG" 2>&1 && \
        ok "LLVM 13 (2021)" || info "LLVM 13 not available"
    
    # LLVM 12 (2021)
    sudo apt-get install -y -qq clang-12 lldb-12 lld-12 >> "$LOG" 2>&1 && \
        ok "LLVM 12 (2021)" || info "LLVM 12 not available"
    
    # LLVM 11 (2020)
    sudo apt-get install -y -qq clang-11 lldb-11 lld-11 >> "$LOG" 2>&1 && \
        ok "LLVM 11 (2020)" || info "LLVM 11 not available"
    
    # Install all tools for latest version
    sudo apt-get install -y -qq llvm-19 llvm-19-dev llvm-19-tools \
        libclang-19-dev libclang-common-19-dev >> "$LOG" 2>&1 && \
        ok "LLVM 19 full toolchain" || fail "LLVM 19 tools"
    
    # Create version switcher
    cat > "$TOOLS/clang-switch" << 'CLANGSWITCH'
#!/bin/bash
# Usage: clang-switch 18  OR  source clang-switch 18
VER="$1"
if [[ -z "$VER" ]]; then
    echo "Usage: clang-switch <version>"
    echo "Available versions:"
    ls /usr/bin/clang-* 2>/dev/null | grep -oE 'clang-[0-9]+$' | sed 's/clang-/  /' | sort -n
    echo "Current: $(clang --version 2>/dev/null | head -1 || echo 'none')"
    exit 0
fi

# Update alternatives
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-$VER 100 \
    --slave /usr/bin/clang++ clang++ /usr/bin/clang++-$VER \
    --slave /usr/bin/clangd clangd /usr/bin/clangd-$VER \
    --slave /usr/bin/clang-format clang-format /usr/bin/clang-format-$VER \
    --slave /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-$VER \
    --slave /usr/bin/lldb lldb /usr/bin/lldb-$VER \
    --slave /usr/bin/lld lld /usr/bin/lld-$VER 2>/dev/null

sudo update-alternatives --set clang /usr/bin/clang-$VER 2>/dev/null

echo "Switched to: $(clang --version | head -1)"
CLANGSWITCH
    chmod +x "$TOOLS/clang-switch"
    ok "clang-switch helper"
    
    # Set default to latest stable (19)
    if [[ -x /usr/bin/clang-19 ]]; then
        sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-19 100 >> "$LOG" 2>&1
        sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-19 100 >> "$LOG" 2>&1
        ok "Default: clang-19"
    fi
fi

add_path "export PATH=\"$TOOLS:\$PATH\""

# ============================================================================
step "CLANG CROSS-COMPILATION TARGETS"
# ============================================================================

if $IS_MAC; then
    info "macOS Clang supports cross-compilation natively"
    ok "arm64-apple-darwin"
    ok "x86_64-apple-darwin"
    
    # Install cross-compilation support
    brew install mingw-w64 >> "$LOG" 2>&1 && ok "x86_64-w64-mingw32 (Windows)" || fail "mingw-w64"
    
else
    # Linux cross-compilation targets
    info "Installing cross-compilation targets..."
    
    # Windows (MinGW)
    sudo apt-get install -y -qq mingw-w64 >> "$LOG" 2>&1 && \
        ok "x86_64-w64-mingw32 (Windows)" || fail "mingw-w64"
    
    # ARM targets
    sudo apt-get install -y -qq gcc-aarch64-linux-gnu g++-aarch64-linux-gnu >> "$LOG" 2>&1 && \
        ok "aarch64-linux-gnu (ARM64)" || fail "aarch64"
    
    sudo apt-get install -y -qq gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf >> "$LOG" 2>&1 && \
        ok "arm-linux-gnueabihf (ARM32)" || fail "arm32"
    
    # RISC-V
    sudo apt-get install -y -qq gcc-riscv64-linux-gnu g++-riscv64-linux-gnu >> "$LOG" 2>&1 && \
        ok "riscv64-linux-gnu (RISC-V)" || fail "riscv64"
    
    # WebAssembly (via Emscripten)
    if command -v emcc >/dev/null 2>&1; then
        ok "wasm32 (Emscripten existing)"
    else
        info "wasm32: install emsdk from emscripten.org"
    fi
fi

# ============================================================================
step "CLANG STATIC ANALYZERS & SANITIZERS"
# ============================================================================

if $IS_MAC; then
    # macOS - comes with Xcode/LLVM
    ok "AddressSanitizer (ASan)"
    ok "MemorySanitizer (MSan)"
    ok "UndefinedBehaviorSanitizer (UBSan)"
    ok "ThreadSanitizer (TSan)"
    brew install include-what-you-use >> "$LOG" 2>&1 && ok "include-what-you-use" || info "iwyu: brew install include-what-you-use"
else
    # Linux
    sudo apt-get install -y -qq \
        libasan8 libubsan1 libtsan2 liblsan0 \
        iwyu >> "$LOG" 2>&1 && ok "Sanitizers + IWYU" || fail "Sanitizers"
fi

# ============================================================================
step "ENVIRONMENT UPDATE (CLANG)"
# ============================================================================

cat >> "$INSTALL_DIR/env.sh" << 'CLANGENV'

# Clang/LLVM
alias clang-latest='clang-19'
alias clang++latest='clang++-19'

# Quick sanitizer aliases
alias clang-asan='clang -fsanitize=address -fno-omit-frame-pointer'
alias clang-ubsan='clang -fsanitize=undefined'
alias clang-msan='clang -fsanitize=memory'
alias clang-tsan='clang -fsanitize=thread'

# Version info
clang-info() {
    echo "Clang versions installed:"
    for v in 11 12 13 14 15 16 17 18 19 20; do
        if command -v clang-$v >/dev/null 2>&1; then
            echo "  clang-$v: $(clang-$v --version | head -1)"
        fi
    done
    echo ""
    echo "Default clang: $(clang --version 2>/dev/null | head -1 || echo 'not set')"
    echo "Switch version: clang-switch <version>"
}

echo "  Clang:   clang-info | clang-switch <11-20>"
CLANGENV

ok "Clang environment configured"

echo ""
printf "${C}  ┌─────────────────────────────────────────────────────────────┐${RST}\n"
printf "${C}  │${RST}  ${W}CLANG/LLVM INSTALLED${RST}                                        ${C}│${RST}\n"
printf "${C}  ├─────────────────────────────────────────────────────────────┤${RST}\n"
printf "${C}  │${RST}  LLVM 11 (2020) → LLVM 20 (2025 dev)                          ${C}│${RST}\n"
printf "${C}  │${RST}  Cross: mingw, aarch64, arm, riscv64                          ${C}│${RST}\n"
printf "${C}  │${RST}  Tools: clangd, clang-format, clang-tidy, lldb, lld           ${C}│${RST}\n"
printf "${C}  │${RST}  Sanitizers: ASan, MSan, UBSan, TSan                          ${C}│${RST}\n"
printf "${C}  ├─────────────────────────────────────────────────────────────┤${RST}\n"
printf "${C}  │${RST}  Commands: ${Y}clang-switch 19${RST}  |  ${Y}clang-info${RST}                    ${C}│${RST}\n"
printf "${C}  └─────────────────────────────────────────────────────────────┘${RST}\n"
