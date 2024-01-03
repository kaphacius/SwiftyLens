// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(extension, names: arbitrary)
public macro Lens() = #externalMacro(module: "SwiftyLensMacros", type: "SwiftyLensMacro")

public struct Lens<Whole, Part> {
    
    public let get: (Whole) -> Part
    public let set: (Part, Whole) -> Whole
    
    public init(
        get: @escaping (Whole) -> Part,
        set: @escaping (Part, Whole) -> Whole
    ) {
        self.get = get
        self.set = set
    }
    
}
