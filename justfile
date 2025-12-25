setup:
    bin/setup
    rustup update
    rustup component add llvm-tools-preview
    cargo install grcov
    rustup component add clippy

lint:
    pre-commit run --all-files
    cargo clippy --all --all-targets
    cargo clippy --fix

cover:
    mkdir -p target/coverage/html
    CARGO_INCREMENTAL=0 RUSTFLAGS='-Cinstrument-coverage' cargo build
    CARGO_INCREMENTAL=0 RUSTFLAGS='-Cinstrument-coverage' LLVM_PROFILE_FILE='cargo-test-%p-%m.profraw' cargo test
    grcov . --binary-path ./target/debug/deps/ -s . -t html --branch --ignore-not-existing --ignore '../*' --ignore "/*" -o target/coverage/
    grcov . --binary-path ./target/debug/deps/ -s . -t lcov --branch --ignore-not-existing --ignore '../*' --ignore "/*" -o target/coverage/tests.lcov
    find . -type f -name '*.profraw' -exec rm {} +
    open ./target/coverage/html/index.html
