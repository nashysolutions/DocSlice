import ArgumentParser
import Files
import Slice

extension Folder: ExpressibleByArgument {
    
    public init?(argument: String) {
        try? self.init(path: argument)
    }
}

extension File: ExpressibleByArgument {
    
    public init?(argument: String) {
        try? self.init(path: argument)
    }
}

public struct DocSlice: ParsableCommand {
        
    public init() {}
    
    @Option(name: .shortAndLong, help: "The destination folder for output.")
    public var output: Folder = Folder.current
    
    @Option(name: .shortAndLong, help: "The number of parts the document should be evenly split into.")
    public var slices: Int = 1
    
    @Argument(help: "A local PDF file.")
    public var file: File

    mutating public func run() throws {
        let slice = Slice(file: file, slices: slices, output: output)
        try slice.run()
    }
}

DocSlice.main()
