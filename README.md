# Typst App

iOS app for editing & viewing typst docs.

## Development

### Setup

* xcode tools: `xcode-select --install`
* rust toolchains: `curl https://sh.rustup.rs -sSf | sh`
* targets: `rustup target add aarch64-apple-ios aarch64-apple-ios-sim`
* cargo-lipo: `cargo install cargo-lipo`

> credit: https://mozilla.github.io/firefox-browser-architecture/experiments/2017-09-06-rust-on-ios.html

## Compile

Debug (for simulator)

```bash
cd typst
cargo lipo --release --targets aarch64-apple-ios-sim
```
