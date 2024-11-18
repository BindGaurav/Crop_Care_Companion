import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ThingSpeak Configuration
class ThingSpeakConfig {
  static const String baseUrl = "https://api.thingspeak.com";
  static const String channelId = "2716041"; // Replace with your channel ID
  static const String readApiKey =
      "3DBY1HP84DH873TM"; // Replace with your read API key

  static String get channelFeedEndpoint =>
      "$baseUrl/channels/$channelId/feeds.json?api_key=$readApiKey&results=1";
}

// API Configuration for Prediction Service
class ApiConfig {
  static const String baseUrl = "http://192.168.137.199:8000";
  static String get predictionEndpoint => "$baseUrl/predict";
  static String get healthEndpoint => "$baseUrl/health";
}

// Data Models
class SensorData {
  final DateTime timestamp;
  final double temperature;
  final double humidity;
  final double moisture;
  final double N;
  final double phosphorus;
  final double potassium;

  SensorData({
    required this.timestamp,
    required this.temperature,
    required this.humidity,
    required this.moisture,
    required this.N,
    required this.phosphorus,
    required this.potassium,
  });

  factory SensorData.fromThingSpeak(Map<String, dynamic> feed) {
    return SensorData(
      timestamp: DateTime.parse(
          feed['created_at'] ?? DateTime.now().toIso8601String()),
      temperature: double.tryParse(feed['field1'] ?? '0') ?? 0,
      humidity: double.tryParse(feed['field2'] ?? '0') ?? 0,
      moisture: double.tryParse(feed['field3'] ?? '0') ?? 0,
      N: double.tryParse(feed['field4'] ?? '0') ?? 0,
      phosphorus: double.tryParse(feed['field5'] ?? '0') ?? 0,
      potassium: double.tryParse(feed['field6'] ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'temperature': temperature,
        'humidity': humidity,
        'moisture': moisture,
        'N': N,
        'P': phosphorus,
        'K': potassium,
      };
}

class PredictionResult {
  final String crop;
  final double confidence;

  PredictionResult({
    required this.crop,
    required this.confidence,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      crop: json['predicted_crop'] ?? 'Unknown',
      confidence: (json['confidence'] ?? 0).toDouble(),
    );
  }
}

// ThingSpeak Service
class ThingSpeakService {
  Future<SensorData> getLatestSensorData() async {
    try {
      final response = await http
          .get(Uri.parse(ThingSpeakConfig.channelFeedEndpoint))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final feeds = data['feeds'] as List;
        if (feeds.isEmpty) {
          throw Exception('No data available from ThingSpeak');
        }

        return SensorData.fromThingSpeak(feeds.first);
      } else {
        throw Exception(
            'Failed to fetch ThingSpeak data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching ThingSpeak data: $e');
    }
  }
}

// Widgets
class ConnectionStatusIcon extends StatelessWidget {
  final bool isConnected;

  const ConnectionStatusIcon({
    Key? key,
    required this.isConnected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          isConnected ? Icons.wifi : Icons.wifi_off,
          key: ValueKey(isConnected),
          color: isConnected ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}

class DataCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String? subtitle;
  final double elevation;

  const DataCard({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    this.subtitle,
    this.elevation = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: iconColor,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LastUpdatedCard extends StatelessWidget {
  final DateTime? lastUpdate;

  const LastUpdatedCard({
    Key? key,
    required this.lastUpdate,
  }) : super(key: key);

  String _formatDateTime(DateTime dateTime) {
    // Convert to IST by adding 5 hours and 30 minutes
    final istDateTime =
        dateTime.toUtc().add(const Duration(hours: 5, minutes: 30));
    return "${istDateTime.hour.toString().padLeft(2, '0')}:${istDateTime.minute.toString().padLeft(2, '0')}:${istDateTime.second.toString().padLeft(2, '0')} IST";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Last Updated: ${lastUpdate != null ? _formatDateTime(lastUpdate!) : 'Never'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// Main Screen
class CropPredictionScreen extends StatefulWidget {
  const CropPredictionScreen({Key? key}) : super(key: key);

  @override
  CropPredictionScreenState createState() => CropPredictionScreenState();
}

class CropPredictionScreenState extends State<CropPredictionScreen> {
  final ThingSpeakService _thingSpeakService = ThingSpeakService();
  Timer? _timer;
  SensorData? _latestSensorData;
  PredictionResult? _prediction;
  bool _isLoading = false;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkConnection() async {
    try {
      // Check ThingSpeak connection
      await _thingSpeakService.getLatestSensorData();

      // Check prediction service connection
      final response = await http
          .get(Uri.parse(ApiConfig.healthEndpoint))
          .timeout(const Duration(seconds: 5));

      setState(() {
        _isConnected = response.statusCode == 200;
      });

      if (_isConnected) {
        _startAutoUpdate();
      }
    } catch (e) {
      setState(() {
        _isConnected = false;
      });
      _showError('Cannot connect to services. Please check your connection.');
    }
  }

  void _startAutoUpdate() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _fetchData();
    });
    _fetchData();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _fetchData() async {
    if (_isLoading) return;

    try {
      setState(() => _isLoading = true);

      // Fetch sensor data from ThingSpeak
      final sensorData = await _thingSpeakService.getLatestSensorData();

      // Get prediction from your prediction service
      final predictionResponse = await http
          .post(
            Uri.parse(ApiConfig.predictionEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(sensorData.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (predictionResponse.statusCode == 200) {
        final predictionData = jsonDecode(predictionResponse.body);
        setState(() {
          _latestSensorData = sensorData;
          _prediction = PredictionResult.fromJson(predictionData);
          _isConnected = true;
        });
      } else {
        throw Exception(
            'Failed to fetch prediction: ${predictionResponse.statusCode}');
      }
    } catch (e) {
      setState(() => _isConnected = false);
      _showError('Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Prediction'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          ConnectionStatusIcon(isConnected: _isConnected),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchData,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(2.0),
            children: [
              LastUpdatedCard(lastUpdate: _latestSensorData?.timestamp),
              const SizedBox(height: 2),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                children: [
                  DataCard(
                    icon: Icons.thermostat,
                    iconColor: Colors.orange,
                    title: 'Temperature',
                    value: _latestSensorData != null
                        ? '${_latestSensorData!.temperature.toStringAsFixed(1)}°C'
                        : 'N/A',
                  ),
                  DataCard(
                    icon: Icons.water_drop,
                    iconColor: Colors.blue,
                    title: 'Humidity',
                    value: _latestSensorData != null
                        ? '${_latestSensorData!.humidity.toStringAsFixed(1)}%'
                        : 'N/A',
                  ),
                  DataCard(
                    icon: Icons.water,
                    iconColor: Colors.blue,
                    title: 'Moisture',
                    value: _latestSensorData != null
                        ? '${_latestSensorData!.moisture.toStringAsFixed(1)}'
                        : 'N/A',
                  ),
                  DataCard(
                    icon: Icons.eco,
                    iconColor: Colors.green,
                    title: 'Nitrogen',
                    value: _latestSensorData != null
                        ? '${_latestSensorData!.N.toStringAsFixed(1)}'
                        : 'N/A',
                  ),
                  DataCard(
                    icon: Icons.spa,
                    iconColor: Colors.purple,
                    title: 'Phosphorus',
                    value: _latestSensorData != null
                        ? '${_latestSensorData!.phosphorus.toStringAsFixed(1)}'
                        : 'N/A',
                  ),
                  DataCard(
                    icon: Icons.grass,
                    iconColor: Colors.brown,
                    title: 'Potassium',
                    value: _latestSensorData != null
                        ? '${_latestSensorData!.potassium.toStringAsFixed(1)}'
                        : 'N/A',
                  ),
                ],
              ),
              const SizedBox(height: 2),
              DataCard(
                icon: Icons.agriculture,
                iconColor: Colors.green,
                title: 'Recommended Crop',
                value: _prediction?.crop ?? 'N/A',
                subtitle: _prediction != null
                    ? 'Confidence: ${_prediction!.confidence.toStringAsFixed(1)}%'
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Main App
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crop Prediction',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const CropPredictionScreen(),
    );
  }
}
