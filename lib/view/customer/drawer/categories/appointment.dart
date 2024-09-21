import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_service_finder/common/button/custom_button.dart';
import 'package:local_service_finder/utils/constant/colors.dart';
import 'package:local_service_finder/viewmodel/appotiment/appotiment_view_model.dart';

class Appointment extends StatefulWidget {
  final String scheduletTime;
  List<dynamic> daysSchedular;
  final String sellerId;
  final String sellerName;
  final String sellerLocation;
  final String sellerService;

  Appointment(
      {super.key,
        required this.scheduletTime,
        required this.daysSchedular,
        required this.sellerId,
        required this.sellerLocation,
        required this.sellerName,
        required this.sellerService});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  final AppotimentViewModel appotimentViewModel = AppotimentViewModel();
  final messageController = TextEditingController();

  bool isDateSelected = false;
  DateTime? selectedDateTime;


  Future<void> _selectDateTime(BuildContext context) async {
    // Assume this list comes from Firebase
    List daySchedule = widget.daysSchedular;
    String timeSchedule = widget.scheduletTime;  // This comes from Firebase

    // Map days of the week to their respective indices (Monday = 1, Sunday = 7)
    Map<String, int> daysMap = {
      "Monday": DateTime.monday,
      "Tuesday": DateTime.tuesday,
      "Wednesday": DateTime.wednesday,
      "Thursday": DateTime.thursday,
      "Friday": DateTime.friday,
      "Saturday": DateTime.saturday,
      "Sunday": DateTime.sunday,
    };

    // Get the valid days from the daySchedule
    List<int> validDays = daySchedule.map((day) => daysMap[day]!).toList();

    // Find the closest initialDate that satisfies the selectableDayPredicate
    DateTime initialDate = DateTime.now();
    while (!validDays.contains(initialDate.weekday)) {
      initialDate = initialDate.add(Duration(days: 1));
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      selectableDayPredicate: (DateTime date) {
        // Allow only the dates that match the valid days from daySchedule
        return validDays.contains(date.weekday);
      },
    );

    if (pickedDate != null) {
      // Parse the time range from the string
      List<String> timeParts = timeSchedule.split(' to ');
      TimeOfDay startTime = _parseTimeOfDay(timeParts[0].trim());
      TimeOfDay endTime = _parseTimeOfDay(timeParts[1].trim());

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: startTime,  // Set the initial time to the start of the range
      );

      if (pickedTime != null && _isTimeInRange(pickedTime, startTime, endTime)) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          isDateSelected = true;
        });
      } else {
        // Show an error message or alert if the time is not within the allowed range
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Selected time is outside the allowed range.'),
        ));
      }
    }
  }

// Helper method to parse a time string like "9:00 AM" to TimeOfDay
  TimeOfDay _parseTimeOfDay(String timeString) {
    final timeParts = timeString.split(' ');  // Split the time and period (AM/PM)
    final period = timeParts[1];  // Get AM or PM
    final time = timeParts[0].split(':');  // Split the hours and minutes

    int hour = int.parse(time[0]);
    int minute = time.length > 1 ? int.parse(time[1]) : 0;

    if (period == 'PM' && hour < 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

// Helper method to check if a time is within the specified range
  bool _isTimeInRange(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
    final now = DateTime.now();
    final startDateTime = DateTime(now.year, now.month, now.day, start.hour, start.minute);
    final endDateTime = DateTime(now.year, now.month, now.day, end.hour, end.minute);
    final selectedDateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    return selectedDateTime.isAfter(startDateTime) && selectedDateTime.isBefore(endDateTime);
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.toLocal()}".split(' ')[0] +
        " " +
        "${TimeOfDay(hour: dateTime.hour, minute: dateTime.minute).format(context)}";
  }

  @override
  Widget build(BuildContext context) {
    // print();
    // print(DateTime.now());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Place Appointment"),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: TColors.primaryColor,
                ),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Column(
                  children: [
                    Text('error'),
                    CircularProgressIndicator(
                      color: Colors.red,
                    )
                  ],
                ),
              );
            }
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.01,
                ),
                /// available time
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  shadowColor: TColors.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Available Time",
                          style: TextStyle(
                              color: TColors.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(widget.scheduletTime,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                /// appointment date
                isDateSelected ? Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  shadowColor: TColors.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Selected Date",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: TColors.primaryColor),
                        ),
                        Text(
                          _formatDateTime(selectedDateTime!),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ) : const SizedBox(),
                const SizedBox(
                  height: 10,
                ),
                /// message text field //////
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: "Take Message",
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                /// appointment date picker button /////
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: CustomButton(
                   hint: "Pick Appointment Date and Time",
                   width: double.infinity,
                   height: 50,
                   onTap: (){
                     _selectDateTime(context);
                   },
                 ),
               ),
                const SizedBox(
                  height: 20,
                ),
                const Spacer(),
                isDateSelected ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    hint: "Place Appointment",
                    width: double.infinity,
                    height: 50,
                    onTap: (){
                      appotimentViewModel.placeAppotiment(context, selectedDateTime!, messageController.text, widget.sellerId,);
                      },
                  ),
                ) : const SizedBox(),
              ],
            );
          },
        ));
  }
}