.PHONY: setup generate open clean lint

# ── Setup ────────────────────────────────────────────────────────────────────
# Install XcodeGen if missing, then generate the Xcode project.
setup:
	@which xcodegen > /dev/null 2>&1 || brew install xcodegen
	$(MAKE) generate

# ── Generate ─────────────────────────────────────────────────────────────────
# Regenerate ASCIIboard.xcodeproj from project.yml.
generate:
	xcodegen generate

# ── Open ─────────────────────────────────────────────────────────────────────
# Generate and open the project in Xcode.
open: generate
	open ASCIIboard.xcodeproj

# ── Clean ────────────────────────────────────────────────────────────────────
# Remove generated Xcode project.
clean:
	rm -rf ASCIIboard.xcodeproj

# ── Lint ─────────────────────────────────────────────────────────────────────
# Run SwiftLint if available (optional code style check).
lint:
	@which swiftlint > /dev/null 2>&1 && swiftlint || echo "SwiftLint not installed — skipping."
