	
DEBUG_PATH = ".build/$(shell uname -m)-apple-macosx/debug"
LLVM_COV := $(shell command -v llvm-cov 2> /dev/null)

test:
	swift test

coverage:

ifeq (,${LLVM_COV})
	# install tools for SwiftPM code coverage
	brew install llvm
endif

	swift test --enable-code-coverage
	@llvm-cov report \
		${DEBUG_PATH}/NMEAKitPackageTests.xctest/Contents/MacOS/NMEAKitPackageTests \
		-instr-profile=${DEBUG_PATH}/codecov/default.profdata \
		-ignore-filename-regex=".build|Tests" \
		-use-color
