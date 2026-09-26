abstract final class TimeUtils {
  static String formatRemaining(String? expiresAtStr, [String? fallbackRemain]) {
    if (expiresAtStr == null || expiresAtStr.isEmpty) {
      return fallbackRemain ?? '';
    }

    try {
      final expiryDate = DateTime.parse(expiresAtStr);
      final now = DateTime.now();
      final difference = expiryDate.difference(now);

      if (difference.isNegative || difference.inSeconds <= 0) {
        return fallbackRemain ?? '0 dakika';
      }

      final days = difference.inDays;
      final hours = difference.inHours % 24;
      final minutes = difference.inMinutes % 60;

      if (days > 0) {
        if (hours > 0) {
          return '$days gün $hours saat';
        }
        return '$days gün';
      }

      if (hours > 0) {
        if (minutes > 0) {
          return '$hours saat $minutes dakika';
        }
        return '$hours saat';
      }

      return '$minutes dakika';
    } catch (_) {
      return fallbackRemain ?? '';
    }
  }
}
