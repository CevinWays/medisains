import 'package:flutter/material.dart';
import 'package:medisains/helpers/constant_routes.dart';
import 'package:medisains/helpers/toast_helper.dart';
import 'package:medisains/pages/category/layout/category_page.dart';
import 'package:medisains/pages/category/layout/form_category_page.dart';
import 'package:medisains/pages/content/layout/content_page.dart';
import 'package:medisains/pages/content/layout/form_content_page.dart';

class Routes{
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case contentPage:
        return MaterialPageRoute(builder: (_) => ContentPage());
      case categoryPage:
        return MaterialPageRoute(builder: (_) => CategoryPage());
        break;
      case contentFormPage:
        return MaterialPageRoute(builder: (_) => FormContentPage());
      case categoryFormPage:
        return MaterialPageRoute(builder: (_) => FormCategoryPage());
      default:
        return ToastHelper.showFlutterToast("Halaman ${routeSettings.name} tidak ada");
    }
  }
}