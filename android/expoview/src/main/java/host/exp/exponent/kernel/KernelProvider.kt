// Copyright 2015-present 650 Industries. All rights reserved.
package host.exp.exponent.kernel

object KernelProvider {
  private var sFactory: KernelFactory = object : KernelFactory {
    override fun create(): KernelInterface {
      return ExpoViewKernel.instance
    }
  }
  private var sInstance: KernelInterface? = null
  @JvmStatic fun setFactory(factory: KernelFactory) {
    sFactory = factory
  }

  @JvmStatic val instance: KernelInterface
    get() {
      if (sInstance == null) {
        sInstance = sFactory.create()
      }
      return sInstance!!
    }

  interface KernelFactory {
    fun create(): KernelInterface
  }
}
