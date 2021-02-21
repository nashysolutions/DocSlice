import PDFKit

extension Array where Element == PDFPage {
    
    func createDocument() -> PDFDocument {
        let document = PDFDocument()
        for (index, page) in self.enumerated() {
            document.insert(page, at: index)
        }
        return document
    }
}

extension PDFDocument {
    
    var pages: [PDFPage] {
        let range = 0..<pageCount
        return range.map {
            page(at: $0)!
        }
    }
}

extension Array {
    
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
