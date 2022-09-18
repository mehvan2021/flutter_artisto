import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ArtistooUser {
//TODO: from snapshot
  String name;
  String uid;
  int ArtCoin;
  DateTime createdAt;
  List<String>? inlist;
  String? website;
  String? SocialAcc;
  String email;
  String? phone;
  ArtistooUser({
    required this.name,
    required this.ArtCoin,
    required this.createdAt,
    required this.inlist,
    this.website,
    this.SocialAcc,
    required this.uid,
    required this.email,
    this.phone,
  });

  ArtistooUser copyWith({
    String? name,
    required int ArtCoin,
    DateTime? createdAt,
    List<String>? inlist,
    String? website,
    String? SocialAcc,
    String? email,
    String? uid,
    String? phone,
  }) {
    return ArtistooUser(
      name: name ?? this.name,
      ArtCoin: ArtCoin ?? this.ArtCoin,
      createdAt: createdAt ?? this.createdAt,
      inlist: inlist ?? this.inlist,
      website: website ?? this.website,
      SocialAcc: SocialAcc ?? this.SocialAcc,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ArtCoin': ArtCoin,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'inlist': inlist,
      'website': website,
      'SocialAcc': SocialAcc,
      'email': email,
      'phone': phone,
      'uid': uid,
    };
  }
  // factory from document snapshot

  factory ArtistooUser.fromSnapShot(DocumentSnapshot documentSnapshot) {
    return ArtistooUser.fromMap(documentSnapshot.data() as Map<String, dynamic>,
        reference: documentSnapshot.reference);
  }

  factory ArtistooUser.fromMap(Map<String, dynamic> map,
      {DocumentReference? reference}) {
    return ArtistooUser(
      name: map['name'] ?? '',
      ArtCoin: map['ArtCoin']?.toInt() ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      website: map['website'],
      SocialAcc: map['SocialAcc'],
      email: map['email'] ?? '',
      phone: map['phone'],
      uid: map['uid'],
      inlist: map['inlist'] == null ? null : List<String>.from(map['inlist']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ArtistooUser.fromJson(String source) =>
      ArtistooUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ArtistooUser(name: $name, ArtCoin: $ArtCoin, createdAt: $createdAt,  inlist: $inlist, website: $website, SocialAcc: $SocialAcc, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ArtistooUser &&
        other.name == name &&
        other.ArtCoin == ArtCoin &&
        other.createdAt == createdAt &&
        other.inlist == inlist &&
        other.website == website &&
        other.SocialAcc == SocialAcc &&
        other.uid == uid &&
        other.email == email &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        ArtCoin.hashCode ^
        createdAt.hashCode ^
        inlist.hashCode ^
        website.hashCode ^
        SocialAcc.hashCode ^
        uid.hashCode ^
        email.hashCode ^
        phone.hashCode;
  }
}
