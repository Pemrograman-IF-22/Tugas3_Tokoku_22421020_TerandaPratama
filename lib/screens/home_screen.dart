import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tokoku/models/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];

  @override
  void initState(){
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/products')
    );

    debugPrint('Response: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        _products = data.map(
          (json) => Product.fromJson(json)
        ).toList();
      });
    } else {
      throw Exception('Gagal mengambil data produk');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Tokoku'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index){
          final product = _products[index];

          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                  )
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4
                  ),
                  child: Text(
                    product.category,
                    style: TextStyle(
                      fontSize:12,
                      color: Colors.grey
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4
                  ),
                  child: Text(
                    product.title,
                    style: TextStyle(
                      fontSize:18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4
                  ),
                  child: Text(
                    '\$${product.price}',
                    style: TextStyle(
                      color: Colors.grey
                    ),
                  ),
                ),
              ],
            )
          );
        },
      ),
    );
  }
}