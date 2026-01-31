class ImageUtils {
  static String convertDriveLink(String url) {
    if (url.isEmpty) return '';
    if (url.contains('drive.google.com') && url.contains('/file/d/')) {
      final RegExp regExp = RegExp(r'/file/d/([a-zA-Z0-9_-]+)');
      final match = regExp.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        final id = match.group(1);
        return 'https://drive.google.com/uc?export=view&id=$id';
      }
    }
    return url;
  }
}
