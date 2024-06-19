test-coverage:
	swift test --enable-code-coverage
	./Scripts/ProcessCoverage.swift \
    `swift test --show-codecov-path` .build/coverage.json \
    .build/coverage.html .build/coverage.svg