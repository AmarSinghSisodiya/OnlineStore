class ProductMasterModel {
  final String? groupCode;
  final String? productName;
  final String? groupName;
  final String? printName;
  final int? taxAtPurchase;
  final int? taxAtSale;
  final String? unit;
  final int? askQty;
  final int? askRate;
  final int? useFIFO;
  final String? message;
  final double? wholeSalePrice;
  final double? salePrice;
  final double? costPrice;
  final double? discount;
  final String? picture;
  final String? picturetwo;
  final String? picturethree;
  final String? picturefour;
  final String? picturefive;
  final String? brandCode;
  final String? productMarathi;
  final int? appKeyCodeKey;
  final int? firmCodeKey;
  final String? productType;
  final int? dpRate;
  final double? spRate2;
  final double? spRate3;
  final int? minimumQty;
  final int? maximumQty;
  final int? minimumRate;
  final int? maximumRate;
  final int? taxApplicable;
  final int? emiApplicable;
  final int? stockManage;
  final String? option1;
  final String? option2;
  final String? option3;
  final int? taxAtMandi;
  final String? productCol1;
  final String? productCol2;
  final String? productCol3;
  final String? productCol4;
  final String? productCol5;
  final String? productCol6;
  final String? alternateUnit;
  final int? convertFactor;
  final String? convertType;
  final String? userId;
  final String? userName;
  final String? productInsertionType;
  int? productCode;
  int? id;
  final bool pendingFlag;
  final String? hsnCode;
  final bool sentToApi;
  final DateTime createdAt;
  final String? gst;
  final int? openingStock;

  ProductMasterModel({
    this.groupCode,
    this.productName,
    this.groupName,
    this.printName,
    this.taxAtPurchase,
    this.taxAtSale,
    this.unit,
    this.askQty,
    this.askRate,
    this.useFIFO,
    this.message,
    this.wholeSalePrice,
    this.salePrice,
    this.costPrice,
    this.discount,
    this.picture,
    this.picturetwo,
    this.picturethree,
    this.picturefour,
    this.picturefive,
    this.brandCode,
    this.productMarathi,
    this.firmCodeKey,
    this.appKeyCodeKey,
    this.productType,
    this.dpRate,
    this.spRate2,
    this.spRate3,
    this.minimumQty,
    this.maximumQty,
    this.minimumRate,
    this.maximumRate,
    this.taxApplicable,
    this.emiApplicable,
    this.stockManage,
    this.option1,
    this.option2,
    this.option3,
    this.taxAtMandi,
    this.productCol1,
    this.productCol2,
    this.productCol3,
    this.productCol4,
    this.productCol5,
    this.productCol6,
    this.alternateUnit,
    this.convertFactor,
    this.convertType,
    this.userId,
    this.userName,
    this.productInsertionType,
    this.id,
    this.productCode,
    required this.pendingFlag,
    required this.hsnCode,
    required this.sentToApi,
    required this.createdAt,
    required this.gst,
    this.openingStock,
  });

  factory ProductMasterModel.fromMap(Map<String, dynamic> map) {
    return ProductMasterModel(
      groupCode: map['groupCode'],
      productName: map['Product_Name'],
      groupName: map['groupName'],
      printName: map['printName'],
      taxAtPurchase: map['taxAtPurchase'],
      taxAtSale: map['taxAtSale'],
      unit: map['unit'],
      askQty: map['askQty'],
      askRate: map['askRate'],
      useFIFO: map['useFIFO'],
      message: map['Message'],
      wholeSalePrice: map['wholeSalePrice'],
      salePrice: map['Selling_Rate'] != null ? double.tryParse(map['Selling_Rate'].toString()) : null,
      costPrice: map['Cost_Price'] != null ? double.tryParse(map['Cost_Price'].toString()) : null,
      discount: map['discount'],
      picture: map['picture'],
      picturetwo: map['picturetwo'],
      picturethree: map['picturethree'],
      picturefour: map['picturefour'],
      picturefive: map['picturefive'],
      brandCode: map['brandCode'],
      productMarathi: map['productMarathi'],
      firmCodeKey: map['firmCodeKey'] ?? 5,
      appKeyCodeKey: map['appKeyCodeKey'] is int
          ? map['appKeyCodeKey']
          : int.tryParse(map['appKeyCodeKey'].toString()) ?? 3939,
      productType: map['Product_Type'],
      dpRate: map['dpRate'],
      spRate2: map['SP_Rate2'] != null ? double.tryParse(map['SP_Rate2'].toString()) : null,
      spRate3: map['SP_Rate3'] != null ? double.tryParse(map['SP_Rate3'].toString()) : null,
      minimumQty: map['minimumQty'],
      maximumQty: map['maximumQty'],
      minimumRate: map['minimumRate'],
      maximumRate: map['maximumRate'],
      taxApplicable: map['taxApplicable'],
      emiApplicable: map['emiApplicable'],
      stockManage: map['stockManage'],
      option1: map['option1'],
      option2: map['option2'],
      option3: map['Option3'],
      taxAtMandi: map['taxAtMandi'],
      productCol1: map['productCol1'],
      productCol2: map['productCol2'],
      productCol3: map['productCol3'],
      productCol4: map['productCol4'],
      productCol5: map['productCol5'],
      productCol6: map['productCol6'],
      alternateUnit: map['alternateUnit'],
      convertFactor: map['convertFactor'],
      convertType: map['convertType'],
      userId: map['userId'],
      userName: map['userName'],
      productInsertionType: map['productInsertionType'],
      id: map['id'] ?? 0,
      pendingFlag: map['pendingFlag'] == 1,
      hsnCode: map['hsnCode'],
      sentToApi: map['sentToApi'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0,
          isUtc: true),
      gst: map['gst'],
      openingStock: map['openingStock'],
      productCode: map['Product_Code']!= null ? int.tryParse(map['Product_Code'].toString()) : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'groupCode': groupCode ?? "0",
      'productName': productName ?? "",
      'groupName': groupName ?? "",
      'printName': printName ?? "",
      'taxAtPurchase': taxAtPurchase ?? "0",
      'taxAtSale': taxAtSale ?? "0",
      'unit': unit ?? "",
      'askQty': askQty ?? "0",
      'askRate': askRate ?? "0",
      'useFIFO': useFIFO ?? "0",
      'message': message ?? "",
      'wholeSalePrice': wholeSalePrice ?? "0",
      'salePrice': salePrice ?? "0",
      'costPrice': costPrice ?? "0",
      'discount': discount ?? "0",
      'picture': picture ?? "path",
      'picturetwo': picturetwo ?? "path",
      'picturethree': picturethree ?? "path",
      'picturefour': picturefour ?? "path",
      'picturefive': picturefive ?? "path",
      'brandCode': brandCode ?? "0",
      'productMarathi': productMarathi ?? "0",
      'firmCodeKey': firmCodeKey ?? "5",
      'appKeyCodeKey': appKeyCodeKey ?? "3939",
      'productType': productType ?? "",
      'dpRate': dpRate ?? "0",
      'spRate2': spRate2 ?? "0",
      'spRate3': spRate3 ?? "0",
      'minimumQty': minimumQty ?? "0",
      'maximumQty': maximumQty ?? "0",
      'minimumRate': minimumRate ?? "0",
      'maximumRate': maximumRate ?? "0",
      'taxApplicable': taxApplicable ?? "0",
      'emiApplicable': emiApplicable ?? "0",
      'stockManage': stockManage ?? "0",
      'option1': option1 ?? "0",
      'option2': option2 ?? "0",
      'Option3': option3 ?? "0",
      'taxAtMandi': taxAtMandi ?? "0",
      'productCol1': productCol1 ?? "0",
      'productCol2': productCol2 ?? "0",
      'productCol3': productCol3 ?? "0",
      'productCol4': productCol4 ?? "0",
      'productCol5': productCol5 ?? "0",
      'productCol6': productCol6 ?? "0",
      'alternateUnit': alternateUnit ?? "0",
      'convertFactor': convertFactor ?? "0",
      'convertType': convertType ?? "0",
      'userId': userId ?? " ",
      'userName': userName ?? "",
      'productInsertionType': productInsertionType ?? "",
      'id': id,
      'pendingFlag': pendingFlag ? 1 : 0,
      'hsnCode': hsnCode ?? "",
      'sentToApi': sentToApi ? 1 : 0,
      'createdAt': createdAt.toUtc().millisecondsSinceEpoch,
      'gst': gst ?? "",
      'openingStock': openingStock ?? "0",
      'productCode': productCode,
    };
  }
factory ProductMasterModel.fromJson(Map<String, dynamic> json) {
  return ProductMasterModel(
    groupCode: json['Group_Code'],
    productName: json['Product_Name'],
    groupName: json['Group_Name'],
    printName: json['Print_Name'],
    taxAtPurchase: json['Tax_At_Purchase'] is int ? json['Tax_At_Purchase'] : int.tryParse(json['Tax_At_Purchase'] ?? ''),
    taxAtSale: json['Tax_At_Sale'] is int ? json['Tax_At_Sale'] : int.tryParse(json['Tax_At_Sale'] ?? ''),
    unit: json['Unit'],
    askQty: json['Ask_Qty'],
    askRate: json['Ask_Rate'],
    useFIFO: json['Use_FIFO'],
    message: json['Message'],
    wholeSalePrice: json['Whole_Sale_Price'],
    salePrice: json['Selling_Rate'] ,
    costPrice: json['Cost_Price'] != null ? double.tryParse(json['Cost_Price'].toString()) : null,
    discount: json['Discount'],
    picture: json['Picture'],
    picturetwo: json['Picture_Two'],
    picturethree: json['Picture_Three'],
    picturefour: json['Picture_Four'],
    picturefive: json['Picture_Five'],
    brandCode: json['Brand_Code'],
    productMarathi: json['Product_Marathi'],
    appKeyCodeKey: json['AppKeyCodeKey'],
    firmCodeKey: json['FirmCodeKey'] != null ? int.tryParse(json['FirmCodeKey'].toString()) : null,
    productType: json['Product_Type'],
    dpRate: json['DP_Rate'],
    spRate2: json['SP_Rate2'],
    spRate3: json['SP_Rate3'],
    minimumQty: json['Minimum_Qty'],
    maximumQty: json['Maximum_Qty'],
    minimumRate: json['Minimum_Rate'],
    maximumRate: json['Maximum_Rate'],
    taxApplicable: json['Tax_Applicable'],
    emiApplicable: json['EMI_Applicable'],
    stockManage: json['Stock_Manage'],
    option1: json['Option1'],
    option2: json['Option2'],
    option3: json['Option3'],
    taxAtMandi: json['Tax_At_Mandi'],
    productCol1: json['Product_Col1'],
    productCol2: json['Product_Col2'],
    productCol3: json['Product_Col3'],
    productCol4: json['Product_Col4'],
    productCol5: json['Product_Col5'],
    productCol6: json['Product_Col6'],
    alternateUnit: json['Alternate_Unit'],
    convertFactor: json['Convert_Factor'],
    convertType: json['Convert_Type'],
    userId: json['User_ID'],
    userName: json['User_Name'],
    productInsertionType: json['Product_Insertion_Type'],
    id: json['ID'],
    productCode: json['Product_Code'] != null ? int.tryParse(json['Product_Code']) : null,
    pendingFlag: json['Pending_Flag'] == 1,
    hsnCode: json['HSN_Code'],
    sentToApi: json['Sent_To_Api'] == 1,
    gst: json['GST'],
    openingStock: json['Opening_Stock'],
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? 0, isUtc: true),
  );
}
}