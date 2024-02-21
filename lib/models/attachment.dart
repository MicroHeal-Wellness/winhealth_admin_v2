

class Attachment {
    String? id;
    String? storage;
    String? filenameDisk;
    String? filenameDownload;
    String? title;
    String? type;
    dynamic folder;
    dynamic uploadedBy;
    DateTime? uploadedOn;
    dynamic modifiedBy;
    DateTime? modifiedOn;
    dynamic charset;
    String? filesize;
    dynamic width;
    dynamic height;
    dynamic duration;
    dynamic embed;
    dynamic description;
    dynamic location;
    dynamic tags;
    dynamic metadata;

    Attachment({
        this.id,
        this.storage,
        this.filenameDisk,
        this.filenameDownload,
        this.title,
        this.type,
        this.folder,
        this.uploadedBy,
        this.uploadedOn,
        this.modifiedBy,
        this.modifiedOn,
        this.charset,
        this.filesize,
        this.width,
        this.height,
        this.duration,
        this.embed,
        this.description,
        this.location,
        this.tags,
        this.metadata,
    });

    factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json["id"],
        storage: json["storage"],
        filenameDisk: json["filename_disk"],
        filenameDownload: json["filename_download"],
        title: json["title"],
        type: json["type"],
        folder: json["folder"],
        uploadedBy: json["uploaded_by"],
        uploadedOn: json["uploaded_on"] == null ? null : DateTime.parse(json["uploaded_on"]),
        modifiedBy: json["modified_by"],
        modifiedOn: json["modified_on"] == null ? null : DateTime.parse(json["modified_on"]),
        charset: json["charset"],
        filesize: json["filesize"],
        width: json["width"],
        height: json["height"],
        duration: json["duration"],
        embed: json["embed"],
        description: json["description"],
        location: json["location"],
        tags: json["tags"],
        metadata: json["metadata"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "storage": storage,
        "filename_disk": filenameDisk,
        "filename_download": filenameDownload,
        "title": title,
        "type": type,
        "folder": folder,
        "uploaded_by": uploadedBy,
        "uploaded_on": uploadedOn?.toIso8601String(),
        "modified_by": modifiedBy,
        "modified_on": modifiedOn?.toIso8601String(),
        "charset": charset,
        "filesize": filesize,
        "width": width,
        "height": height,
        "duration": duration,
        "embed": embed,
        "description": description,
        "location": location,
        "tags": tags,
        "metadata": metadata,
    };
}