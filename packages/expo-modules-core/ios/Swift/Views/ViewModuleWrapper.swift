@objc
public protocol ViewModuleWrapperProtocol {
  init(from: ViewModuleWrapper)
}

@objc
public class ViewModuleWrapper: RCTViewManager {
  let wrappedModuleHolder: ModuleHolder

  public init(_ wrappedModuleHolder: ModuleHolder) {
    self.wrappedModuleHolder = wrappedModuleHolder
  }

  @objc
  public convenience init(from module: ViewModuleWrapper) {
    self.init(module.wrappedModuleHolder)
  }

  @objc
  public func name() -> String {
    return wrappedModuleHolder.name
  }

  @objc
  dynamic public override class func moduleName() -> String! {
    fatalError("Something unexpected has happened. The original implementation of `moduleName` method must be replaced in runtime (see `viewModuleWrapperClass` below).")
  }

  @objc
  public override func view() -> UIView! {
    guard let view = wrappedModuleHolder.definition.viewManager?.createView() else {
      fatalError("Module `\(wrappedModuleHolder.name)` doesn't define the view manager nor view factory.")
    }
    return view
  }

  @objc
  public class func propConfig_proxiedProperties() -> [String] {
    return ["NSDictionary", "__custom__"];
  }

  @objc
  public func set_proxiedProperties(_ json: Any?, forView view: UIView, withDefaultView defaultView: UIView) {
    guard let json = json as? [String: Any?],
          let props = wrappedModuleHolder.definition.viewManager?.propsDict() else {
      return
    }
    for (key, value) in json {
      if let prop = props[key] {
        prop.set(value: value, onView: view)
      }
    }
  }

  @objc
  public static func createViewModuleWrapperClass(viewName: String) -> ViewModuleWrapper.Type? {
    // We're namespacing the view name so we know it uses our architecture.
    let prefixedViewName = "ViewManagerAdapter_\(viewName)"

    return prefixedViewName.withCString { viewNamePtr in
      // Create a new meta class that inherits from `ViewModuleWrapper`. The class name passed here, doesn't work for Swift classes,
      // so we also have to override `moduleName` class method.
      let wrapperClass: AnyClass? = objc_allocateClassPair(ViewModuleWrapper.self, viewNamePtr, 0)

      // Prepare the selector and new implementation that returns correct view name.
      let moduleNameSel: Selector = #selector(moduleName)
      let moduleNameBlock: @convention(block) () -> String = { prefixedViewName }
      let moduleNameImp: IMP = imp_implementationWithBlock(moduleNameBlock)

      // Get the `moduleName` class method and replace its implementation.
      // We can assume the method already exists as it's defined in `ViewModuleManager` superclass,
      // but if not then just add it with the proper implementation.
      if let moduleNameMethod = class_getClassMethod(wrapperClass, moduleNameSel) {
        method_setImplementation(moduleNameMethod, moduleNameImp)
      } else {
        class_addMethod(object_getClass(wrapperClass), moduleNameSel, moduleNameImp, "@@:")
      }

      return wrapperClass as? ViewModuleWrapper.Type
    }
  }
}
