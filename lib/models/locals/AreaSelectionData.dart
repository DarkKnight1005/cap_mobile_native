import 'dart:convert';

AreaSelectionData areaSelectionDataFromJson(String str) => AreaSelectionData.fromJson(json.decode(str));

String areaSelectionDataToJson(AreaSelectionData data) => json.encode(data.toJson());

class AreaSelectionData {
    AreaSelectionData({
        required this.title,
        required this.selectionType,
    });

    final String? title;
    final SelectionType? selectionType;

    factory AreaSelectionData.fromJson(Map<String, dynamic> json) => AreaSelectionData(
        title: json["title"],
        selectionType: json["selectionType"] == null ? null : SelectionType.fromJson(json["selectionType"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "selectionType": selectionType?.toJson()
    };
}

class SelectionType {
    SelectionType({
        required this.buttonType,
        this.subsections,
    });

    final ButtonType? buttonType;
    final List<String>? subsections;

    factory SelectionType.fromJson(Map<String, dynamic> json) => SelectionType(
        buttonType: json["buttonType"] == null ? null : json["buttonType"] as ButtonType,
        subsections: json["subsections"] == null ? null : List<String>.from(json["subsections"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "buttonType": buttonType,
        "subsections": subsections == null ? null : List<String>.from(subsections!.map((x) => x)),
    };
}

enum ButtonType{
  BUTTON,
  DROPDOWN
}
