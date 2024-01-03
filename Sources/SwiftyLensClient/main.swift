import SwiftyLens

@Lens
struct Foo {
    let bar: Int
    let baz: String
    
    public init(bar: Int, baz: String) {
        self.bar = bar
        self.baz = baz
    }
}

//extension Foo {
//    
//    struct Lenses {
//        static var bar: Lens<Foo, Int> {
//            .init(
//                get: { $0.bar },
//                set: { .init(bar: $0, baz: $1.baz) }
//            )
//        }
//        
//        static var baz: Lens<Foo, String> {
//            .init(
//                get: { $0.baz },
//                set: { .init(bar: $1.bar, baz: $0) }
//            )
//        }
//    }
//    
//}
