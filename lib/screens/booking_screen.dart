import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/service_model.dart';
import '../services/api_service.dart';
import '../storage/local_cache.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final player = AudioPlayer();

  List<ServiceModel> services = [];
  ServiceModel? selectedService;

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final dateTimeCtrl = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final userInfo = await LocalCache.getUserInfo();
    nameCtrl.text = userInfo['name'] ?? '';
    emailCtrl.text = userInfo['email'] ?? '';
    phoneCtrl.text = userInfo['cellphone'] ?? '';

    try {
      final svc = await ApiService.fetchServices();
      setState(() {
        services = svc;
        loading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load services')),
      );
    }
  }

  Future<void> _submit() async {
    await player.play(AssetSource('sounds/click.wav'));

    if (!_formKey.currentState!.validate() || selectedService == null) return;

    final payload = {
      "customer_name": nameCtrl.text.trim(),
      "email": emailCtrl.text.trim(),
      "cellphone": phoneCtrl.text.trim(),
      "service_id": selectedService!.id,
      "service_name":
          "${selectedService!.name} - R${selectedService!.price} (${selectedService!.duration} min)",
      "start_time": dateTimeCtrl.text.trim(),
    };

    try {
      await LocalCache.saveUserInfo(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        cellphone: phoneCtrl.text.trim(),
      );

      final booking = await ApiService.bookService(payload);
      await player.play(AssetSource('sounds/success_when_booking_is_done.wav'));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Booking confirmed: ${booking.reference}')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Booking failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: Colors.deepPurple,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/booking_screen_background.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Image.asset('assets/images/ScutumCodicisLogo.png', height: 80),
                          const SizedBox(height: 20),
                          _buildTextInput(nameCtrl, 'Full Name'),
                          _buildTextInput(emailCtrl, 'Email', validator: (val) {
                            return val!.contains('@') ? null : 'Enter a valid email';
                          }),
                          _buildTextInput(phoneCtrl, 'Cellphone', validator: (val) {
                            return RegExp(r'^0[6-8]\d{8}$').hasMatch(val!)
                                ? null
                                : 'Enter valid SA number';
                          }),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<ServiceModel>(
                            value: selectedService,
                            decoration: const InputDecoration(labelText: 'Select Service'),
                            items: services
                                .map((s) => DropdownMenuItem(
                                      value: s,
                                      child: Text('${s.name} (R${s.price})'),
                                    ))
                                .toList(),
                            onChanged: (val) => setState(() {
                              selectedService = val;
                            }),
                            validator: (val) => val == null ? 'Please select a service' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: dateTimeCtrl,
                            decoration: const InputDecoration(labelText: 'Start Time'),
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              final dt = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 30)),
                              );
                              if (dt != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: const TimeOfDay(hour: 9, minute: 0),
                                );
                                if (time != null) {
                                  final full = DateTime(
                                      dt.year, dt.month, dt.day, time.hour, time.minute);
                                  dateTimeCtrl.text = full.toIso8601String();
                                }
                              }
                            },
                            validator: (val) => val!.isEmpty ? 'Pick a time' : null,
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            onPressed: _submit,
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Confirm Booking'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTextInput(TextEditingController controller, String label,
      {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: validator ?? (val) => val!.isEmpty ? 'Required' : null,
    );
  }
}
