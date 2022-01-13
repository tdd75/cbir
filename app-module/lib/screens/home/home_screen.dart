import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/providers/api.dart';

import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/home/search_screen.dart';
import 'package:shop_app/widgets/products_grid.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _textSeach = 'Search item ...';
  dynamic _productsData;

  Widget _getSearchGesture(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute<String>(
          builder: (BuildContext context) => const SearchScreen(),
          fullscreenDialog: true,
        ))
            .then((content) async {
          if (content != null && content.trim().isNotEmpty) {
            final prefs = await SharedPreferences.getInstance();
            final token = json.decode(prefs.getString("userData")!)["token"];
            Api.searchProducts(token, content).then((response) {
              setState(() {
                _productsData = response['data'];
                _textSeach = content;
              });
            });
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        width: 290,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                const SizedBox(width: 10),
                Text(
                  _textSeach,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  elevation: 16,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  onChanged: (String? newValue) async {
                    final ImagePicker _picker = ImagePicker();
                    final imageFile;
                    if (newValue == 'Camera') {
                      imageFile =
                          await _picker.pickImage(source: ImageSource.camera);
                    } else {
                      imageFile =
                          await _picker.pickImage(source: ImageSource.gallery);
                    }

                    dynamic response = await Api.searchByImage(imageFile);

                    setState(() {
                      _productsData = response['data'];
                      _textSeach = response['data'][0]['category'];
                    });
                  },
                  items: <String>['Camera', 'Photo']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 35),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 50,
                left: 10,
                right: 10,
              ),
              child: FutureBuilder(
                future: Provider.of<Products>(context, listen: false)
                    .fetchAndSetProducts(_productsData),
                builder: (ctx, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: () => _refresh(),
                            child: const ProductsGrid(),
                          ),
              ),
            ),
            Container(
              height: 45,
              color: Colors.white,
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _getSearchGesture(context),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      print("Favourite");
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
