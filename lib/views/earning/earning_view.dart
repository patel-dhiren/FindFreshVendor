import 'package:flutter/material.dart';
import 'package:fresh_find_vendor/firebase/firebase_service.dart';
import 'package:shimmer/shimmer.dart';

class EarningView extends StatefulWidget {
  const EarningView({super.key});

  @override
  State<EarningView> createState() => _EarningViewState();
}

class _EarningViewState extends State<EarningView> {
  // var todayEarnings = 345.6;
  // var monthEarnings = 2335.6;
  // var totalEarnings = 4554.00;

  late Future<double> todayEarnings;
  late Future<double> monthEarnings;
  late Future<double> totalEarnings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final monthStart = DateTime(now.year, now.month, 1);
    final startOfTime = DateTime(1970, 1, 1);

    todayEarnings = FirebaseService().getEarnings(todayStart, DateTime.now());
    monthEarnings = FirebaseService().getEarnings(monthStart, DateTime.now());
    totalEarnings = FirebaseService().getEarnings(startOfTime, DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 20),
          FutureBuilder<double>(
            future: todayEarnings,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {

                var amount = snapshot.data ?? 0.0;

                return Card(
                  elevation: 4,
                  color: Colors.green.shade50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Earnings',
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Today',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.green),
                              ),
                            ),
                            Text(
                              'Rs. ${amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                        // You can add more details or functionalities like a breakdown of earnings
                      ],
                    ),
                  ),
                );
                return Text(
                    "Today's Earnings: \$${snapshot.data?.toStringAsFixed(2)}");
              }
              return _buildShimmerEffect();
            },
          ),

          SizedBox(
            height: 16,
          ),

          FutureBuilder<double>(
            future: monthEarnings,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {

                var amount = snapshot.data ?? 0.0;

                return Card(
                  elevation: 4,
                  color: Colors.indigo.shade50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Earnings',
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'This Month',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.indigo),
                              ),
                            ),
                            Text(
                              'Rs. ${amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                        // You can add more details or functionalities like a breakdown of earnings
                      ],
                    ),
                  ),
                );
                return Text(
                    "This Month's Earnings: \$${snapshot.data?.toStringAsFixed(2)}");
              }
              return _buildShimmerEffect();
            },
          ),

          SizedBox(
            height: 16,
          ),

          FutureBuilder<double>(
            future: totalEarnings,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {

                var amount = snapshot.data ?? 0.0;

                return Card(
                  elevation: 4,
                  color: Colors.orange.shade50,
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Earnings',
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Total Earning',
                                style: TextStyle(fontSize: 18, color: Colors.orange),
                              ),
                            ),
                            Text(
                              'Rs. ${amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                        // You can add more details or functionalities like a breakdown of earnings
                      ],
                    ),
                  ),
                );
                return Text(
                    "Total Earnings: \$${snapshot.data?.toStringAsFixed(2)}");
              }
              return _buildShimmerEffect();
            },
          ),


          // Add more widgets or functionality as needed
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 40.0,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 15.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
