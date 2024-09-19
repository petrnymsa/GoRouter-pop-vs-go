import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final observer = RouteObserver<ModalRoute>();

final router = GoRouter(initialLocation: '/profiles', observers: [
  observer
], routes: [
  GoRoute(path: '/profiles', builder: (context, state) => const ProfilesPage()),
  GoRoute(path: '/home', builder: (context, state) => const HomePage(), routes: [
    GoRoute(path: 'messages', builder: (context, state) => const UnderHomePage()),
  ]),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class ProfilesPage extends StatelessWidget {
  const ProfilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
      ),
      body: ListView(
        children: [
          ...List.generate(
              5,
              (i) => ListTile(
                    onTap: () async {
                      // COMMENT this showDialog and didPopNext on Home is always triggered.
                      await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Text('Profile $i'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ));
                      if (context.mounted) {
                        context.go('/home');
                      }
                    },
                    title: Text('Profile $i'),
                    trailing: const Icon(Icons.chevron_right),
                  )),
        ],
      ),
    );
  }
}

class _HomePageState extends State<HomePage> with RouteAware {
  @override
  void dispose() {
    observer.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    observer.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void didPush() {
    print('HOME: Did push');
    super.didPush();
  }

  @override
  void didPopNext() {
    print('HOME: didPopNext');
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                context.push('/profiles');
              },
              child: const Text('PUSH profiles'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/profiles');
              },
              child: const Text('GO profiles'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('/home/messages');
              },
              child: const Text('PUSH messages'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/home/messages');
              },
              child: const Text('GO messages'),
            ),
          ],
        ),
      ),
    );
  }
}

class UnderHomePage extends StatelessWidget {
  const UnderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Text('Messages'),
    );
  }
}
