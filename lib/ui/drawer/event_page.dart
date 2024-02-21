import 'package:flutter/material.dart';
import 'package:albertians/ui/app_bars/app_bar.dart';
import 'package:albertians/ui/drawer/drawer.dart';
import 'package:albertians/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:albertians/models/db_helper.dart';
import 'package:clipboard/clipboard.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  _EventPage createState() => _EventPage();
}

class _EventPage extends State<EventPage> {
  late String department = '';

  @override
  void initState() {
    super.initState();
    _fetchDepartment();
  }

  Future<void> _fetchDepartment() async {
    final userData = await DBHelper.getUserData();
    setState(() {
      department = userData['department'] ?? '';
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EventPageAppBar(),
      drawer: const MyDrawer(),
      body: FutureBuilder(
        future: ApiService().getEvents(department),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Events found'));
          } else {
            return _buildJobList(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildJobList(List<Map<String, dynamic>> jobs) {
    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (BuildContext context, int index) {
        Map<String, dynamic> job = jobs[index];
        return _buildJobCard(context, job); // Pass context to _buildJobCard
      },
    );
  }

  Widget _buildJobCard(BuildContext context, Map<String, dynamic> job) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job['subject'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Linkify(
              onOpen: (link) =>
                  _launchURL(context, link.url), // Pass context to _launchURL
              text: job['job_details'] ?? '',
              linkStyle: const TextStyle(color: Colors.blue),
            ),
            const SizedBox(height: 8),
            // Image.network(
            //   'http://192.168.56.1/' + job['image'],
            // ),
            // const SizedBox(height: 8),
            const Text(
              'Registration Link:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () {
                _launchURL(context, job['link']);
              },
              child: Text(
                job['link'] ?? '',
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatDate(job[
                  'created_at']), // Assuming 'created_at' is a DateTime field
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    await FlutterClipboard.copy(url);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard')),
    );
  }

  String _formatDate(DateTime? date) {
    if (date != null) {
      return DateFormat.yMMMd()
          .format(date); // You can use any date format you prefer
    } else {
      return '';
    }
  }
}
