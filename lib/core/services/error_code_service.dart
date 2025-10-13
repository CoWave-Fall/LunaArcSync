import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// Service for handling API error code localization
/// 
/// This service maps error codes from the API to localized messages.
/// Error codes follow the format: [MODULE]_[TYPE]_[NUMBER]
/// 
/// Modules:
/// - ACC: Account
/// - PAG: Page
/// - DOC: Document
/// - JOB: Job
/// - IMG: Image
/// - VER: Version
/// - SRC: Search
/// - DAT: Data
/// - APP: Application
/// - PDF: PDF Processing
/// - OCR: OCR Processing
/// - STI: Image Stitching
/// - IMP: Import/Export
/// 
/// Types:
/// - ERR: Error
/// - SUC: Success
/// - WARN: Warning
/// - INFO: Information
class ErrorCodeService {
  /// Get localized message for an error code
  /// 
  /// [context] - BuildContext to access localization
  /// [errorCode] - Error code from API (e.g., "ACC_ERR_001")
  /// [params] - Optional parameters for message placeholders
  /// 
  /// Returns localized message, or the original error code if not found
  static String getMessage(
    BuildContext context,
    String errorCode, {
    Map<String, String>? params,
  }) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return errorCode;

    // Convert error code to camelCase key
    // e.g., "ACC_ERR_001" -> "accErr001"
    final key = _convertToCamelCase(errorCode);

    try {
      switch (key) {
        // Account Module
        case 'accErr001':
          return l10n.accErr001;
        case 'accErr002':
          return l10n.accErr002;
        case 'accSuc001':
          return l10n.accSuc001;
        case 'accErr003':
          return l10n.accErr003;

        // Page Module
        case 'pagErr001':
          return l10n.pagErr001;
        case 'pagErr002':
          return l10n.pagErr002;
        case 'pagErr003':
          return l10n.pagErr003(params?['duplicatePageIds'] ?? '');
        case 'pagErr004':
          return l10n.pagErr004(params?['duplicateOrders'] ?? '');
        case 'pagErr005':
          return l10n.pagErr005;
        case 'pagErr006':
          return l10n.pagErr006(params?['maxOrder'] ?? '');
        case 'pagErr007':
          return l10n.pagErr007;
        case 'pagErr008':
          return l10n.pagErr008;
        case 'pagErr009':
          return l10n.pagErr009;
        case 'pagErr010':
          return l10n.pagErr010;
        case 'pagErr011':
          return l10n.pagErr011;
        case 'pagErr012':
          return l10n.pagErr012;
        case 'pagErr013':
          return l10n.pagErr013(
            params?['pageId'] ?? '',
            params?['documentId'] ?? '',
          );
        case 'pagErr014':
          return l10n.pagErr014;

        // Document Module
        case 'docErr001':
          return l10n.docErr001;
        case 'docErr002':
          return l10n.docErr002;

        // Job Module
        case 'jobErr001':
          return l10n.jobErr001(params?['jobId'] ?? '');
        case 'jobErr002':
          return l10n.jobErr002(params?['versionId'] ?? '');
        case 'jobErr003':
          return l10n.jobErr003(params?['pageId'] ?? '');
        case 'jobErr004':
          return l10n.jobErr004(params?['versionId'] ?? '');
        case 'jobErr005':
          return l10n.jobErr005(params?['jobId'] ?? '');
        case 'jobSuc001':
          return l10n.jobSuc001;
        case 'jobSuc002':
          return l10n.jobSuc002;
        case 'jobSuc003':
          return l10n.jobSuc003;

        // Image Module
        case 'imgErr001':
          return l10n.imgErr001;
        case 'imgErr002':
          return l10n.imgErr002;
        case 'imgErr003':
          return l10n.imgErr003;

        // Version Module
        case 'verErr001':
          return l10n.verErr001;
        case 'verErr002':
          return l10n.verErr002;

        // Search Module
        case 'srcErr001':
          return l10n.srcErr001;

        // Data Module
        case 'datErr001':
          return l10n.datErr001;
        case 'datErr002':
          return l10n.datErr002;
        case 'datErr003':
          return l10n.datErr003;
        case 'datSuc001':
          return l10n.datSuc001;
        case 'datSuc002':
          return l10n.datSuc002;

        // Application Module
        case 'appInfo001':
          return l10n.appInfo001;

        // PDF Processing Module
        case 'pdfErr001':
          return l10n.pdfErr001;
        case 'pdfErr002':
          return l10n.pdfErr002;
        case 'pdfErr003':
          return l10n.pdfErr003;
        case 'pdfErr004':
          return l10n.pdfErr004(params?['pageNumber'] ?? '');

        // OCR Processing Module
        case 'ocrErr001':
          return l10n.ocrErr001;
        case 'ocrErr002':
          return l10n.ocrErr002;
        case 'ocrErr003':
          return l10n.ocrErr003;
        case 'ocrErr004':
          return l10n.ocrErr004;

        // Image Stitching Module
        case 'stiErr001':
          return l10n.stiErr001;
        case 'stiErr002':
          return l10n.stiErr002;
        case 'stiErr003':
          return l10n.stiErr003(params?['status'] ?? '');
        case 'stiErr004':
          return l10n.stiErr004(
            params?['pageId'] ?? '',
            params?['userId'] ?? '',
          );

        // Import/Export Module
        case 'impErr001':
          return l10n.impErr001;
        case 'impErr002':
          return l10n.impErr002;

        default:
          return errorCode;
      }
    } catch (e) {
      return errorCode;
    }
  }

  /// Convert error code from UPPER_SNAKE_CASE to camelCase
  /// e.g., "ACC_ERR_001" -> "accErr001"
  static String _convertToCamelCase(String errorCode) {
    final parts = errorCode.split('_');
    if (parts.isEmpty) return errorCode;

    final buffer = StringBuffer();
    buffer.write(parts[0].toLowerCase());

    for (int i = 1; i < parts.length; i++) {
      final part = parts[i];
      if (part.isEmpty) continue;

      // Capitalize first letter, keep rest as is for acronyms like ERR, SUC
      if (part.length <= 3 && RegExp(r'^[A-Z]+$').hasMatch(part)) {
        // It's likely an acronym (ERR, SUC, etc.)
        buffer.write(part[0].toUpperCase());
        buffer.write(part.substring(1).toLowerCase());
      } else {
        // It's a number or other part
        buffer.write(part);
      }
    }

    return buffer.toString();
  }

  /// Extract parameters from error message
  /// 
  /// This method can be used to parse parameters from error messages
  /// that contain placeholders like {paramName}
  static Map<String, String> extractParameters(String message) {
    final params = <String, String>{};
    final regex = RegExp(r'\{(\w+)\}');
    final matches = regex.allMatches(message);

    for (final match in matches) {
      final paramName = match.group(1);
      if (paramName != null) {
        params[paramName] = '';
      }
    }

    return params;
  }

  /// Check if error code is a success code
  static bool isSuccess(String errorCode) {
    return errorCode.contains('SUC') || errorCode.contains('_SUC_');
  }

  /// Check if error code is an error code
  static bool isError(String errorCode) {
    return errorCode.contains('ERR') || errorCode.contains('_ERR_');
  }

  /// Check if error code is a warning code
  static bool isWarning(String errorCode) {
    return errorCode.contains('WARN') || errorCode.contains('_WARN_');
  }

  /// Check if error code is an info code
  static bool isInfo(String errorCode) {
    return errorCode.contains('INFO') || errorCode.contains('_INFO_');
  }

  /// Get the module name from error code
  /// e.g., "ACC_ERR_001" -> "ACC"
  static String getModule(String errorCode) {
    final parts = errorCode.split('_');
    return parts.isNotEmpty ? parts[0] : '';
  }

  /// Get the type from error code
  /// e.g., "ACC_ERR_001" -> "ERR"
  static String getType(String errorCode) {
    final parts = errorCode.split('_');
    return parts.length > 1 ? parts[1] : '';
  }

  /// Get the number from error code
  /// e.g., "ACC_ERR_001" -> "001"
  static String getNumber(String errorCode) {
    final parts = errorCode.split('_');
    return parts.length > 2 ? parts[2] : '';
  }
}

