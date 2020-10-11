// ignore_for_file: unused_import, prefer_const_constructors
// Ignored so that uncommenting the code to mock HTP requests is simple.
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/fake_marvel.dart';
import 'src/marvel.dart';
import 'src/screens/character_detail.dart';
import 'src/screens/home.dart';

final dio = Provider((ref) => Dio());

enum ItemType { job, story, comment, poll, pollopt }

@Freezed(key: 'type')
abstract class Item with _Item {
  factory Item.story({
    @required String by,
    @required int descendants,
    @required int id,
    @required List<int> kids,
    @required int score,
    @TimestampDecoder() @required DateTime time,
    @required String title,
    @required String url,
  }) = Story;

  factory Item.comment({
    @required String by,
    @required int id,
    @required List<int> kids,
    @required int parent,
    @StripHtmlDecoder() @required String text,
    @TimestampDecoder() @required DateTime time,
  }) = Comment;

  factory Item.job({
    @required String by,
    @required int id,
    @required int score,
    @StripHtmlDecoder() @required String text,
    @TimestampDecoder() @required DateTime time,
    @required String url,
  }) = Job;

  factory Item.poll({
    @required String by,
    @required int descendants,
    @required int id,
    @required List<int> kids,
    @required List<int> parts,
    @required int score,
    @StripHtmlDecoder() @required String text,
    @TimestampDecoder() @required DateTime time,
    @required String title,
  }) = Poll;

  factory Item.pollopt({
    @required String by,
    @required int id,
    @required int score,
    @StripHtmlDecoder() @required String text,
    @TimestampDecoder() @required DateTime time,
    @required String title,
  }) = PollOpt;
}

final maxItemId = FutureProvider<int>((ref) async {
  final response = await ref
      .watch(dio)
      .get<int>('https://hacker-news.firebaseio.com/v0/maxitem.json');
  return response.data;
});

final item = FutureProvider<List<int>>((ref) async {
  final response = await ref.watch(dio).get<Map<String, dynamic>>(
      'https://hacker-news.firebaseio.com/v0/maxitem.json');

  return Item.fromJson(response.data);
});

class List extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return watch(maxItemId).when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error $err')),
      data: (maxItemId) {
        return ListView.builder(
          itemCount: maxItemId,
          itemBuilder: (context, id) {
            return watch(item).when(
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error $err'),
              data: (item) => Text(item.text),
            );
          },
        );
      },
    );
  }
}

void main() {
  runApp(
    ProviderScope(
      // uncomment to mock the HTTP requests

      // overrides: [
      //   repositoryProvider.overrideWithProvider(
      //     Provider(
      //       (ref) => MarvelRepository(ref, client: FakeDio(null)),
      //     ),
      //   ),
      // ],
      child: MyApp(),
    ),
  );
}

class MyApp extends HookWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      builder: (context, child) {
        return _Unfocus(
          child: child,
        );
      },
      home: const Portal(child: Home()),
      onGenerateRoute: (settings) {
        if (settings?.name == null) {
          return null;
        }
        final split = settings.name.split('/');
        Widget result;
        if (settings.name.startsWith('/characters/') && split.length == 3) {
          result = ProviderScope(
            overrides: [
              selectedCharacterId.overrideWithValue(split.last),
            ],
            child: const CharacterView(),
          );
        }

        if (result == null) {
          return null;
        }
        return MaterialPageRoute<void>(builder: (context) => result);
      },
      routes: {
        '/character': (c) => const CharacterView(),
      },
    );
  }
}

/// A widget that unfocus everything when tapped.
///
/// This implements the "Unfocus when tapping in empty space" behavior for the
/// entire application.
class _Unfocus extends HookWidget {
  const _Unfocus({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
