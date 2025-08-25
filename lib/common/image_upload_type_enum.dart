enum ImageTypeEnum {
  siteImage("site_image"),
  siteDocument("site_document"),
  clientDocument("client_document"),
  staffDocument("staff_document"),
  pickedImage("pickup_image"),
  vehicleImage("vehicle_image"),
  depositImage("deposit_image");

  const ImageTypeEnum(this.value);
  final String value;

  String get status {
    switch (this) {
      case ImageTypeEnum.siteImage:
        return "site_image";
      case ImageTypeEnum.siteDocument:
        return "site_document";
      case ImageTypeEnum.clientDocument:
        return "client_document";
      case ImageTypeEnum.staffDocument:
        return "staff_document";
      case ImageTypeEnum.pickedImage:
        return "pickup_image";
      case ImageTypeEnum.depositImage:
        return "deposit_image";
      case ImageTypeEnum.vehicleImage:
        return "vehicle_image";
    }
  }

  static ImageTypeEnum create(String status) {
    switch (status.toUpperCase()) {
      case "site_image":
        return ImageTypeEnum.siteImage;
      case "site_document":
        return ImageTypeEnum.siteDocument;
      case "client_document":
        return ImageTypeEnum.clientDocument;
      case "staff_document":
        return ImageTypeEnum.staffDocument;
      case "pickup_image":
        return ImageTypeEnum.pickedImage;
      case "deposit_image":
        return ImageTypeEnum.depositImage;
      case "vehicle_image":
        return ImageTypeEnum.vehicleImage;
      default:
        throw ArgumentError("Invalid status: $status");
    }
  }
}
