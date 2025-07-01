// // screens/management_screen.dart
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class ManagementScreen extends StatefulWidget {
//   final String title;
//   final String endpoint;
//
//   const ManagementScreen({super.key, required this.title, required this.endpoint});
//
//   @override
//   State<ManagementScreen> createState() => _ManagementScreenState();
// }
//
// class _ManagementScreenState extends State<ManagementScreen> {
//   List<dynamic> items = [];
//   final baseUrl = 'http://10.0.2.2:8000/api/';
//
//   @override
//   void initState() {
//     super.initState();
//     fetchItems();
//   }
//
//   Future<void> fetchItems() async {
//     final response = await http.get(Uri.parse('$baseUrl${widget.endpoint}'));
//     if (response.statusCode == 200) {
//       setState(() {
//         items = json.decode(response.body);
//       });
//     }
//   }
//
//   Future<void> deleteItem(int id) async {
//     final response = await http.delete(Uri.parse('$baseUrl${widget.endpoint}/$id'));
//     if (response.statusCode == 200) {
//       fetchItems();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.title)),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Logic thêm dữ liệu sẽ đặt ở đây
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: ListView.separated(
//         itemCount: items.length,
//         separatorBuilder: (_, __) => const Divider(),
//         itemBuilder: (context, index) {
//           final item = items[index];
//           return ListTile(
//             title: Text(item['name'] ?? item['title'] ?? 'Không có tiêu đề'),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.orange),
//                   onPressed: () {
//                     // Logic sửa dữ liệu ở đây
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => deleteItem(item['id']),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
