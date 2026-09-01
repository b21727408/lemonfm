#!/usr/bin/env bash

tool_platform() {
  local os arch
  os="$(uname -s)"
  arch="$(uname -m)"
  case "$os:$arch" in
    Linux:x86_64) printf '%s\n' linux_amd64 ;;
    Linux:aarch64|Linux:arm64) printf '%s\n' linux_arm64 ;;
    Darwin:x86_64) printf '%s\n' darwin_amd64 ;;
    Darwin:arm64) printf '%s\n' darwin_arm64 ;;
    MINGW*:x86_64|MSYS*:x86_64) printf '%s\n' windows_amd64 ;;
    MINGW*:arm64|MSYS*:arm64) printf '%s\n' windows_arm64 ;;
    *) echo "Unsupported tool platform: $os $arch" >&2; return 69 ;;
  esac
}

tool_specification() {
  local name="$1" platform="$2"
  case "$name:$platform" in
    oasdiff:linux_amd64) printf '%s|%s|%s\n' oasdiff_1.28.0_linux_amd64.tar.gz e0ef076f2cf953d922addc04be9c3851cf3ec18f7678d2b94d44cea23dca51b5 tar ;;
    oasdiff:linux_arm64) printf '%s|%s|%s\n' oasdiff_1.28.0_linux_arm64.tar.gz cb15a381472321ac602cc252e65018d03feba7e6449a0854e1181680444d4051 tar ;;
    oasdiff:darwin_amd64|oasdiff:darwin_arm64) printf '%s|%s|%s\n' oasdiff_1.28.0_darwin_all.tar.gz ff76474bf47bfb806d1711aa3e962b8e55570badcd462fa487b80aa532a823db tar ;;
    oasdiff:windows_amd64) printf '%s|%s|%s\n' oasdiff_1.28.0_windows_amd64.tar.gz cef8ec7cdd32ab4ce9c188f9dbb50452a91fa36cc11c8e1dcf340b19282c3ce1 tar ;;
    oasdiff:windows_arm64) printf '%s|%s|%s\n' oasdiff_1.28.0_windows_arm64.tar.gz e097cf94eb1d4cf05b08569f724923d5f0c79c22770faca0f359ec4ac789e77e tar ;;
    gitleaks:linux_amd64) printf '%s|%s|%s\n' gitleaks_8.30.1_linux_x64.tar.gz 551f6fc83ea457d62a0d98237cbad105af8d557003051f41f3e7ca7b3f2470eb tar ;;
    gitleaks:linux_arm64) printf '%s|%s|%s\n' gitleaks_8.30.1_linux_arm64.tar.gz e4a487ee7ccd7d3a7f7ec08657610aa3606637dab924210b3aee62570fb4b080 tar ;;
    gitleaks:darwin_amd64) printf '%s|%s|%s\n' gitleaks_8.30.1_darwin_x64.tar.gz dfe101a4db2255fc85120ac7f3d25e4342c3c20cf749f2c20a18081af1952709 tar ;;
    gitleaks:darwin_arm64) printf '%s|%s|%s\n' gitleaks_8.30.1_darwin_arm64.tar.gz b40ab0ae55c505963e365f271a8d3846efbc170aa17f2607f13df610a9aeb6a5 tar ;;
    gitleaks:windows_amd64) printf '%s|%s|%s\n' gitleaks_8.30.1_windows_x64.zip d29144deff3a68aa93ced33dddf84b7fdc26070add4aa0f4513094c8332afc4e zip ;;
    gitleaks:windows_arm64) printf '%s|%s|%s\n' gitleaks_8.30.1_windows_arm64.zip b95f5e4f5c425cedca7ee203d9afd29597e692c4924a12ed42f970537c72cc0f zip ;;
    *) echo "No pinned $name binary for $platform" >&2; return 69 ;;
  esac
}

resolve_pinned_tool() {
  local name="$1" version base platform specification asset checksum archive url target download actual binary
  case "$name" in
    oasdiff) version=1.28.0; base=https://github.com/oasdiff/oasdiff/releases/download/v1.28.0 ;;
    gitleaks) version=8.30.1; base=https://github.com/gitleaks/gitleaks/releases/download/v8.30.1 ;;
    *) echo "Unknown pinned tool: $name" >&2; return 64 ;;
  esac
  platform="$(tool_platform)"
  specification="$(tool_specification "$name" "$platform")"
  IFS='|' read -r asset checksum archive <<<"$specification"
  binary="$name"
  [[ "$platform" == windows_* ]] && binary="$name.exe"
  target="${LEMON_TOOL_CACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/lemon/tools}/$name-$version-$platform/$binary"
  if [[ -x "$target" || ( "$platform" == windows_* && -f "$target" ) ]]; then
    printf '%s\n' "$target"
    return
  fi
  mkdir -p "$(dirname "$target")"
  download="$target.download"
  url="$base/$asset"
  curl --fail --location --retry 3 --silent --show-error "$url" --output "$download"
  actual="$(sha256sum "$download" | cut -d' ' -f1)"
  if [[ "$actual" != "$checksum" ]]; then
    rm -f "$download"
    echo "$name $version checksum mismatch: expected $checksum, got $actual" >&2
    return 70
  fi
  if [[ "$archive" == tar ]]; then
    tar -xOf "$download" "$binary" >"$target"
  else
    unzip -p "$download" "$binary" >"$target"
  fi
  rm -f "$download"
  chmod +x "$target"
  printf '%s\n' "$target"
}
