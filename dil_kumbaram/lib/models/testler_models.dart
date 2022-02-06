// To parse this JSON data, do
//
//     final testlerModel = testlerModelFromJson(jsonString);

// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

TestlerModel testlerModelFromJson(String str) => TestlerModel.fromJson(json.decode(str));

String testlerModelToJson(TestlerModel data) => json.encode(data.toJson());

class TestlerModel {
    TestlerModel({
        this.id,
        this.aciklama,
        this.glink,
        this.dogru,
        this.yanlis1,
        this.yanlis2,
        this.dil,
    });

    String? id;
    String? aciklama;
    String? glink;
    String? dogru;
    String? yanlis1;
    String? yanlis2;
    String? dil;

    factory TestlerModel.fromJson(Map<String, dynamic> json) => TestlerModel(
        id: json["ID"] == null ? null : json["ID"],
        aciklama: json["aciklama"] == null ? null : json["aciklama"],
        glink: json["glink"] == null ? null : json["glink"],
        dogru: json["dogru"] == null ? null : json["dogru"],
        yanlis1: json["yanlis1"] == null ? null : json["yanlis1"],
        yanlis2: json["yanlis2"] == null ? null : json["yanlis2"],
        dil: json["dil"] == null ? null : json["dil"],
    );

    Map<String, dynamic> toJson() => {
        "ID": id == null ? null : id,
        "aciklama": aciklama == null ? null : aciklama,
        "glink": glink == null ? null : glink,
        "dogru": dogru == null ? null : dogru,
        "yanlis1": yanlis1 == null ? null : yanlis1,
        "yanlis2": yanlis2 == null ? null : yanlis2,
        "dil": dil == null ? null : dil,
    };
}
