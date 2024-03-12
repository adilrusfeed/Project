class FileInfo {
  final String fileName;
  final String fileUrl;
  final int fileSize;

  FileInfo({
    required this.fileName,
    required this.fileUrl,
    required this.fileSize,
  });

  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
      fileName: json['fileName'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      fileSize: json['fileSize'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'fileUrl': fileUrl,
      'fileSize': fileSize,
    };
  }
}
