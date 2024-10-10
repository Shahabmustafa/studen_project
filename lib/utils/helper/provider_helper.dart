import 'package:flutter/foundation.dart';

class TProviderHelper with ChangeNotifier{

  /// loading indicator

  bool _loading = false;

  bool get loading => _loading;

  loadingIndicator(bool value){
    _loading = value;
    notifyListeners();
  }


  /// select drop down type

  String? _type;

  String? get type => _type;

  selectType(String value){
    _type = value;
    if (kDebugMode) {
      print(_type);
    }
    notifyListeners();
  }

  /// service type for seller
  String? _serviceType;

  String? get serviceType => _serviceType;

  selectServiceType(String value) {
    _serviceType = value;
    notifyListeners();
  }

  String? _selectCity;

  String? get selectCity => _selectCity;

  city(String value) {
    _selectCity = value;
    notifyListeners();
  }




  String? _selectSkill;

  String? get selectSkill => _selectSkill;

  skill(String value) {
    _selectSkill = value;
    notifyListeners();
  }

}