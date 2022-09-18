import 'dart:convert';

import 'package:flutter_artisto/src/models/ImArtistooUser_data_model.dart';

class Artistoo {
  String type;
  String title;
  String description;
  int AlbumPrice;
  String SongLang;
  String category;
  int? upVote;
  int? downVote;
  String? dynamicLink;
  DateTime? expDate;
  DateTime createdAt;
  ArtistooUser user;
  Artistoo({
    required this.type,
    required this.title,
    required this.description,
    required this.AlbumPrice,
    required this.SongLang,
    required this.category,
    this.upVote,
    this.downVote,
    this.dynamicLink,
    this.expDate,
    required this.createdAt,
    required this.user,
  });

  Artistoo copyWith({
    String? type,
    String? title,
    String? description,
    int? AlbumPrice,
    String? SongLang,
    String? category,
    int? upVote,
    int? downVote,
    DateTime? expDate,
    DateTime? createdAt,
    ArtistooUser? user,
  }) {
    return Artistoo(
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      AlbumPrice: AlbumPrice ?? this.AlbumPrice,
      SongLang: SongLang ?? this.SongLang,
      category: category ?? this.category,
      upVote: upVote ?? this.upVote,
      downVote: downVote ?? this.downVote,
      expDate: expDate ?? this.expDate,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'title': title,
      'description': description,
      'AlbumPrice': AlbumPrice,
      'SongLang': SongLang,
      'category': category,
      'upVote': upVote,
      'downVote': downVote,
      'expDate': expDate?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'user': user.toMap(),
    };
  }

  factory Artistoo.fromMap(Map<String, dynamic> map) {
    return Artistoo(
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      AlbumPrice: map['AlbumPrice'] ?? '',
      SongLang: map['SongLang'] ?? '',
      category: map['category'] ?? '',
      upVote: map['upVote']?.toInt(),
      downVote: map['downVote']?.toInt(),
      expDate: map['expDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['expDate'])
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      user: ArtistooUser.fromMap(map['user'].cast<String, dynamic>()),
    );
  }

  String toJson() => json.encode(toMap());

  factory Artistoo.fromJson(String source) =>
      Artistoo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MyPost(type: $type, title: $title, description: $description, AlbumPrice: $AlbumPrice, SongLang: $SongLang,  category: $category, upVote: $upVote, downVote: $downVote,  expDate: $expDate, createdAt: $createdAt, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Artistoo &&
        other.type == type &&
        other.title == title &&
        other.description == description &&
        other.AlbumPrice == AlbumPrice &&
        other.SongLang == SongLang &&
        other.category == category &&
        other.upVote == upVote &&
        other.downVote == downVote &&
        other.expDate == expDate &&
        other.createdAt == createdAt &&
        other.user == user;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        title.hashCode ^
        description.hashCode ^
        AlbumPrice.hashCode ^
        SongLang.hashCode ^
        category.hashCode ^
        upVote.hashCode ^
        downVote.hashCode ^
        expDate.hashCode ^
        createdAt.hashCode ^
        user.hashCode;
  }
}
