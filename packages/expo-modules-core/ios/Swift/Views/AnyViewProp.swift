public protocol AnyViewProp: AnyDefinition {
  var name: String { get }
  func set(value: Any?, onView: UIView)
}
