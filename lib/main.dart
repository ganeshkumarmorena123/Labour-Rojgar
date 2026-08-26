import 'package:flutter/material.dart';

void main() => runApp(const LabourRojgarApp());

class LabourRojgarApp extends StatelessWidget {
  const LabourRojgarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Labour Rojgar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const RoleScreen(),
    );
  }
}

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Labour Rojgar')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            const Icon(Icons.handshake, size: 90),
            const SizedBox(height: 20),
            const Text(
              'काम मिले आसान, रोजगार बने सम्मान',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 35),
            FilledButton.icon(
              icon: const Icon(Icons.construction),
              label: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'मुझे काम चाहिए',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const JobsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.business_center),
              label: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'मुझे मजदूर चाहिए',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PostJobScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  final List<Map<String, String>> jobs = const [
    {
      'title': 'राजमिस्त्री की जरूरत',
      'pay': '₹900 / दिन',
      'place': 'भोपाल',
      'days': '5 दिन',
    },
    {
      'title': 'पेंटर की जरूरत',
      'pay': '₹700 / दिन',
      'place': 'भोपाल',
      'days': '3 दिन',
    },
    {
      'title': 'निर्माण मजदूर चाहिए',
      'pay': '₹650 / दिन',
      'place': 'भोपाल',
      'days': '2 दिन',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('उपलब्ध काम')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: jobs.length,
        itemBuilder: (_, i) {
          final job = jobs[i];

          return Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.work),
              ),
              title: Text(job['title']!),
              subtitle: Text(
                '${job['place']} • ${job['days']}',
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    job['pay']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FilledButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'आवेदन सफलतापूर्वक भेज दिया गया',
                          ),
                        ),
                      );
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final work = TextEditingController();
  final workers = TextEditingController();
  final pay = TextEditingController();
  final location = TextEditingController();

  @override
  void dispose() {
    work.dispose();
    workers.dispose();
    pay.dispose();
    location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('काम पोस्ट करें'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: work,
            decoration: const InputDecoration(
              labelText: 'कौन सा काम है?',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: workers,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'कितने मजदूर चाहिए?',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: pay,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'प्रति दिन मजदूरी ₹',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: location,
            decoration: const InputDecoration(
              labelText: 'काम की जगह',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: () {
              if (work.text.isEmpty ||
                  workers.text.isEmpty ||
                  pay.text.isEmpty ||
                  location.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('कृपया सभी जानकारी भरें'),
                  ),
                );
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('काम सफलतापूर्वक पोस्ट हो गया'),
                ),
              );

              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'काम पोस्ट करें',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
