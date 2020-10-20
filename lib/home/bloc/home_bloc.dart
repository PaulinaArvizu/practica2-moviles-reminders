import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:pract_dos/models/todo_reminder.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // DONE: inicializar la box
  //referencia a box previamente abierta (en main)
  Box _reminderBox = Hive.box("Reminder");

  HomeBloc() : super(HomeInitialState());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is OnLoadRemindersEvent) {
      try {
        List<TodoRemainder> _existingReminders = _loadReminders();
        yield LoadedRemindersState(todosList: _existingReminders);
      } on DatabaseDoesNotExist catch (_) {
        yield NoRemindersState();
      } on EmptyDatabase catch (_) {
        yield NoRemindersState();
      }
    }
    if (event is OnAddElementEvent) {
      _saveTodoReminder(event.todoReminder);
      yield NewReminderState(todo: event.todoReminder);
    }
    if (event is OnReminderAddedEvent) {
      yield AwaitingEventsState();
    }
    if (event is OnRemoveElementEvent) {
      _removeTodoReminder(event.removedAtIndex);
    }
  }

  List<TodoRemainder> _loadReminders() {
    // DONE: ver si existen datos To-doRemainder en la box y sacarlos como Lista (no es necesario hacer get ni put)
    // debe haber un adapter para que la BD pueda detectar el objeto
    if (_reminderBox.isNotEmpty) {
      return List<TodoRemainder>.from(_reminderBox.get("reminders"));
    }
    throw EmptyDatabase();
  }

  void _saveTodoReminder(TodoRemainder todoReminder) {
    // DONE:add item here
    var reminderList = List();
    if (_reminderBox.isNotEmpty) reminderList = _reminderBox.get("reminders");
    reminderList.add(todoReminder);
    _reminderBox.put("reminders", reminderList);
  }

  void _removeTodoReminder(int removedAtIndex) {
    // DONE:delete item here
    var reminderList = List();
    if (_reminderBox.isNotEmpty) {
      reminderList = _reminderBox.get("reminders");
      reminderList.removeAt(removedAtIndex);
      _reminderBox.put("reminders", reminderList);
    }
  }
}

class DatabaseDoesNotExist implements Exception {}

class EmptyDatabase implements Exception {}
