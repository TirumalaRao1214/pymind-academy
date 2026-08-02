class Section {
  final String id;
  final String title;
  final String icon;
  final String color;
  final String description;
  final int lessonCount;
  final int order;

  const Section({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.lessonCount,
    required this.order,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String? ?? 'code',
      color: json['color'] as String? ?? '#58A6FF',
      description: json['description'] as String? ?? '',
      lessonCount: json['lesson_count'] as int? ?? 0,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'icon': icon,
    'color': color,
    'description': description,
    'lesson_count': lessonCount,
    'order': order,
  };
}
