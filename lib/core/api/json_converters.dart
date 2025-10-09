import 'package:json_annotation/json_annotation.dart';

/// A JsonConverter to handle high-precision DateTime strings from .NET backends.
/// It truncates fractional seconds to a maximum of 6 digits before parsing.
class HighPrecisionDateTimeConverter implements JsonConverter<DateTime, String> {
  const HighPrecisionDateTimeConverter();

  @override
  DateTime fromJson(String json) {
    // Find the decimal point for fractional seconds
    final dotIndex = json.lastIndexOf('.');
    if (dotIndex != -1) {
      // Find the end of the fractional part (Z or + or -)
      final endIndex = json.indexOf(RegExp(r'[Z+-]'), dotIndex);
      final fractionPart = json.substring(dotIndex + 1, endIndex == -1 ? null : endIndex);
      
      if (fractionPart.length > 6) {
        final truncatedFraction = fractionPart.substring(0, 6);
        final prefix = json.substring(0, dotIndex + 1);
        final suffix = endIndex == -1 ? '' : json.substring(endIndex);
        
        // Reassemble the string with truncated fractional seconds
        final newJson = '$prefix$truncatedFraction$suffix';
        return DateTime.parse(newJson);
      }
    }
    
    // If no truncation is needed, parse directly
    return DateTime.parse(json);
  }

  @override
  String toJson(DateTime date) => date.toIso8601String();
}