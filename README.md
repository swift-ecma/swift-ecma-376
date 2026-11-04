# swift-ecma-376

Use this package when you need to read the text of a .docx document or the cell values of an .xlsx workbook, following ECMA-376 (Office Open XML, also ISO/IEC 29500). It reads only; it doesn't write files. Open the file with `ECMA_376.Package`, then read it with `ECMA_376.Wordprocessing.Document` or `ECMA_376.Spreadsheet.Workbook`. For the ZIP archive or the XML on their own, use swift-iso-21320 or swift-w3c-xml.

## Laws

- Part names are compared without regard to case, and a name without a leading `/` gets one.
- A part's relationships live in `_rels/<name>.rels` in the same folder, and the package's own in `/_rels/.rels`. A part without such a file has no relationships.
- A relationship target is resolved as a relative URI against its source part, so `../customXml/item1.xml` from `/word/document.xml` is `/customXml/item1.xml`.
- A relationship type is recognised under both the Transitional and the Strict namespace. A type under neither has no `ECMA_376.Relationship.kind`.
- The main part is the target of the package's first internal office document relationship. Without one, reading the document or workbook fails with `ECMA_376.Package.Error.relationship(_:)`.
- XML elements are matched by local name only, so Transitional and Strict markup read alike. A part whose root element isn't the expected one is refused with `ECMA_376.Package.Error.unexpected(_:)` naming that element.
- A paragraph's text joins its runs' text, with a tab as `\t` and a break or carriage return as `\n`. Deleted text and field codes are kept as their own run content and are left out of the text.
- Hyperlinks, insertions, deletions, content controls and similar wrappers are opened to their runs. Runs moved away from a place are not read there.
- A text box is read once, from the first alternative a document offers. Its paragraphs follow the paragraph that holds it in `ECMA_376.Wordprocessing.Block.paragraphs`, but are not part of that paragraph's text.
- Headers and footers are only the parts that section properties refer to, each once, in the order first referred to. A reference to a relationship the document doesn't have is refused.
- A workbook's sheets keep the workbook's order. Sheets that aren't worksheets, such as chart sheets, are left out.
- A cell's stored value is kept as written: numbers and dates stay text, and a Boolean is true only for `1`. A cell with no stored value has a nil value. A formula is kept beside its cached value.
- A shared string joins the text of its rich runs and leaves out phonetic hints. A shared string index beyond the table gives a nil value.
