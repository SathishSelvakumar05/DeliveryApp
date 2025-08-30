part of 'offer_cubit.dart';



class OfferState {
  bool isOfferLoading;
  List<OfferTable>? isOfferData;
  OfferState({ this.isOfferData,required this.isOfferLoading});
}

class OfferTable {
  final int id;
  final DateTime createdAt;
  final String image1;
  final String image2;
  final String image3;

  OfferTable({
    required this.id,
    required this.createdAt,
    required this.image1,
    required this.image2,
    required this.image3,
  });

  factory OfferTable.fromMap(Map<String, dynamic> map) {
    return OfferTable(
      id: map['id'] ?? 0,
      createdAt: DateTime.parse(map['created_at']),
      image1: map['image1'] ?? '',
      image2: map['image2'] ?? '',
      image3: map['image3'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'image1': image1,
      'image2': image2,
      'image3': image3,
    };
  }
}

