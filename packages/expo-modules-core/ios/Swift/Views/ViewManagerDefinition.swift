public struct ViewManagerDefinition: AnyDefinition {
  let factory: ViewFactory?

  let props: [AnyViewProp]

  init(definitions: [AnyDefinition]) {
    self.factory = definitions
      .compactMap { $0 as? ViewFactory }
      .last

    self.props = definitions
      .compactMap { $0 as? AnyViewProp }
  }

  func createView() -> UIView? {
    return factory?.create()
  }

  func propsDict() -> [String: AnyViewProp] {
    return props.reduce(into: [String: AnyViewProp]()) { acc, prop in
      acc[prop.name] = prop
    }
  }
}
