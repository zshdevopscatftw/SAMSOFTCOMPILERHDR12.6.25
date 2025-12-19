#!/bin/zsh
set -e

echo "🍎 M4 Pro Python 3.13 Game Dev + ML Setup"
echo "----------------------------------------"

# ---------- Homebrew ----------
if ! command -v brew >/dev/null 2>&1; then
  echo "▶ Installing Homebrew (Apple Silicon)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

# ---------- System deps ----------
echo "▶ Installing system dependencies..."
brew update
brew install python@3.13 cmake pkg-config sdl2 sdl2_image sdl2_mixer sdl2_ttf portaudio

# ---------- Python ----------
echo "▶ Using Python:"
/opt/homebrew/bin/python3.13 --version

# ---------- Virtual environment ----------
ENV_NAME="py313_m4pro"
if [ ! -d "$ENV_NAME" ]; then
  echo "▶ Creating virtual environment: $ENV_NAME"
  /opt/homebrew/bin/python3.13 -m venv "$ENV_NAME"
fi

source "$ENV_NAME/bin/activate"

# ---------- Upgrade pip ----------
pip install --upgrade pip setuptools wheel

# ---------- Game dev stack ----------
echo "▶ Installing game development libraries..."
pip install \
  pygame \
  ursina \
  panda3d \
  moderngl \
  pyopengl \
  pillow \
  sounddevice

# ---------- ML stack (Apple Metal / MPS) ----------
echo "▶ Installing ML libraries (Apple Metal / MPS)..."
pip install \
  numpy \
  scipy \
  matplotlib \
  scikit-learn \
  torch \
  torchvision \
  torchaudio

# ---------- JAX (Metal backend ready) ----------
pip install jax jaxlib

# ---------- Verify ----------
echo "▶ Verifying Metal (MPS) support..."
python - << 'EOF'
import torch
print("PyTorch:", torch.__version__)
print("MPS available:", torch.backends.mps.is_available())
EOF

echo "----------------------------------------"
echo "✅ DONE"
echo "Activate with:"
echo "  source $ENV_NAME/bin/activate"
echo "----------------------------------------"
