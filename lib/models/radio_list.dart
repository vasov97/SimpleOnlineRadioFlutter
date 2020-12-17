import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ai_radio/models/radio.dart';

class MyRadioList {
  final List<MyRadio> myRadioList;
  MyRadioList({
    this.myRadioList,
  });

  MyRadioList copyWith({
    List<MyRadio> myRadioList,
  }) {
    return MyRadioList(
      myRadioList: myRadioList ?? this.myRadioList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'myRadioList': myRadioList?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory MyRadioList.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MyRadioList(
      myRadioList: List<MyRadio>.from(
          map['myRadioList']?.map((x) => MyRadio.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MyRadioList.fromJson(String source) =>
      MyRadioList.fromMap(json.decode(source));

  @override
  String toString() => 'MyRadioList(myRadioList: $myRadioList)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MyRadioList && listEquals(o.myRadioList, myRadioList);
  }

  @override
  int get hashCode => myRadioList.hashCode;
}
