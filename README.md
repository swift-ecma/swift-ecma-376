# swift-ecma-376

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Swift implementation of ECMA-376, Office Open XML File Formats (published identically as ISO/IEC 29500): reading the
documents and workbooks of `.docx` and `.xlsx` files.

## Standard Reference

- **Ecma**: ECMA-376, 5th edition
- **ISO/IEC**: 29500
- **Title**: Office Open XML File Formats

## Overview

- **ECMA 376** — Part 2, the Open Packaging Conventions: a package's parts in its ZIP archive (through
  [swift-iso-21320](https://github.com/swift-iso/swift-iso-21320)), and the relationships that lead from the package to
  its main part and from part to part.
- **ECMA 376 Wordprocessing** — Part 1 §17, WordprocessingML: a word-processing document's body, and the headers and footers its sections
  refer to, as paragraphs and tables; a paragraph's runs of text, tabs and breaks, with deleted text and field codes
  kept apart from its text.
- **ECMA 376 Spreadsheet** — Part 1 §18, SpreadsheetML: a workbook's sheets in their order, as rows of cells, each with its stored
  value: a number, a Boolean, an error, a date, or text from the shared string table or the cell itself.

Both markup languages are parsed through [swift-w3c-xml](https://github.com/swift-w3c/swift-w3c-xml), by local name, so
Transitional and Strict documents read alike.

```swift
import ECMA_376
import ECMA_376_Wordprocessing

let package = try ECMA_376.Package(bytes)
let document = try ECMA_376.Wordprocessing.Document(package)
document.body.flatMap(\.paragraphs).map(\.text)
```

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-ecma/swift-ecma-376.git", branch: "main")
]
```

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
