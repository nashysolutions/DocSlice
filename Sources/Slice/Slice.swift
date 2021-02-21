import Files
import PDFKit

public struct Slice {
    
    let file: File
    let slices: Int
    let output: Folder
    
    public init(file: File, slices: Int = 1, output: Folder = .current) {
        self.file = file
        self.slices = slices
        self.output = output
    }
    
    func chapters(_ pageCount: Int) -> Int {
        var count = Double(pageCount) / Double(slices)
        count.round(.toNearestOrAwayFromZero)
        return Int(count)
    }
    
    public func run() throws {
        
        guard let document = PDFDocument(url: file.url) else {
            throw SliceError.notFound(file)
        }
        
        let chunks = chapters(document.pageCount)
        
        for (index, pages) in document.pages.chunked(into: chunks).enumerated() {
            let document = pages.createDocument()
            let name = file.nameExcludingExtension.capitalized + " - Part\(index + 1).pdf"
            let file = try output.createFileIfNeeded(withName: name)
            document.write(to: file.url)
        }
    }
}

public enum SliceError: Error, CustomStringConvertible {
    
    case notFound(File)
    
    public var description: String {
        switch self {
        case .notFound(let file):
            return "PDF document not found at location: \(file)."
        }
    }
}

