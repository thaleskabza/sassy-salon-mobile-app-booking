import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';
import '../models/service_model.dart';
import '../services/api_service.dart';
import '../storage/local_cache.dart';

class ViewBookingsScreen extends StatefulWidget {
  const ViewBookingsScreen({super.key});

  @override
  State<ViewBookingsScreen> createState() => _ViewBookingsScreenState();
}

class _ViewBookingsScreenState extends State<ViewBookingsScreen> {
  bool loading = true;
  List<BookingModel> bookings = [];
  Map<String, ServiceModel> serviceMap = {};

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() => loading = true);

    try {
      final userInfo = await LocalCache.getUserInfo();
      final cellphone = userInfo['cellphone'];

      final svcList = await ApiService.fetchServices();
      final svcMap = {for (var s in svcList) s.id: s};

      final bookingList = await ApiService.fetchBookingsFilteredByCell(cellphone!);
      await LocalCache.saveBookingList(bookingList.map((b) => b.toJson()).toList());

      setState(() {
        bookings = bookingList;
        serviceMap = svcMap;
        loading = false;
      });
    } catch (e) {
      final cached = await LocalCache.getCachedBookingList();
      final svcList = await ApiService.fetchServices();
      final svcMap = {for (var s in svcList) s.id: s};

      setState(() {
        bookings = cached.map((j) => BookingModel.fromJson(j)).toList();
        serviceMap = svcMap;
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Loaded offline data')),
      );
    }
  }

  String _formatDate(String iso) {
    final dt = DateTime.parse(iso);
    return DateFormat('EEE, MMM d @ HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.deepPurple,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/view_bookings_background.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                RefreshIndicator(
                  onRefresh: _loadBookings,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      final service = serviceMap[booking.serviceId];

                      return Card(
                        color: Colors.white.withOpacity(0.9),
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            service?.name ?? booking.serviceId,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.deepPurple,
                            ),
                          ),
                          subtitle: Text(
                            '${_formatDate(booking.startTime)}\nRef: ${booking.reference}',
                            style: const TextStyle(color: Colors.black87),
                          ),
                          trailing: Text(
                            'R${service?.price ?? "?"}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
