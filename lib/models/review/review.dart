// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import '../review_author/review_author.dart';

part 'review.g.dart';

@JsonSerializable(explicitToJson: true)
class Review {
  @JsonKey(name: 'author')
  String? authorUserName;
  @JsonKey(name: 'author_details')
  ReviewAuthor author;
  @JsonKey(name: 'content')
  String? reviewContent;
  @JsonKey(name: 'created_at')
  String? datePosted;
  @JsonKey(includeFromJson: false)
  bool isExpanded;
  Review({
    this.authorUserName,
    required this.author,
    this.reviewContent,
    this.datePosted,
    this.isExpanded = false,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}