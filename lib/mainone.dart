import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'final.dart';


class SubcategoryScreen extends StatelessWidget {
  final String categoryCode;

  SubcategoryScreen({required this.categoryCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S U B C A T E G O R I E S',style: TextStyle(

            fontWeight: FontWeight.w600,
            fontSize: 25
        ),),
      ),
      body: SubcategoryList(categoryCode: categoryCode),
    );
  }
}

class SubcategoryList extends StatefulWidget {
  final String categoryCode;

  SubcategoryList({required this.categoryCode});

  @override
  _SubcategoryListState createState() => _SubcategoryListState();
}

class _SubcategoryListState extends State<SubcategoryList> {
  List<dynamic> subcategories = [];

  @override
  void initState() {
    super.initState();
    fetchSubcategories();
  }

  Future<void> fetchSubcategories() async {
    final response = await http.get(Uri.parse('http://154.26.130.251:302/SubCategory/GetbyCategoryCode?OrganizationId=1&CategoryCode=${widget.categoryCode}'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['Status'] == true) {
        setState(() {
          subcategories = data['Data'];
        });
      }
    } else {
      throw Exception('Failed to load subcategories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return subcategories.isEmpty
        ? const Center(child:
    Center(child:
    Column(crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hourglass_empty_outlined,size: 30,),
              Text('None',style: TextStyle(fontSize: 25),),
            ],
          )),
    )
        : ListView.builder(
      itemCount: subcategories.length,
      itemBuilder: (context, index) {
        final subcategory = subcategories[index];
        return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 40,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ], // Shadow
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.purpleAccent,
                              Colors.black
                            ], // Define your gradient colors
                          ),
                        ),
                        child: ListTile(
            title: Text(subcategory['Name'],style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),),
            onTap: () {
              Get.to(ProductScreen(
                categoryCode: widget.categoryCode,
                subcategoryCode: subcategory['Code'],
              ));
            },
          ),
        )));
      },
    );
  }
}