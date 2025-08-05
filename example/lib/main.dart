import 'package:flutter/material.dart';
import 'package:freshfield/freshfield.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_html/flutter_html.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freshfield Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final freshfield = FreshfieldService();
  List<Update> updates = [];
  bool isLoading = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    freshfield.init('your-api-key');
    _loadUpdates();
  }

  Future<void> _loadUpdates() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final result = await freshfield.getUpdates(limit: 5, offset: 0);
      setState(() {
        updates = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Freshfield Updates'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : error.isNotEmpty
                ? Text('Error: $error')
                : ListView.builder(
                    itemCount: updates.length,
                    itemBuilder: (context, index) {
                      final update = updates[index];
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(update.title, style: Theme.of(context).textTheme.titleMedium),
                            Text(
                              'ID: ${update.id} • ${update.created.toLocal().toString().split('.')[0]}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Html(
                              data: update.description,
                              style: {
                                "body": Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                ),
                              },
                            ),
                            if (update.features.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text('Features:', style: Theme.of(context).textTheme.titleSmall),
                              const SizedBox(height: 4),
                              ...update.features.map((feature) => Padding(
                                    padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: [
                                        if (feature.icon != null)
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: SvgPicture.string(
                                              feature.icon!,
                                              width: 16,
                                              height: 16,
                                              colorFilter: ColorFilter.mode(
                                                Theme.of(context).colorScheme.onSurface,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(feature.name,
                                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context).colorScheme.primaryContainer,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Text(
                                                      feature.type,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(feature.description, style: Theme.of(context).textTheme.bodySmall),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ],
                        ),
                        isThreeLine: true,
                      );
                    },
                  ),
      ),
    );
  }
}
