import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(SwiftyLensMacros)
import SwiftyLensMacros

let testMacros: [String: Macro.Type] = [
    "Lens": SwiftyLensMacro.self,
]
#endif

final class SwiftyLensTests: XCTestCase {
    
    func testMacro() throws {
        #if canImport(SwiftyLensMacros)
        assertMacroExpansion(
            """
            @Lens
            struct Foo {
                let bar: Int
                let baz: String
            
                public init(bar: Int, baz: String) {
                    self.bar = bar
                    self.baz = baz
                }
            }
            """,
            expandedSource: """
            struct Foo {
                let bar: Int
                let baz: String
            
                public init(bar: Int, baz: String) {
                    self.bar = bar
                    self.baz = baz
                }
            }
            
            extension Foo {
                struct Lenses {
                    static var bar: Lens<Foo, Int> {
                        .init(
                            get: { $0.bar },
                            set: { .init(bar: $0, baz: $1.baz) }
                        )
                    }
                    static var baz: Lens<Foo, String> {
                        .init(
                            get: { $0.baz },
                            set: { .init(bar: $1.bar, baz: $0) }
                        )
                    }
                }
            }

            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
}
