// To parse this JSON data, do
//
//     final kaliplarModel = kaliplarModelFromJson(jsonString);

// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

KaliplarModel kaliplarModelFromJson(String str) => KaliplarModel.fromJson(json.decode(str));

String kaliplarModelToJson(KaliplarModel data) => json.encode(data.toJson());

class KaliplarModel {
    KaliplarModel({
        this.id,
        this.kategori,
        this.tanlami,
        this.yanlami,
        this.dil,
    });

    String? id;
    String? kategori;
    String? tanlami;
    String? yanlami;
    String? dil;

    factory KaliplarModel.fromJson(Map<String, dynamic> json) => KaliplarModel(
        id: json["ID"] == null ? null : json["ID"],
        kategori: json["kategori"] == null ? null : json["kategori"],
        tanlami: json["tanlami"] == null ? null : json["tanlami"],
        yanlami: json["yanlami"] == null ? null : json["yanlami"],
        dil: json["dil"] == null ? null : json["dil"],
    );

    Map<String, dynamic> toJson() => {
        "ID": id == null ? null : id,
        "kategori": kategori == null ? null : kategori,
        "tanlami": tanlami == null ? null : tanlami,
        "yanlami": yanlami == null ? null : yanlami,
        "dil": dil == null ? null : dil,
    };
}
