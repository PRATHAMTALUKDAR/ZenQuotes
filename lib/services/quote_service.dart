import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:random_quotes/models/quote_model.dart';

class QuoteService {
  static const base = "https://favqs.com/api/qotd";
  Future<Quote> getQuote() async {
    final res = await http.get(Uri.parse(base));
    if(res.statusCode == 200){
      return Quote.fromJson(jsonDecode(res.body)["quote"]);
    }
    else{
      throw Exception("Can't load quote");
    }
  }
}