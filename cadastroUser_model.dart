import 'dart:convert';

class User {    
  int id;
  String name;
  String mobilePhone;

  User({
        int _id,
        String _name,
        String _mobilePhone}):
        assert(id != null),
        assert(name != null),
        assert(mobilePhone != null),
        this._id = id,
        this._name = name,
        this._mobilePhone = mobilePhone;

  int get id => _id;

  set id(int value) {
    this._id = value;
  }
  String get name => _name;

  set name(String value) {
    this._name = value;
  }
  String get mobilePhone => _mobilePhone;

  set mobilePhone(String value) {
    this._mobilePhone = value;
  }

}
