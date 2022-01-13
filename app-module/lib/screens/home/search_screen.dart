import 'package:flutter/material.dart';
import 'package:shop_app/widgets/custom_button.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';
  const SearchScreen({Key? key}) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  InputDecoration _getCustomDecoration() {
    var _tmpBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    );

    return InputDecoration(
      focusedBorder: _tmpBorder,
      disabledBorder: _tmpBorder,
      errorBorder: _tmpBorder,
      focusedErrorBorder: _tmpBorder,
      enabledBorder: _tmpBorder,
      filled: true,
      contentPadding: const EdgeInsets.all(10.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? searchContent;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Row(
          children: [
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(
              height: 40,
              width: 320,
              child: TextField(
                // onChanged: (value) => searchContent = value,
                decoration: _getCustomDecoration(),
                autofocus: true,
                onSubmitted: (value) => Navigator.of(context).pop(value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
