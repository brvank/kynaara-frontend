class Channel {
  int id, creatorId;
  String link, logoLink, name, creationDate;

  Channel(
      {required this.id,
      required this.creatorId,
      required this.link,
      required this.logoLink,
      required this.name,
      required this.creationDate});

  factory Channel.fromJson(Map json) {
    return Channel(
        id: json['channel_id'],
        creatorId: json['channel_creator_id'],
        link: json['channel_link'],
        logoLink: json['channel_logo_link'],
        name: json['channel_name'],
        creationDate: json['channel_creation_date']);
  }
}
