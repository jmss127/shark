# Shark

A fun terminal tool to encrypt text into a ticker-tape of SSL-encrypted gobbledygook, copy it to your clipboard, and share it with friends. Similarly you can paste encrypted text into it and using a shared key de-crypt it.

## Features

- Encrypts text using SSL (AES-256-CBC).

- Copies encrypted output to clipboard for easy pasting.

- Simple decryption using shared key.

- Terminal-based, lightweight.

## Requirements

- **Operating System**: Linux or Unix-like system with Bash.
- **Dependencies**:
  - wl-copy or xclip

## Usage

When starting the script Shark will prompt you for a passphrase, enter the passphrase you wish to use. Shark will then prompt you to enter the character `d` to decrypt text or anything else to encrypt text.

## Installation

```bash
git clone github.com:jmss127/shark.git
```

```bash
cd shark
./shark.sh
```

## License

This Project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
