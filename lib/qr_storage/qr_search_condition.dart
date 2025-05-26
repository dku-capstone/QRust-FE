class QrSearchCondition {
  final String? title;
  final String? type;
  final String? status;
  final String? start;
  final String? end;

  QrSearchCondition({
    this.title,
    this.type,
    this.status,
    this.start,
    this.end,
  });

  Map<String, dynamic> toJson() {
    return {
      if (title != null && title!.isNotEmpty) 'title': title,
      if (type != null && type!.isNotEmpty) 'type': type,
      if (status != null && status!.isNotEmpty) 'status': status,
      if (start != null && start!.isNotEmpty) 'start': start,
      if (end != null && end!.isNotEmpty) 'end': end,
    };
  }
}
