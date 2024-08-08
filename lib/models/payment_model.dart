class Payments {
    String? id;
    String? userCreated;
    DateTime? dateCreated;
    dynamic userUpdated;
    dynamic dateUpdated;
    String? patients;
    int? amount;
    String? modeOfPayment;
    String? paymentReference;
    DateTime? paymentDate;

    Payments({
        this.id,
        this.userCreated,
        this.dateCreated,
        this.userUpdated,
        this.dateUpdated,
        this.patients,
        this.amount,
        this.modeOfPayment,
        this.paymentReference,
        this.paymentDate,
    });

    factory Payments.fromJson(Map<String, dynamic> json) => Payments(
        id: json["id"],
        userCreated: json["user_created"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        userUpdated: json["user_updated"],
        dateUpdated: json["date_updated"],
        patients: json["patients"],
        amount: json["amount"],
        modeOfPayment: json["mode_of_payment"],
        paymentReference: json["payment_reference"],
        paymentDate: json["payment_date"] == null ? null : DateTime.parse(json["payment_date"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_created": userCreated,
        "date_created": dateCreated?.toIso8601String(),
        "user_updated": userUpdated,
        "date_updated": dateUpdated,
        "patients": patients,
        "amount": amount,
        "mode_of_payment": modeOfPayment,
        "payment_reference": paymentReference,
        "payment_date": "${paymentDate!.year.toString().padLeft(4, '0')}-${paymentDate!.month.toString().padLeft(2, '0')}-${paymentDate!.day.toString().padLeft(2, '0')}",
    };
}