import 'package:flutter/material.dart';
import '../models/country.dart';
import '../services/country_service.dart';

class CountryScreen extends StatefulWidget {
  @override
  _CountryScreenState createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  final CountryService _countryService = CountryService();
  late Future<List<Country>> _futureCountries;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  void _loadCountries() {
    _futureCountries = _countryService.getCountries();
  }

  void _showForm({Country? country}) {
    final nameController = TextEditingController(text: country?.name ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(country == null ? 'Thêm quốc gia' : 'Sửa quốc gia'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Tên quốc gia'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return;

              try {
                if (country == null) {
                  await _countryService.createCountry(name);
                } else {
                  await _countryService.updateCountry(country.id, name);
                }
                Navigator.pop(context);
                setState(_loadCountries);
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi: ${e.toString()}')),
                );
              }
            },
            child: Text('Lưu'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Country country) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Xoá quốc gia'),
        content: Text('Bạn có chắc muốn xoá "${country.name}" không?'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await _countryService.deleteCountry(country.id);
                Navigator.pop(context);
                setState(_loadCountries);
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi: ${e.toString()}')),
                );
              }
            },
            child: Text('Xoá'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách quốc gia')),
      body: FutureBuilder<List<Country>>(
        future: _futureCountries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasError) {
            print("❌ Lỗi FutureBuilder: ${snapshot.error}");
            return Center(child: Text('❌ Lỗi: ${snapshot.error.toString()}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('Không có quốc gia nào'));

          final countries = snapshot.data!;
          return ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final country = countries[index];
              return ListTile(
                title: Text(country.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showForm(country: country),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _confirmDelete(country),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
