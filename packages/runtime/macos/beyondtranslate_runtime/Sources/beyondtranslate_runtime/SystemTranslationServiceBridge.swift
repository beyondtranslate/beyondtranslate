import Foundation
import NaturalLanguage
import Translation

private func systemTranslationServiceBridgeRequestObserver(
  _ center: CFNotificationCenter?,
  _ observer: UnsafeMutableRawPointer?,
  _ name: CFNotificationName?,
  _ object: UnsafeRawPointer?,
  _ userInfo: CFDictionary?
) {
  SystemTranslationServiceBridge.handleRequest(userInfo: userInfo)
}

// MARK: - System Translation Service Bridge

/// A lightweight bridge that listens for system translation service requests from Rust
/// via CFNotificationCenter, translates using the system `Translation`
/// framework, and broadcasts the result back.
///
/// - Communication: CFNotificationCenter (local, in-process)
///   * Request notification: `com.beyondtranslate.systemTranslation.request`
///     Payload (CFDictionary):
///       - Translate: `requestId`, `operation=translate`, `text`,
///         `sourceLanguage`, `targetLanguage`
///       - Detect language: `requestId`, `operation=detectLanguage`, `texts`
///         where `texts` is a JSON string array
///   * Response notification: `com.beyondtranslate.systemTranslation.response`
///     Payload (CFDictionary): `requestId`, `operation`, `success`,
///       `translatedText`, `detectedSourceLanguage`, `detections`, `error`
final class SystemTranslationServiceBridge {

  private static let requestName = "com.beyondtranslate.systemTranslation.request" as CFString
  private static let responseName = "com.beyondtranslate.systemTranslation.response" as CFString

  private init() {}

  // MARK: - Public API

  /// Start listening for translation requests. Safe to call multiple times;
  /// the underlying CFNotificationCenter observer is registered only once.
  static func start() {
    DispatchQueue.once {
      let center = CFNotificationCenterGetLocalCenter()

      CFNotificationCenterAddObserver(
        center,
        nil,
        systemTranslationServiceBridgeRequestObserver,
        requestName,
        nil,
        .deliverImmediately
      )

      NSLog("[SystemTranslationServiceBridge] System translation service bridge started")
    }
  }

  // MARK: - Request handling

  fileprivate static func handleRequest(userInfo: CFDictionary?) {
    guard #available(macOS 13, *) else {
      NSLog("[SystemTranslationServiceBridge] Ignored request on macOS < 13")
      return
    }
    guard let info = userInfo as? [String: String],
      let requestId = info["requestId"]
    else {
      NSLog("[SystemTranslationServiceBridge] Ignored invalid request (missing required fields)")
      return
    }

    let operation = info["operation"] ?? "translate"

    if operation == "detectLanguage" {
      handleDetectLanguageRequest(requestId: requestId, info: info)
      return
    }

    guard let text = info["text"],
      let targetLang = info["targetLanguage"]
    else {
      NSLog("[SystemTranslationServiceBridge] Ignored invalid translation request")
      return
    }

    let sourceLang = info["sourceLanguage"]

    Task {
      let resultPayload: [String: String]

      do {
        guard #available(macOS 26, *) else {
          throw TranslationError.translationUnavailable
        }

        var sourceLanguage = sourceLang
        if sourceLanguage == nil || sourceLanguage!.isEmpty || sourceLanguage! == "auto" {
          // Auto-detect via NLLanguageRecognizer (available since macOS 10.14).
          let recognizer = NLLanguageRecognizer()
          recognizer.processString(text)
          guard let hypothesis = recognizer.dominantLanguage else {
            throw TranslationError.detectionFailed
          }
          sourceLanguage = hypothesis.rawValue
        }

        let srcLocale = Locale.Language(identifier: sourceLanguage!)
        let tgtLocale = Locale.Language(identifier: targetLang)

        let availability = LanguageAvailability()
        let status = await availability.status(from: srcLocale, to: tgtLocale)
        switch status {
        case .installed:
          break
        case .supported:
          throw TranslationError.languagePairNotInstalled(
            source: sourceLanguage!,
            target: targetLang
          )
        case .unsupported:
          throw TranslationError.unsupportedLanguagePair(
            source: sourceLanguage!,
            target: targetLang
          )
        @unknown default:
          throw TranslationError.unsupportedLanguagePair(
            source: sourceLanguage!,
            target: targetLang
          )
        }

        let session = TranslationSession(installedSource: srcLocale, target: tgtLocale)
        let response = try await session.translate(text)

        resultPayload = [
          "requestId": requestId,
          "operation": "translate",
          "success": "true",
          "translatedText": response.targetText,
          "detectedSourceLanguage": sourceLanguage!,
        ]
      } catch {
        resultPayload = [
          "requestId": requestId,
          "operation": "translate",
          "success": "false",
          "error": error.localizedDescription,
        ]
      }

      postResponse(resultPayload)
    }
  }

  private static func handleDetectLanguageRequest(requestId: String, info: [String: String]) {
    let texts: [String]
    if let textsJson = info["texts"] {
      do {
        texts = try decodeTexts(textsJson)
      } catch {
        postResponse([
          "requestId": requestId,
          "operation": "detectLanguage",
          "success": "false",
          "error": error.localizedDescription,
        ])
        return
      }
    } else if let text = info["text"] {
      texts = [text]
    } else {
      NSLog("[SystemTranslationServiceBridge] Ignored invalid detect language request")
      return
    }

    do {
      let detections = try texts.map { text in
        [
          "detected_language": try detectLanguage(text),
          "text": text,
        ]
      }
      let data = try JSONSerialization.data(withJSONObject: detections)
      guard let detectionsJson = String(data: data, encoding: .utf8) else {
        throw TranslationError.serializationFailed
      }

      postResponse([
        "requestId": requestId,
        "operation": "detectLanguage",
        "success": "true",
        "detections": detectionsJson,
      ])
    } catch {
      postResponse([
        "requestId": requestId,
        "operation": "detectLanguage",
        "success": "false",
        "error": error.localizedDescription,
      ])
    }
  }

  private static func detectLanguage(_ text: String) throws -> String {
    let recognizer = NLLanguageRecognizer()
    recognizer.processString(text)
    guard let hypothesis = recognizer.dominantLanguage else {
      throw TranslationError.detectionFailed
    }
    return hypothesis.rawValue
  }

  private static func decodeTexts(_ json: String) throws -> [String] {
    guard let data = json.data(using: .utf8),
      let texts = try JSONSerialization.jsonObject(with: data) as? [String]
    else {
      throw TranslationError.invalidDetectLanguagePayload
    }
    return texts
  }

  private static func postResponse(_ payload: [String: String]) {
    let center = CFNotificationCenterGetLocalCenter()
    CFNotificationCenterPostNotification(
      center,
      CFNotificationName(rawValue: responseName),
      nil,
      payload as CFDictionary,
      true
    )
  }
}

// MARK: - Local error

private enum TranslationError: LocalizedError {
  case detectionFailed
  case invalidDetectLanguagePayload
  case serializationFailed
  case translationUnavailable
  case languagePairNotInstalled(source: String, target: String)
  case unsupportedLanguagePair(source: String, target: String)

  var errorDescription: String? {
    switch self {
    case .detectionFailed:
      return "Unable to detect source language"
    case .invalidDetectLanguagePayload:
      return "Detect language request texts must be a JSON string array"
    case .serializationFailed:
      return "Unable to serialize language detection response"
    case .translationUnavailable:
      return "System translation requires macOS 26 or later"
    case .languagePairNotInstalled(let source, let target):
      return
        "System translation language files are not installed for \(source) to \(target). Install the languages in System Settings > General > Language & Region > Translation Languages, then try again."
    case .unsupportedLanguagePair(let source, let target):
      return "System translation does not support translating from \(source) to \(target)"
    }
  }
}

// MARK: - DispatchOnce helper

extension DispatchQueue {
  private static var onceTracker: Set<String> = []

  /// Executes `block` exactly once per unique `key` across the lifetime of
  /// the process. Thread-safe.
  fileprivate static func once(_ block: @escaping () -> Void) {
    objc_sync_enter(self)
    defer { objc_sync_exit(self) }
    let key = "com.beyondtranslate.SystemTranslationServiceBridge.start"
    guard !onceTracker.contains(key) else { return }
    onceTracker.insert(key)
    block()
  }
}
