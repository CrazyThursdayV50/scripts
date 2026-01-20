#!/bin/bash

# Delta 自动安装脚本
# 支持多种 Linux 发行版和 macOS

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查命令是否存在
check_command() {
    if ! command -v "$1" &> /dev/null; then
        return 1
    fi
    return 0
}

# 检查 Delta 是否已安装
check_delta_installed() {
    if check_command "delta"; then
        print_info "Delta 已经安装，版本信息："
        delta --version
        return 0
    fi
    return 1
}

# 检测操作系统
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # 检测 Linux 发行版
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$ID
            OS_VERSION=$VERSION_ID
        elif [ -f /etc/redhat-release ]; then
            OS="rhel"
        else
            OS="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        OS="unknown"
    fi

    print_info "检测到操作系统: $OS"
}

# Debian/Ubuntu 安装
install_debian() {
    print_info "使用 apt 安装 Delta..."

    # 检查依赖命令
    if ! check_command "apt-get"; then
        print_error "未找到 apt-get 命令，请先安装 apt 包管理器"
        exit 1
    fi

    if ! check_command "curl"; then
        print_warning "未找到 curl 命令，正在安装..."
        sudo apt-get update
        sudo apt-get install -y curl
    fi

    if ! check_command "dpkg"; then
        print_error "未找到 dpkg 命令，无法继续安装"
        exit 1
    fi

    # 下载并安装
    DELTA_VERSION="0.17.0"
    ARCH=$(dpkg --print-architecture)
    DEB_FILE="git-delta_${DELTA_VERSION}_${ARCH}.deb"

    print_info "下载 Delta ${DELTA_VERSION}..."
    curl -LO "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/${DEB_FILE}"

    print_info "安装 Delta..."
    sudo dpkg -i "$DEB_FILE"

    # 清理下载文件
    rm -f "$DEB_FILE"
}

# RedHat/Fedora/CentOS 安装
install_redhat() {
    print_info "使用 dnf/yum 安装 Delta..."

    # 检查包管理器
    if check_command "dnf"; then
        PKG_MGR="dnf"
    elif check_command "yum"; then
        PKG_MGR="yum"
    else
        print_error "未找到 dnf 或 yum 命令，请先安装包管理器"
        exit 1
    fi

    if ! check_command "curl"; then
        print_warning "未找到 curl 命令，正在安装..."
        sudo $PKG_MGR install -y curl
    fi

    # 下载并安装
    DELTA_VERSION="0.17.0"
    ARCH=$(uname -m)
    RPM_FILE="git-delta-${DELTA_VERSION}-1.${ARCH}.rpm"

    print_info "下载 Delta ${DELTA_VERSION}..."
    curl -LO "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/${RPM_FILE}"

    print_info "安装 Delta..."
    sudo $PKG_MGR install -y "$RPM_FILE"

    # 清理下载文件
    rm -f "$RPM_FILE"
}

# Arch Linux 安装
install_arch() {
    print_info "使用 pacman 安装 Delta..."

    if ! check_command "pacman"; then
        print_error "未找到 pacman 命令，请先安装 pacman 包管理器"
        exit 1
    fi

    sudo pacman -S --noconfirm git-delta
}

# macOS 安装
install_macos() {
    print_info "使用 Homebrew 安装 Delta..."

    if ! check_command "brew"; then
        print_error "未找到 brew 命令，请先安装 Homebrew"
        print_info "安装命令: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi

    brew install git-delta
}

# 使用 Cargo 安装（通用方法）
install_cargo() {
    print_info "使用 Cargo 安装 Delta..."

    if ! check_command "cargo"; then
        print_error "未找到 cargo 命令，请先安装 Rust"
        print_info "安装命令: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
        exit 1
    fi

    cargo install git-delta
}

# 主函数
main() {
    print_info "开始检查 Delta 安装状态..."

    # 步骤 1: 检查是否已安装
    if check_delta_installed; then
        read -p "Delta 已安装，是否重新安装？(y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "退出安装"
            exit 0
        fi
    fi

    # 步骤 2: 检测系统并安装
    detect_os

    case $OS in
        ubuntu|debian)
            install_debian
            ;;
        fedora|rhel|centos)
            install_redhat
            ;;
        arch|manjaro)
            install_arch
            ;;
        macos)
            install_macos
            ;;
        *)
            print_warning "不支持的操作系统: $OS"
            print_info "尝试使用 Cargo 安装..."
            install_cargo
            ;;
    esac

    # 验证安装
    if check_delta_installed; then
        print_info "✓ Delta 安装成功！"
    else
        print_error "✗ Delta 安装失败"
        exit 1
    fi
}

# 运行主函数
main
