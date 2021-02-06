import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medisains/helpers/constant_routes.dart';
import 'package:medisains/helpers/toast_helper.dart';
import 'package:medisains/pages/auth/layouts/resetpass_page.dart';
import 'package:medisains/pages/category/layout/category_page.dart';
import 'package:medisains/pages/category/layout/form_category_page.dart';
import 'package:medisains/pages/content/layout/content_page.dart';
import 'package:medisains/pages/content/layout/edit_content_page.dart';
import 'package:medisains/pages/content/layout/form_content_page.dart';
import 'package:medisains/pages/content/model/content_model.dart';
import 'package:medisains/pages/home/home_page.dart';

class Routes{
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
      case contentPage:
        return MaterialPageRoute(builder: (_) => ContentPage(contentModel: routeSettings.arguments,));
      case categoryPage:
        return MaterialPageRoute(builder: (_) => CategoryPage());
      case contentFormPage:
        return MaterialPageRoute(builder: (_) => FormContentPage());
      case categoryFormPage:
        return MaterialPageRoute(builder: (_) => FormCategoryPage());
      case resetPassPage:
        return MaterialPageRoute(builder: (_) => ResetPassPage());
      case editContentPage:
        return MaterialPageRoute(builder: (_) => EditContentPage(contentModel: routeSettings.arguments,));
    }
  }
}