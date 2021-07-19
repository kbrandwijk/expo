
#if swift(>=5.4)
@resultBuilder
public struct ViewManagerDefinitionBuilder {
  public static func buildBlock(_ definitions: AnyDefinition...) -> ViewManagerDefinition {
    return ViewManagerDefinition(definitions: definitions)
  }
}
#endif
