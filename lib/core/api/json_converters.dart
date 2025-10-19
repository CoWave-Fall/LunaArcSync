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

/// A JsonConverter to handle Unix timestamps (milliseconds since epoch).
/// Backend now returns Unix timestamps instead of ISO8601 strings.
/// This converter handles both numeric and string representations.
class UnixTimestampConverter implements JsonConverter<DateTime, dynamic> {
  const UnixTimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    // Handle null case
    if (json == null) {
      throw ArgumentError('Timestamp cannot be null');
    }
    
    // Convert to int, handling both String and num types
    int timestamp;
    if (json is String) {
      timestamp = int.parse(json);
    } else if (json is num) {
      timestamp = json.toInt();
    } else {
      throw ArgumentError('Invalid timestamp type: ${json.runtimeType}');
    }
    
    // Convert Unix timestamp (milliseconds) to DateTime
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  @override
  dynamic toJson(DateTime date) {
    // Convert DateTime to Unix timestamp (milliseconds)
    return date.millisecondsSinceEpoch;
  }
}