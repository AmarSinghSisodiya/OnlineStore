import 'package:flutter/material.dart';

class Calculation {

    FocusNode mrpFocusNode = FocusNode();

  static void autoFillRateAndDiscount({
    required TextEditingController mrpController,
    required TextEditingController rateController,
    required TextEditingController discountController,
    
  }) {
    if (rateController.text.isEmpty) {
      double mrp = double.tryParse(mrpController.text) ?? 0;
      rateController.text = mrp.toStringAsFixed(2);

      updateDiscount(
        mrpController: mrpController,
        rateController: rateController,
        discountController: discountController,
      );
    }
    updateRateAndDiscount(
      mrpController: mrpController,
      rateController: rateController,
      discountController: discountController,
      discountFocusNode: FocusNode(), // Dummy focus node
    );
  }

  static void updateRateAndDiscount({
    required TextEditingController mrpController,
    required TextEditingController rateController,
    required TextEditingController discountController,
    required FocusNode discountFocusNode,
  }) {
    double mrp = double.tryParse(mrpController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0;

    if (mrp > 0 && rate >= 0) {
      double discount = ((mrp - rate) / mrp) * 100;
      discountController.text = discount.toStringAsFixed(2);
    } else {
      clearRateAndDiscount(
        rateController: rateController,
        discountController: discountController,
      );
    }
    discountFocusNode.requestFocus();
  }

  static void updateRate({
    required TextEditingController mrpController,
    required TextEditingController discountController,
    required TextEditingController rateController,
  }) {
    double mrp = double.tryParse(mrpController.text) ?? 0;
    double discount =
        double.tryParse(discountController.text.replaceAll('%', '')) ?? 0;

    if (mrp > 0 && discount >= 0) {
      double rate = mrp - (mrp * discount / 100);
      rateController.text = rate.toStringAsFixed(2);
    } else {
      clearRate(rateController: rateController);
    }
  }

  static void updateDiscount({
    required TextEditingController mrpController,
    required TextEditingController rateController,
    required TextEditingController discountController,
  }) {
    double mrp = double.tryParse(mrpController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0;

    if (mrp > 0 && rate > 0) {
      double discount = ((mrp - rate) / mrp) * 100;
      discountController.text = discount.toStringAsFixed(2);
    } else {
      clearDiscount(discountController: discountController);
    }
  }

  static void clearRateAndDiscount({
    required TextEditingController rateController,
    required TextEditingController discountController,
  }) {
    rateController.text = '';
    discountController.text = '';
  }

  static void clearRate({
    required TextEditingController rateController,
  }) {
    rateController.text = '';
  }

  static void clearDiscount({
    required TextEditingController discountController,
  }) {
    discountController.text = '';
  }


  
}
