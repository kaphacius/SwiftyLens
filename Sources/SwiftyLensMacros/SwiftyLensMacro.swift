import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SwiftyLensMacro: ExtensionMacro {
    
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        print(declaration)
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            return []
        }
        
        let ext = try ExtensionDeclSyntax("extension \(raw: structDecl.name.text)") {
            try StructDeclSyntax(.init(stringLiteral: "struct Lenses")) {
                let variables = try structDecl
                    .memberBlock
                    .members
                    .map(\.decl)
                    .compactMap { $0.as(VariableDeclSyntax.self) }
                    .filter { $0.bindingSpecifier == .keyword(SwiftSyntax.Keyword.let) }
                    .map { (letVar: VariableDeclSyntax) -> VariableDeclSyntax in
                        try VariableDeclSyntax("static var \(letVar)")
                    }
                
                for variable in variables {
                    MemberBlockItemSyntax(variable)!
                }
            }
        }

        return [ext]
    }
    
}

@main
struct SwiftyLensPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SwiftyLensMacro.self,
    ]
}
