library todo;

import 'dart:convert';
import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:client/item.dart';

part 'todo.dart';
part 'items_backend.dart';

void main() {
  var module = new Module()
      ..bind(Todo)
      ..bind(ItemsBackend);

  applicationFactory().addModule(module).run();
}

