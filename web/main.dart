library todo;

import 'dart:html';
import 'dart:convert';
import 'package:http/browser_client.dart';
import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:Vane_Angular_Todo/item.dart';

part 'todo.dart';
part 'items_backend.dart';

void main() {
  var module = new Module()
    ..bind(ItemsBackend);

  applicationFactory()
    .addModule(module)
    .rootContextType(Todo)
    .run();
}

