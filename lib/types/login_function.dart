import 'package:flutter/material.dart';
import 'dart:async';

typedef LoginFunction = Future<String> Function(BuildContext context, String username, String password);
