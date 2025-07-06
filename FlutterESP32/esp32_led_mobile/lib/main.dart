import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http paketini import et

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP32 LED Kontrol',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LedControlPage(),
    );
  }
}

class LedControlPage extends StatefulWidget {
  const LedControlPage({super.key});

  @override
  State<LedControlPage> createState() => LedControlPageState();
}

class LedControlPageState extends State<LedControlPage> {
  String _responseMessage = 'Henüz istek gönderilmedi.';

  String _ledStatus = "Unknown";
  final String springBootIp =
      'YOUR SPRING BOOT IP ADDRESS';
  final String springBootPort = 'YOUR SPRING BOOT PORT NUMBER'; 

  Future<void> _display(int number) async {
    final Uri uri = Uri.parse(
        'http://$springBootIp:$springBootPort/api/led/setDisplay?value=$number');

    setState(() {
      _responseMessage = 'İstek gönderiliyor...';
    });

    try {
     
      final http.Response response = await http.get(uri);

     
      if (response.statusCode == 200) {
       
        print('Sayı $number Spring Boot\'a başarıyla gönderildi!');
        print('Spring Boot Yanıtı: ${response.body}');
        setState(() {
          _responseMessage = 'Başarılı: ${response.body}';
        });
      } else {
        
        print(
            'Sayı $number Spring Boot\'a gönderilemedi. Durum kodu: ${response.statusCode}');
        print('Spring Boot Hata: ${response.body}');
        setState(() {
          _responseMessage =
              'Hata: Durum Kodu ${response.statusCode}, Yanıt: ${response.body}';
        });
      }
    } catch (e) {
      print('Spring Boot\'a sayı gönderirken hata oluştu: $e');
      setState(() {
        _responseMessage = 'Bağlantı Hatası: $e';
      });
    }
  }

  Future<void> _controlLed(String state) async {
    try {
      final response = await http.get(Uri.parse('$springBootIp:$springBootPort$state'));

      if (response.statusCode == 200) {
        setState(() {
          _ledStatus = response.body; 
        });
        print('LED kontrol başarılı: ${response.body}');
      } else {
        setState(() {
          _ledStatus = 'Hata';
        });
        print('LED kontrol başarısız');
      }
    } catch (e) {
      setState(() {
        _ledStatus = 'Bağlantı Hatası';
      });
      print('HTTP isteği hatası');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    TextEditingController num_control = TextEditingController();
    int num2;
    return Scaffold(
      appBar: AppBar(
        title: Text("ESP32 LED CONTROL"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(12)),
              child: Text(
                "LED STATUS: $_ledStatus",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () => _controlLed("on"),
              style: ElevatedButton.styleFrom(
                minimumSize:
                    Size(200, 50), // Minimum 200 genişlik, 50 yükseklik
                padding: EdgeInsets.symmetric(
                    horizontal: 30, vertical: 15), // İç boşluk
              ),
              child: Text(
                "OPEN",
                style: TextStyle(fontSize: 24),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () => _controlLed("off"),
              style: ElevatedButton.styleFrom(
                minimumSize:
                    Size(200, 50), // Minimum 200 genişlik, 50 yükseklik
                padding: EdgeInsets.symmetric(
                    horizontal: 30, vertical: 15), // İç boşluk
              ),
              child: Text(
                "CLOSE",
                style: TextStyle(fontSize: 24),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: num_control,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'NUMBER TO SEND (0-999)',
                border: OutlineInputBorder(),
              ),
            ),
            FloatingActionButton(
              onPressed: () => {
                num2 = int.parse(num_control.text),
                if (num2 != null && num2 >= 0 && num2 < 1000)
                  {
                    _display(num2),
                  }
              },
            ),
          ],
        ),
      ),
    );
  }
}
