// To parse this JSON data, do
//
//     final kgModel = kgModelFromJson(jsonString);

// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

KgModel kgModelFromJson(String str) => KgModel.fromJson(json.decode(str));

String kgModelToJson(KgModel data) => json.encode(data.toJson());

class KgModel {
    KgModel({
        this.id,
        this.kategori,
        this.tanlami,
        this.yanlami,
        this.glink,
        this.slink,
    });

    String? id;
    String? kategori;
    String? tanlami;
    String? yanlami;
    String? glink;
    String? slink;
    factory KgModel.fromJson(Map<String, dynamic> json) => KgModel(
        id: json["ID"] == null ? null : json["ID"],
        kategori: json["kategori"] == null ? null : json["kategori"],
        tanlami: json["tanlami"] == null ? null : json["tanlami"],
        yanlami: json["yanlami"] == null ? null : json["yanlami"],
        glink: json["glink"] == null ? null : json["glink"],
        slink: json["slink"] == null ? null : json["slink"],
    );

    Map<String, dynamic> toJson() => {
        "ID": id == null ? null : id,
        "kategori": kategori == null ? null : kategori,
        "tanlami": tanlami == null ? null : tanlami,
        "yanlami": yanlami == null ? null : yanlami,
        "glink": glink == null ? null : glink,
        "slink": slink == null ? null : slink,
    };
}
