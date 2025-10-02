import 'package:flutter/material.dart';

void pop(NavigatorState navigator) {
  if (!navigator.canPop()) return;
  navigator.pop();
}
