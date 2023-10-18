/*
  {
    "userId": 1,
    "id": 1,
    "title": "quidem molestiae enim"
  }
*/

class PhotoItem {
  final int userId;
  final int id;
  final String title;

  PhotoItem({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory PhotoItem.fromJson(Map<String, dynamic> json) {
    return PhotoItem(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
