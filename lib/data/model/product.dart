class Product {
  int id, creatorId, channelId;
  int? assigneeId;
  String link, imageLink, dateCreated;
  String? dateAssigned;

  Product(
      {required this.id,
      required this.creatorId,
      required this.channelId,
      required this.assigneeId,
      required this.link,
      required this.imageLink,
      required this.dateCreated,
      required this.dateAssigned});

  factory Product.fromJson(Map json) {
    return Product(
        id: json['product_id'],
        creatorId: json['product_creator_id'],
        channelId: json['product_channel_id'],
        assigneeId: json['product_assignee_id'],
        link: json['product_link'],
        imageLink: json['product_image_link'],
        dateCreated: json['product_date_created'],
        dateAssigned: json['product_date_assigned']);
  }
}
