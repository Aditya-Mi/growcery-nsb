import 'dart:convert';

import 'package:grocery_app/features/products/data/category.dart';
import 'package:grocery_app/features/products/data/product.dart';
import 'package:http/http.dart' as http;

class ProductRepositoryApi {
  String url = 'https://growcery-x6sg.onrender.com/api/v1/items';

  Future<List<Product>> getAllProducts() async {
    try {
      var response = await http.get(Uri.parse('$url/allitems'));

      var result = jsonDecode(response.body)['data']['data'];
      List<Product> products =
          result.map<Product>((model) => Product.fromJson(model)).toList();
      return products;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Category>> getAllCategories() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };
    try {
      var response = await http.get(Uri.parse('$url/categories/allcategories'),
          headers: headers);
      var result = jsonDecode(response.body)['categories'];
      List<Category> categories =
          result.map<Category>((model) => Category.fromJson(model)).toList();
      return categories;
    } catch (e) {
      throw e.toString();
    }
  }
}
