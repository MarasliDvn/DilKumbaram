// To parse this JSON data, do
//
//     final kaynaklarModel = kaynaklarModelFromJson(jsonString);

// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

KaynaklarModel kaynaklarModelFromJson(String str) => KaynaklarModel.fromJson(json.decode(str));

String kaynaklarModelToJson(KaynaklarModel data) => json.encode(data.toJson());

class KaynaklarModel {
    KaynaklarModel({
        this.id,
        this.kategori,
        this.dil,
        this.pdf,
    });

    String? id;
    String? kategori;
    String? dil;
    String? pdf;

    factory KaynaklarModel.fromJson(Map<String, dynamic> json) => KaynaklarModel(
        id: json["ID"] == null ? null : json["ID"],
        kategori: json["kategori"] == null ? null : json["kategori"],
        dil: json["dil"] == null ? null : json["dil"],
        pdf: json["pdf"] == null ? null : json["pdf"],
    );

    Map<String, dynamic> toJson() => {
        "ID": id == null ? null : id,
        "kategori": kategori == null ? null : kategori,
        "dil": dil == null ? null : dil,
        "pdf": pdf == null ? null : pdf,
    };
}
