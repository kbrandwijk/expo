// Copyright 2015-present 650 Industries. All rights reserved.
package host.exp.exponent.kernel

class ExponentErrorMessage(
  private var mUserErrorMessage: String?,
  private val mDeveloperErrorMessage: String?
) {
  fun userErrorMessage(): String {
    return mUserErrorMessage?.let { limit(it) } ?: ""
  }

  fun developerErrorMessage(): String {
    return mDeveloperErrorMessage?.let { limit(it) } ?: ""
  }

  fun addUserErrorMessage(errorMessage: String?): ExponentErrorMessage {
    mUserErrorMessage = errorMessage
    return this
  }

  private fun limit(s: String): String {
    return if (s.length < MAX_LENGTH) {
      s
    } else {
      s.substring(0, MAX_LENGTH)
    }
  }

  companion object {
    private const val MAX_LENGTH = 300

    @JvmStatic fun userErrorMessage(errorMessage: String?): ExponentErrorMessage {
      return ExponentErrorMessage(errorMessage, errorMessage)
    }

    @JvmStatic fun developerErrorMessage(errorMessage: String?): ExponentErrorMessage {
      return ExponentErrorMessage(null, errorMessage)
    }
  }
}
