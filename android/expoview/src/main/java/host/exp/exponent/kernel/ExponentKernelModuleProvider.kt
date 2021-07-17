// Copyright 2015-present 650 Industries. All rights reserved.
package host.exp.exponent.kernel

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableMap
import java.util.*

object ExponentKernelModuleProvider {
  private var sFactory: ExponentKernelModuleFactory = object : ExponentKernelModuleFactory {
    override fun create(reactContext: ReactApplicationContext): ExponentKernelModuleInterface {
      return ExpoViewKernelModule(reactContext)
    }
  }

  private var sInstance: ExponentKernelModuleInterface? = null

  @JvmStatic fun setFactory(factory: ExponentKernelModuleFactory) {
    sFactory = factory
  }

  @JvmStatic fun newInstance(reactContext: ReactApplicationContext): ExponentKernelModuleInterface? {
    sInstance = sFactory.create(reactContext)
    return sInstance
  }

  @JvmStatic var sEventQueue: Queue<KernelEvent> = LinkedList()
  fun queueEvent(name: String?, data: WritableMap?, callback: KernelEventCallback?) {
    queueEvent(KernelEvent(name, data, callback))
  }

  fun queueEvent(event: KernelEvent) {
    sEventQueue.add(event)
    sInstance?.consumeEventQueue()
  }

  interface KernelEventCallback {
    fun onEventSuccess(result: ReadableMap?)
    fun onEventFailure(errorMessage: String?)
  }

  interface ExponentKernelModuleFactory {
    fun create(reactContext: ReactApplicationContext): ExponentKernelModuleInterface
  }

  class KernelEvent(val name: String?, val data: WritableMap?, val callback: KernelEventCallback?)
}
