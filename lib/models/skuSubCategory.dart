class ClassSUB {
  List<Classifications>? classifications;

  ClassSUB({this.classifications});

  ClassSUB.fromJson(Map<String, dynamic> json) {
    if (json['classifications'] != null) {
      classifications = <Classifications>[];
      json['classifications'].forEach((v) {
        classifications!.add(new Classifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.classifications != null) {
      data['classifications'] =
          this.classifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Classifications {
  int? catId;
  int? qty;

  Classifications({this.catId, this.qty});

  Classifications.fromJson(Map<String, dynamic> json) {
    catId = json['catId'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['catId'] = this.catId;
    data['qty'] = this.qty;
    return data;
  }
}
