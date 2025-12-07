@echo off
setlocal EnableDelayedExpansion
title CatGet 4K Ultra Installer - Team Flames
color 0A
chcp 65001 >nul 2>&1

:: ============================================================================
:: CATGET 4K ULTRA INSTALLER - COMPREHENSIVE WINGET COLLECTION
:: 1930+ Packages Edition - NO VISUAL STUDIO
:: Team Flames / Samsoft / Flames Co.
:: ============================================================================

echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║  CATGET 4K ULTRA INSTALLER - 1930+ PACKAGES                           ║
echo  ║  Comprehensive Dev Tools Collection - NO VISUAL STUDIO                ║
echo  ║  Team Flames / Samsoft / Flames Co.                                   ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.

:: Check admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Run as Administrator for best results
)

:: Check winget
where winget >nul 2>&1
if %errorlevel% neq 0 (
    echo [X] winget not found! Install from: https://aka.ms/getwinget
    exit /b 1
)

:: Pre-accept all agreements
winget list >nul 2>&1

echo [*] Starting MEGA auto-install at %date% %time%
echo [*] This will take a VERY LONG time - grab several coffees
echo.

:: ============================================================================
:: C/C++ COMPILERS & TOOLCHAINS (NO VISUAL STUDIO)
:: ============================================================================
echo ████ C/C++ COMPILERS ^& TOOLCHAINS ████
winget install -e --id MSYS2.MSYS2 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id LLVM.LLVM --silent --accept-package-agreements --accept-source-agreements
winget install -e --id GnuWin32.Make --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Arm.GnuToolchain --silent --accept-package-agreements --accept-source-agreements
winget install -e --id TDM-GCC.TDM-GCC-64 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id LLVM.LLD --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: RUST
:: ============================================================================
echo ████ RUST ████
winget install -e --id Rustlang.Rustup --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: GO
:: ============================================================================
echo ████ GO ████
winget install -e --id GoLang.Go --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: ZIG
:: ============================================================================
echo ████ ZIG ████
winget install -e --id zig.zig --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: D LANGUAGE
:: ============================================================================
echo ████ D LANGUAGE ████
winget install -e --id dlang.dmd --silent --accept-package-agreements --accept-source-agreements
winget install -e --id dlang.ldc --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: PASCAL / DELPHI
:: ============================================================================
echo ████ PASCAL / DELPHI ████
winget install -e --id FreePascal.FreePascalCompiler --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Lazarus.Lazarus --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: .NET / C# / F#
:: ============================================================================
echo ████ .NET ECOSYSTEM ████
winget install -e --id Microsoft.DotNet.SDK.8 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.DotNet.SDK.7 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.DotNet.SDK.6 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.DotNet.Runtime.8 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.DotNet.AspNetCore.8 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.DotNet.DesktopRuntime.8 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Mono.Mono --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: JAVA / JVM LANGUAGES
:: ============================================================================
echo ████ JAVA / JVM ████
winget install -e --id Microsoft.OpenJDK.21 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.OpenJDK.17 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.OpenJDK.11 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id EclipseAdoptium.Temurin.21.JDK --silent --accept-package-agreements --accept-source-agreements
winget install -e --id EclipseAdoptium.Temurin.17.JDK --silent --accept-package-agreements --accept-source-agreements
winget install -e --id EclipseAdoptium.Temurin.11.JDK --silent --accept-package-agreements --accept-source-agreements
winget install -e --id EclipseAdoptium.Temurin.8.JDK --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Amazon.Corretto.21 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Amazon.Corretto.17 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Amazon.Corretto.11 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Amazon.Corretto.8 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Oracle.JDK.21 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Oracle.JavaRuntimeEnvironment --silent --accept-package-agreements --accept-source-agreements
winget install -e --id JetBrains.Kotlin.Compiler --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Scala.Scala.3 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Apache.Groovy.4 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Clojure.Clojure --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Apache.Maven --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Apache.Ant --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Gradle.Gradle --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: SWIFT
:: ============================================================================
echo ████ SWIFT ████
winget install -e --id Swift.Toolchain --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: HASKELL / FUNCTIONAL
:: ============================================================================
echo ████ HASKELL / FUNCTIONAL ████
winget install -e --id Haskell.GHCup --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Haskell.Cabal --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Haskell.Stack --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ocaml.opam --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Erlang.ErlangOTP --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ElixirLang.Elixir --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: MODERN ALTERNATIVE LANGUAGES
:: ============================================================================
echo ████ MODERN ALTERNATIVE LANGUAGES ████
winget install -e --id odin-lang.Odin --silent --accept-package-agreements --accept-source-agreements
winget install -e --id nim-lang.nim --silent --accept-package-agreements --accept-source-agreements
winget install -e --id vlang.vlang --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Crystal.Crystal --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: PYTHON
:: ============================================================================
echo ████ PYTHON ████
winget install -e --id Python.Python.3.13 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Python.Python.3.12 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Python.Python.3.11 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Python.Python.3.10 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Python.Python.3.9 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Python.Python.3.8 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Python.Python.2 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Anaconda.Anaconda3 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Anaconda.Miniconda3 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id astral-sh.uv --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Python.Launcher --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: RUBY
:: ============================================================================
echo ████ RUBY ████
winget install -e --id RubyInstallerTeam.RubyWithDevKit.3.3 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id RubyInstallerTeam.RubyWithDevKit.3.2 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id RubyInstallerTeam.RubyWithDevKit.3.1 --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: PERL
:: ============================================================================
echo ████ PERL ████
winget install -e --id StrawberryPerl.StrawberryPerl --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: JAVASCRIPT / NODE / RUNTIMES
:: ============================================================================
echo ████ JAVASCRIPT RUNTIMES ████
winget install -e --id OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements
winget install -e --id OpenJS.NodeJS --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Schniz.fnm --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Volta.Volta --silent --accept-package-agreements --accept-source-agreements
winget install -e --id CoreyButler.NVMforWindows --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Oven-sh.Bun --silent --accept-package-agreements --accept-source-agreements
winget install -e --id DenoLand.Deno --silent --accept-package-agreements --accept-source-agreements
winget install -e --id pnpm.pnpm --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Yarn.Yarn --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: PHP
:: ============================================================================
echo ████ PHP ████
winget install -e --id PHP.PHP --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Composer.Composer --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ApacheFriends.Xampp.8.2 --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: TCL / LUA
:: ============================================================================
echo ████ TCL / LUA ████
winget install -e --id ActiveState.ActiveTcl --silent --accept-package-agreements --accept-source-agreements
winget install -e --id DEVCOM.Lua --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: POWERSHELL / SHELLS
:: ============================================================================
echo ████ SHELLS ████
winget install -e --id Microsoft.PowerShell --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Nushell.Nushell --silent --accept-package-agreements --accept-source-agreements
winget install -e --id junegunn.fzf --silent --accept-package-agreements --accept-source-agreements
winget install -e --id sharkdp.bat --silent --accept-package-agreements --accept-source-agreements
winget install -e --id sharkdp.fd --silent --accept-package-agreements --accept-source-agreements
winget install -e --id BurntSushi.ripgrep.MSVC --silent --accept-package-agreements --accept-source-agreements
winget install -e --id dandavison.delta --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ajeetdsouza.zoxide --silent --accept-package-agreements --accept-source-agreements
winget install -e --id eza-community.eza --silent --accept-package-agreements --accept-source-agreements
winget install -e --id starship.starship --silent --accept-package-agreements --accept-source-agreements
winget install -e --id wez.wezterm --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Alacritty.Alacritty --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: DATA SCIENCE / MATH
:: ============================================================================
echo ████ DATA SCIENCE / MATH ████
winget install -e --id Julialang.Julia --silent --accept-package-agreements --accept-source-agreements
winget install -e --id RProject.R --silent --accept-package-agreements --accept-source-agreements
winget install -e --id RProject.Rtools --silent --accept-package-agreements --accept-source-agreements
winget install -e --id posit.RStudio --silent --accept-package-agreements --accept-source-agreements
winget install -e --id GNU.Octave --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: BUILD SYSTEMS
:: ============================================================================
echo ████ BUILD SYSTEMS ████
winget install -e --id Kitware.CMake --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Ninja-build.Ninja --silent --accept-package-agreements --accept-source-agreements
winget install -e --id mesonbuild.meson --silent --accept-package-agreements --accept-source-agreements
winget install -e --id scons.scons --silent --accept-package-agreements --accept-source-agreements
winget install -e --id xmake-io.xmake --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: VERSION CONTROL
:: ============================================================================
echo ████ VERSION CONTROL ████
winget install -e --id Git.Git --silent --accept-package-agreements --accept-source-agreements
winget install -e --id GitHub.GitLFS --silent --accept-package-agreements --accept-source-agreements
winget install -e --id GitHub.cli --silent --accept-package-agreements --accept-source-agreements
winget install -e --id GitHub.GitHubDesktop --silent --accept-package-agreements --accept-source-agreements
winget install -e --id GitExtensionsTeam.GitExtensions --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Tortoisegit.Tortoisegit --silent --accept-package-agreements --accept-source-agreements
winget install -e --id TortoiseSVN.TortoiseSVN --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Mercurial.Mercurial --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Apache.Subversion --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Axosoft.GitKraken --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Atlassian.Sourcetree --silent --accept-package-agreements --accept-source-agreements
winget install -e --id JesseDuffield.lazygit --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: CONTAINERS & VIRTUALIZATION
:: ============================================================================
echo ████ CONTAINERS ^& VIRTUALIZATION ████
winget install -e --id Docker.DockerDesktop --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Kubernetes.kubectl --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Helm.Helm --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Kubernetes.minikube --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Hashicorp.Vagrant --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Hashicorp.Terraform --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Hashicorp.Packer --silent --accept-package-agreements --accept-source-agreements
winget install -e --id RedHat.Podman --silent --accept-package-agreements --accept-source-agreements
winget install -e --id RedHat.Podman-Desktop --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Oracle.VirtualBox --silent --accept-package-agreements --accept-source-agreements
winget install -e --id QEMU.QEMU --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: ARCHIVE UTILITIES
:: ============================================================================
echo ████ ARCHIVE UTILITIES ████
winget install -e --id 7zip.7zip --silent --accept-package-agreements --accept-source-agreements
winget install -e --id RARLab.WinRAR --silent --accept-package-agreements --accept-source-agreements
winget install -e --id PeaZip.PeaZip --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: ASSEMBLERS & GNU TOOLS
:: ============================================================================
echo ████ ASSEMBLERS ^& GNU TOOLS ████
winget install -e --id NASM.NASM --silent --accept-package-agreements --accept-source-agreements
winget install -e --id GnuWin32.Grep --silent --accept-package-agreements --accept-source-agreements
winget install -e --id GnuWin32.Gawk --silent --accept-package-agreements --accept-source-agreements
winget install -e --id GnuWin32.Sed --silent --accept-package-agreements --accept-source-agreements
winget install -e --id GnuWin32.CoreUtils --silent --accept-package-agreements --accept-source-agreements
winget install -e --id GnuWin32.DiffUtils --silent --accept-package-agreements --accept-source-agreements
winget install -e --id GnuWin32.Bison --silent --accept-package-agreements --accept-source-agreements
winget install -e --id GnuWin32.Flex --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: EMULATORS - RETRO GAMING
:: ============================================================================
echo ████ EMULATORS - RETRO GAMING ████
winget install -e --id Libretro.RetroArch --silent --accept-package-agreements --accept-source-agreements
winget install -e --id MAMEDev.MAME --silent --accept-package-agreements --accept-source-agreements
winget install -e --id DolphinEmulator.Dolphin --silent --accept-package-agreements --accept-source-agreements
winget install -e --id PCSX2Team.PCSX2 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id PPSSPPTeam.PPSSPP --silent --accept-package-agreements --accept-source-agreements
winget install -e --id joncampbell123.DOSBox-X --silent --accept-package-agreements --accept-source-agreements
winget install -e --id DOSBox.DOSBox --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Stella.Stella --silent --accept-package-agreements --accept-source-agreements
winget install -e --id xemu.xemu --silent --accept-package-agreements --accept-source-agreements
winget install -e --id melonDS.melonDS --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Cemu.Cemu --silent --accept-package-agreements --accept-source-agreements
winget install -e --id DuckStation.DuckStation --silent --accept-package-agreements --accept-source-agreements
winget install -e --id RPCS3.RPCS3 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Vita3K.Vita3K --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Ryujinx.Ryujinx --silent --accept-package-agreements --accept-source-agreements
winget install -e --id mgba-emu.mGBA --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Snes9x.Snes9x --silent --accept-package-agreements --accept-source-agreements
winget install -e --id BizHawk.BizHawk --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ScummVM.ScummVM --silent --accept-package-agreements --accept-source-agreements
winget install -e --id simple64.simple64 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id 86Box.86Box --silent --accept-package-agreements --accept-source-agreements
winget install -e --id WinUAE.WinUAE --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Hatari.Hatari --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: IDEs & CODE EDITORS
:: ============================================================================
echo ████ IDEs ^& CODE EDITORS ████
winget install -e --id Microsoft.VisualStudioCode --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VisualStudioCode.Insiders --silent --accept-package-agreements --accept-source-agreements
winget install -e --id vscodium.vscodium --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Notepad++.Notepad++ --silent --accept-package-agreements --accept-source-agreements
winget install -e --id SublimeHQ.SublimeText.4 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id SublimeHQ.SublimeMerge --silent --accept-package-agreements --accept-source-agreements
winget install -e --id vim.vim --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Neovim.Neovim --silent --accept-package-agreements --accept-source-agreements
winget install -e --id GNU.Emacs --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Helix.Helix --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Lapce.Lapce --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Zed.Zed --silent --accept-package-agreements --accept-source-agreements
winget install -e --id geany.geany --silent --accept-package-agreements --accept-source-agreements
winget install -e --id CodeBlocks.CodeBlocks --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: JETBRAINS IDEs
:: ============================================================================
echo ████ JETBRAINS IDEs ████
winget install -e --id JetBrains.Toolbox --silent --accept-package-agreements --accept-source-agreements
winget install -e --id JetBrains.IntelliJIDEA.Community --silent --accept-package-agreements --accept-source-agreements
winget install -e --id JetBrains.PyCharm.Community --silent --accept-package-agreements --accept-source-agreements
winget install -e --id JetBrains.WebStorm --silent --accept-package-agreements --accept-source-agreements
winget install -e --id JetBrains.CLion --silent --accept-package-agreements --accept-source-agreements
winget install -e --id JetBrains.GoLand --silent --accept-package-agreements --accept-source-agreements
winget install -e --id JetBrains.Rider --silent --accept-package-agreements --accept-source-agreements
winget install -e --id JetBrains.RubyMine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id JetBrains.PhpStorm --silent --accept-package-agreements --accept-source-agreements
winget install -e --id JetBrains.DataGrip --silent --accept-package-agreements --accept-source-agreements
winget install -e --id JetBrains.Fleet --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: ECLIPSE IDEs
:: ============================================================================
echo ████ ECLIPSE IDEs ████
winget install -e --id EclipseFoundation.EclipseIDE.Java --silent --accept-package-agreements --accept-source-agreements
winget install -e --id EclipseFoundation.EclipseIDE.CPP --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: GAME ENGINES & DEVELOPMENT
:: ============================================================================
echo ████ GAME ENGINES ████
winget install -e --id GodotEngine.GodotEngine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id GodotEngine.GodotEngine.Mono --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Unity.UnityHub --silent --accept-package-agreements --accept-source-agreements
winget install -e --id EpicGames.EpicGamesLauncher --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Defold.Defold --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: ANDROID DEVELOPMENT
:: ============================================================================
echo ████ ANDROID DEVELOPMENT ████
winget install -e --id Google.AndroidStudio --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Google.PlatformTools --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: REVERSE ENGINEERING & ROM TOOLS
:: ============================================================================
echo ████ REVERSE ENGINEERING ████
winget install -e --id MHNexus.HxD --silent --accept-package-agreements --accept-source-agreements
winget install -e --id WerWolv.ImHex --silent --accept-package-agreements --accept-source-agreements
winget install -e --id NSA.Ghidra --silent --accept-package-agreements --accept-source-agreements
winget install -e --id x64dbg.x64dbg --silent --accept-package-agreements --accept-source-agreements
winget install -e --id rizin.cutter --silent --accept-package-agreements --accept-source-agreements
winget install -e --id REALiX.HWiNFO --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Sysinternals.ProcessExplorer --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Sysinternals.ProcessMonitor --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Sysinternals.Autoruns --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Sysinternals.TCPView --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: TILE EDITORS & 2D TOOLS (ROM HACKING)
:: ============================================================================
echo ████ TILE EDITORS ^& 2D TOOLS ████
winget install -e --id Tiled.Tiled --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Aseprite.Aseprite --silent --accept-package-agreements --accept-source-agreements
winget install -e --id LDTK.LDTK --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: GRAPHICS - IMAGE EDITING
:: ============================================================================
echo ████ GRAPHICS - IMAGE EDITING ████
winget install -e --id GIMP.GIMP --silent --accept-package-agreements --accept-source-agreements
winget install -e --id KDE.Krita --silent --accept-package-agreements --accept-source-agreements
winget install -e --id LibreSprite.LibreSprite --silent --accept-package-agreements --accept-source-agreements
winget install -e --id dotPDN.PaintDotNet --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Inkscape.Inkscape --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ImageMagick.ImageMagick --silent --accept-package-agreements --accept-source-agreements
winget install -e --id darktable.darktable --silent --accept-package-agreements --accept-source-agreements
winget install -e --id RawTherapee.RawTherapee --silent --accept-package-agreements --accept-source-agreements
winget install -e --id digikam.digikam --silent --accept-package-agreements --accept-source-agreements
winget install -e --id JGraph.Draw --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Figma.Figma --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Lunacy.Lunacy --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Canva.Canva --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: GRAPHICS - 3D
:: ============================================================================
echo ████ GRAPHICS - 3D ████
winget install -e --id BlenderFoundation.Blender --silent --accept-package-agreements --accept-source-agreements
winget install -e --id BlenderFoundation.Blender.LTS --silent --accept-package-agreements --accept-source-agreements
winget install -e --id FreeCAD.FreeCAD --silent --accept-package-agreements --accept-source-agreements
winget install -e --id OpenSCAD.OpenSCAD --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Wings3D.Wings3D --silent --accept-package-agreements --accept-source-agreements
winget install -e --id MagicaVoxel.MagicaVoxel --silent --accept-package-agreements --accept-source-agreements
winget install -e --id blockbench.blockbench --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: AUDIO PRODUCTION
:: ============================================================================
echo ████ AUDIO PRODUCTION ████
winget install -e --id Audacity.Audacity --silent --accept-package-agreements --accept-source-agreements
winget install -e --id LMMS.LMMS --silent --accept-package-agreements --accept-source-agreements
winget install -e --id OpenMPT.OpenMPT --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Ardour.Ardour --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Cockos.REAPER --silent --accept-package-agreements --accept-source-agreements
winget install -e --id MuseScore.MuseScore --silent --accept-package-agreements --accept-source-agreements
winget install -e --id MilkyTracker.MilkyTracker --silent --accept-package-agreements --accept-source-agreements
winget install -e --id foobar2000.foobar2000 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id AIMP.AIMP --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: VIDEO EDITING & STREAMING
:: ============================================================================
echo ████ VIDEO EDITING ^& STREAMING ████
winget install -e --id Gyan.FFmpeg --silent --accept-package-agreements --accept-source-agreements
winget install -e --id OBSProject.OBSStudio --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Streamlabs.Streamlabs --silent --accept-package-agreements --accept-source-agreements
winget install -e --id VideoLAN.VLC --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Kdenlive.Kdenlive --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Shotcut.Shotcut --silent --accept-package-agreements --accept-source-agreements
winget install -e --id OpenShot.OpenShot --silent --accept-package-agreements --accept-source-agreements
winget install -e --id HandBrake.HandBrake --silent --accept-package-agreements --accept-source-agreements
winget install -e --id MKVToolNix.MKVToolNix --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ShareX.ShareX --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Greenshot.Greenshot --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Flameshot.Flameshot --silent --accept-package-agreements --accept-source-agreements
winget install -e --id yt-dlp.yt-dlp --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: TERMINALS & CLI UTILITIES
:: ============================================================================
echo ████ TERMINALS ^& CLI UTILITIES ████
winget install -e --id Microsoft.WindowsTerminal --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.WindowsTerminal.Preview --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Eugeny.Tabby --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Mobatek.MobaXterm --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ConEmu.ConEmu --silent --accept-package-agreements --accept-source-agreements
winget install -e --id clink.clink --silent --accept-package-agreements --accept-source-agreements
winget install -e --id WinSCP.WinSCP --silent --accept-package-agreements --accept-source-agreements
winget install -e --id PuTTY.PuTTY --silent --accept-package-agreements --accept-source-agreements
winget install -e --id mRemoteNG.mRemoteNG --silent --accept-package-agreements --accept-source-agreements
winget install -e --id FileZilla.FileZilla.Client --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Cyberduck.Cyberduck --silent --accept-package-agreements --accept-source-agreements
winget install -e --id WinMerge.WinMerge --silent --accept-package-agreements --accept-source-agreements
winget install -e --id MeldMerge.Meld --silent --accept-package-agreements --accept-source-agreements
winget install -e --id JohnMacFarlane.Pandoc --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Curl.Curl --silent --accept-package-agreements --accept-source-agreements
winget install -e --id jqlang.jq --silent --accept-package-agreements --accept-source-agreements
winget install -e --id casey.just --silent --accept-package-agreements --accept-source-agreements
winget install -e --id charmbracelet.glow --silent --accept-package-agreements --accept-source-agreements
winget install -e --id sharkdp.hyperfine --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: SYSTEM UTILITIES
:: ============================================================================
echo ████ SYSTEM UTILITIES ████
winget install -e --id voidtools.Everything --silent --accept-package-agreements --accept-source-agreements
winget install -e --id flux.flux --silent --accept-package-agreements --accept-source-agreements
winget install -e --id REALiX.HWiNFO --silent --accept-package-agreements --accept-source-agreements
winget install -e --id CPUID.CPU-Z --silent --accept-package-agreements --accept-source-agreements
winget install -e --id TechPowerUp.GPU-Z --silent --accept-package-agreements --accept-source-agreements
winget install -e --id CrystalDewWorld.CrystalDiskInfo --silent --accept-package-agreements --accept-source-agreements
winget install -e --id CrystalDewWorld.CrystalDiskMark --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.PowerToys --silent --accept-package-agreements --accept-source-agreements
winget install -e --id AntibodySoftware.WizTree --silent --accept-package-agreements --accept-source-agreements
winget install -e --id JamSoftware.TreeSize.Free --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Piriform.Speccy --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Piriform.Recuva --silent --accept-package-agreements --accept-source-agreements
winget install -e --id RevoUninstaller.RevoUninstaller --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Rufus.Rufus --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Balena.Etcher --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Ventoy.Ventoy --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Bitwarden.Bitwarden --silent --accept-package-agreements --accept-source-agreements
winget install -e --id KeePassXCTeam.KeePassXC --silent --accept-package-agreements --accept-source-agreements
winget install -e --id GnuPG.GnuPG --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: WINDOWS SDK / DEV TOOLS
:: ============================================================================
echo ████ WINDOWS SDK ^& DEV TOOLS ████
winget install -e --id Microsoft.WindowsSDK.10.0.26100 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.WindowsSDK.10.0.22621 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.WindowsSDK.10.0.19041 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.DirectX --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2015+.x64 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2015+.x86 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2013.x64 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2013.x86 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2012.x64 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2012.x86 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2010.x64 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2010.x86 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2008.x64 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2008.x86 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2005.x64 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2005.x86 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.WinDbg --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.NuGet --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: CLOUD CLIs
:: ============================================================================
echo ████ CLOUD CLIs ████
winget install -e --id Microsoft.AzureCLI --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.Azure.StorageExplorer --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Amazon.AWSCLI --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Amazon.SAM-CLI --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Google.CloudSDK --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Vercel.Vercel --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Netlify.NetlifyCLI --silent --accept-package-agreements --accept-source-agreements
winget install -e --id DigitalOcean.Doctl --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Heroku.HerokuCLI --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Cloudflare.Wrangler --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: NETWORK / SECURITY TOOLS
:: ============================================================================
echo ████ NETWORK ^& SECURITY TOOLS ████
winget install -e --id WiresharkFoundation.Wireshark --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Nmap.Nmap --silent --accept-package-agreements --accept-source-agreements
winget install -e --id AngryIPScanner.AngryIPScanner --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Fiddler.Fiddler.Classic --silent --accept-package-agreements --accept-source-agreements
winget install -e --id mitmproxy.mitmproxy --silent --accept-package-agreements --accept-source-agreements
winget install -e --id RustDesk.RustDesk --silent --accept-package-agreements --accept-source-agreements
winget install -e --id AnyDeskSoftwareGmbH.AnyDesk --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Parsec.Parsec --silent --accept-package-agreements --accept-source-agreements
winget install -e --id OpenVPNTechnologies.OpenVPN --silent --accept-package-agreements --accept-source-agreements
winget install -e --id WireGuard.WireGuard --silent --accept-package-agreements --accept-source-agreements
winget install -e --id tailscale.tailscale --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ZeroTier.ZeroTierOne --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Cloudflare.cloudflared --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: API TOOLS
:: ============================================================================
echo ████ API TOOLS ████
winget install -e --id Insomnia.Insomnia --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Postman.Postman --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Hoppscotch.Hoppscotch --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: DATABASES
:: ============================================================================
echo ████ DATABASES ████
winget install -e --id DBBrowserForSQLite.DBBrowserForSQLite --silent --accept-package-agreements --accept-source-agreements
winget install -e --id PostgreSQL.PostgreSQL.16 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id PostgreSQL.PostgreSQL.15 --silent --accept-package-agreements --accept-source-agreements
winget install -e --id PostgreSQL.pgAdmin --silent --accept-package-agreements --accept-source-agreements
winget install -e --id MariaDB.Server --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Oracle.MySQL --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Oracle.MySQLWorkbench --silent --accept-package-agreements --accept-source-agreements
winget install -e --id HeidiSQL.HeidiSQL --silent --accept-package-agreements --accept-source-agreements
winget install -e --id dbeaver.dbeaver --silent --accept-package-agreements --accept-source-agreements
winget install -e --id MongoDB.Server --silent --accept-package-agreements --accept-source-agreements
winget install -e --id MongoDB.Compass.Full --silent --accept-package-agreements --accept-source-agreements
winget install -e --id MongoDB.Shell --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Redis.Redis --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: WEB SERVERS
:: ============================================================================
echo ████ WEB SERVERS ████
winget install -e --id ApacheLounge.ApacheHTTPD --silent --accept-package-agreements --accept-source-agreements
winget install -e --id nginx.nginx --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Caddy.Caddy --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: BROWSERS
:: ============================================================================
echo ████ BROWSERS ████
winget install -e --id Mozilla.Firefox --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Mozilla.Firefox.DeveloperEdition --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Google.Chrome --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Google.Chrome.Dev --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.Edge --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.Edge.Dev --silent --accept-package-agreements --accept-source-agreements
winget install -e --id BraveSoftware.BraveBrowser --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Opera.Opera --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Opera.OperaGX --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Vivaldi.Vivaldi --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ArcBrowser.Arc --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Floorp.Floorp --silent --accept-package-agreements --accept-source-agreements
winget install -e --id LibreWolf.LibreWolf --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: COMMUNICATION APPS
:: ============================================================================
echo ████ COMMUNICATION APPS ████
winget install -e --id Discord.Discord --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Discord.Discord.PTB --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Discord.Discord.Canary --silent --accept-package-agreements --accept-source-agreements
winget install -e --id SlackTechnologies.Slack --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Telegram.TelegramDesktop --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Element.Element --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.Teams --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Zoom.Zoom --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: OFFICE / PRODUCTIVITY
:: ============================================================================
echo ████ OFFICE / PRODUCTIVITY ████
winget install -e --id TheDocumentFoundation.LibreOffice --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Apache.OpenOffice --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ONLYOFFICE.DesktopEditors --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Notion.Notion --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Obsidian.Obsidian --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Logseq.Logseq --silent --accept-package-agreements --accept-source-agreements
winget install -e --id StandardNotes.StandardNotes --silent --accept-package-agreements --accept-source-agreements
winget install -e --id toeverything.AFFiNE --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Joplin.Joplin --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Zettlr.Zettlr --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Typora.Typora --silent --accept-package-agreements --accept-source-agreements
winget install -e --id MarkText.MarkText --silent --accept-package-agreements --accept-source-agreements
winget install -e --id SumatraPDF.SumatraPDF --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Calibre.Calibre --silent --accept-package-agreements --accept-source-agreements
winget install -e --id PDF-XChange.Editor --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Foxit.FoxitReader --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: GAMING PLATFORMS & LAUNCHERS
:: ============================================================================
echo ████ GAMING PLATFORMS ████
winget install -e --id Valve.Steam --silent --accept-package-agreements --accept-source-agreements
winget install -e --id GOG.Galaxy --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ItchIo.ItchIo --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ElectronicArts.EADesktop --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Ubisoft.Connect --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Amazon.Games --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Playnite.Playnite --silent --accept-package-agreements --accept-source-agreements
winget install -e --id HeroicGamesLauncher.HeroicGamesLauncher --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: TORRENT CLIENTS
:: ============================================================================
echo ████ TORRENT CLIENTS ████
winget install -e --id qBittorrent.qBittorrent --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Transmission.Transmission --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Deluge.Deluge --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: FONTS
:: ============================================================================
echo ████ FONTS ████
winget install -e --id JetBrains.Mono --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Fira.Fira --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: MISCELLANEOUS DEV TOOLS
:: ============================================================================
echo ████ MISCELLANEOUS DEV TOOLS ████
winget install -e --id ajeetdsouza.zoxide --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Lexikos.AutoHotkey --silent --accept-package-agreements --accept-source-agreements
winget install -e --id AutoIt.AutoIt --silent --accept-package-agreements --accept-source-agreements
winget install -e --id WinDirStat.WinDirStat --silent --accept-package-agreements --accept-source-agreements
winget install -e --id CPUID.HWMonitor --silent --accept-package-agreements --accept-source-agreements
winget install -e --id NickeManarin.ScreenToGif --silent --accept-package-agreements --accept-source-agreements
winget install -e --id LizardByte.Sunshine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id hluk.CopyQ --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Ditto.Ditto --silent --accept-package-agreements --accept-source-agreements
winget install -e --id valinet.ExplorerPatcher --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Chris.Titus.Tech.WinUtil --silent --accept-package-agreements --accept-source-agreements

:: ============================================================================
:: DONE
:: ============================================================================
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║  ████ CATGET 4K INSTALLATION COMPLETE ████                            ║
echo  ║  Finished at %date% %time%                                 ║
echo  ║  NO VISUAL STUDIO INSTALLED                                           ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  Restart your terminal or PC to use all tools.
echo.
exit /b 0