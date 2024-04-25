import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import '../Drawer/MyDrawarCard.dart';
import '../Widget/dropdown.dart';
import '../Widget/list_Options.dart';
import '../Widget/widgetInputText.dart';

class MeetingMaster extends StatefulWidget {
  const MeetingMaster({Key? key}) : super(key: key);

  @override
  _MeetingMasterState createState() => _MeetingMasterState();
}

class _MeetingMasterState extends State<MeetingMaster> {
  Timer? revertTimer;
  bool showAdditionalOptions = false;
  DateTime? selectedDate;
  String selectedOption = '';
  TimeOfDay? selectedTime;
  String selectedRequire = 'Require';
  String selectedMeeting = 'Meeting';
  bool useSoft = false;
  String selectedWebsiteType = 'Basic';
  bool useComputer = false;
  bool websiteCheckbox = false;
  bool typeofwebsite = false;
  late ListOptions listOptions;
  // Text editing controllers for various input fields
  TextEditingController controllerCompanyname = TextEditingController();
  TextEditingController controllerClientname = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerArea = TextEditingController();
  TextEditingController controllerCity = TextEditingController();
  TextEditingController controllerMobileNumber = TextEditingController();
  TextEditingController controllerMobileNumberAlt = TextEditingController();
  TextEditingController controllerRequired = TextEditingController();
  TextEditingController controllerMeeting = TextEditingController();
  // Focus nodes for handling text field focus
  FocusNode companynameFocusNode = FocusNode();
  FocusNode clientnameFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode areaFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode mobilenumFocusNode = FocusNode();
  FocusNode mobilenumaltFocusNode = FocusNode();
  FocusNode requireFocusNode = FocusNode();
  FocusNode meetingFocusNode = FocusNode();
  void clearvalue() {
    // Check if required fields are filled, and clear values accordingly
    if (controllerCompanyname.text.isNotEmpty &&
        controllerClientname.text.isNotEmpty &&
        controllerAddress.text.isNotEmpty) {
      // Clear values if all required fields are filled
      controllerCompanyname.clear();
      controllerClientname.clear();
      controllerAddress.clear();
      controllerArea.clear();
      controllerCity.clear();
      controllerMobileNumber.clear();
      controllerMobileNumberAlt.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fill required details'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        // You can do something with the selected date here
      });
    }
  }

  // Function to show the time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        // You can do something with the selected time here
      });
    }
  }

  // Dispose of focus nodes and cancel the timer
  void moveToNextField(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // Function to build additional options based on the selected requirement
  Widget buildAdditionalOptions() {
    if (selectedRequire == 'Software') {
      return Column(
        children: [
          Row(
            children: [
              const Text('Use Soft'),
              Checkbox(
                value: useSoft,
                onChanged: (value) {
                  setState(() {
                    useSoft = value ?? true;
                  });
                },
              ),
              const Text('Yes'),
              Checkbox(
                value: !useSoft,
                onChanged: (value) {
                  setState(() {
                    useSoft = !(value ?? false);
                  });
                },
              ),
              const Text('No'),
            ],
          ),
          Row(
            children: [
              const Text('Computer'),
              Checkbox(
                value: useComputer,
                onChanged: (value) {
                  setState(() {
                    useComputer = value ?? false;
                  });
                },
              ),
              const Text('Yes'),
              Checkbox(
                value: !useComputer,
                onChanged: (value) {
                  setState(() {
                    useComputer = !(value ?? false);
                  });
                },
              ),
              const Text('No'),
            ],
          ),
        ],
      );
    } else if (selectedRequire == 'Website') {
      return Column(
        children: [
          Row(
            children: [
              const Text('Website'),
              Checkbox(
                value: websiteCheckbox,
                onChanged: (value) {
                  setState(() {
                    websiteCheckbox = value ?? false;
                  });
                },
              ),
              const Text('Yes'),
              Checkbox(
                value: !websiteCheckbox,
                onChanged: (value) {
                  setState(() {
                    websiteCheckbox = !(value ?? false);
                  });
                },
              ),
              const Text('No'),
            ],
          ),
          Row(
            children: [
              const Text('Type of website'),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: selectedWebsiteType,
                items: ['Basic', 'E-commerce'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      selectedWebsiteType = value;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((options) {
      setState(() {
        listOptions = options;
        selectedDate = DateTime.now(); // Set default date to today
        selectedTime = TimeOfDay.now(); //time
      });
    }).catchError((error) {
      // Handle errors during data fetching
      print("Error fetching data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting Master'),
      ),
      drawer: MyDrawarCard(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    WidgetTextField(
                      controller: controllerCompanyname,
                      focusNode: companynameFocusNode,
                      labelText: 'Company Name',
                      keyboardType: TextInputType.text,
                      onEditingComplete: () {
                        moveToNextField(
                            companynameFocusNode, clientnameFocusNode);
                      },
                    ),
                    WidgetTextField(
                      controller: controllerClientname,
                      focusNode: clientnameFocusNode,
                      labelText: 'Client Name',
                      keyboardType: TextInputType.text,
                      onEditingComplete: () {
                        moveToNextField(clientnameFocusNode, addressFocusNode);
                      },
                    ),
                    WidgetTextField(
                      controller: controllerAddress,
                      focusNode: addressFocusNode,
                      labelText: 'Address',
                      keyboardType: TextInputType.text,
                      onEditingComplete: () {
                        moveToNextField(addressFocusNode, areaFocusNode);
                      },
                    ),
                    WidgetTextField(
                      controller: controllerArea,
                      focusNode: areaFocusNode,
                      labelText: 'Area',
                      keyboardType: TextInputType.text,
                      onEditingComplete: () {
                        moveToNextField(areaFocusNode, cityFocusNode);
                      },
                    ),
                    WidgetTextField(
                      controller: controllerCity,
                      focusNode: cityFocusNode,
                      labelText: 'City',
                      keyboardType: TextInputType.text,
                      onEditingComplete: () {
                        moveToNextField(cityFocusNode, mobilenumFocusNode);
                      },
                    ),
                    WidgetTextField(
                      controller: controllerMobileNumber,
                      focusNode: mobilenumFocusNode,
                      labelText: 'Mobile No',
                      keyboardType: TextInputType.number,
                      onEditingComplete: () {
                        moveToNextField(
                            mobilenumFocusNode, mobilenumaltFocusNode);
                      },
                    ),
                    WidgetTextField(
                      controller: controllerMobileNumberAlt,
                      focusNode: mobilenumaltFocusNode,
                      labelText: 'Mobile No Alt',
                      keyboardType: TextInputType.number,
                      onEditingComplete: () {
                        moveToNextField(
                            mobilenumaltFocusNode, mobilenumFocusNode);
                      },
                    ),
                    const SizedBox(height: 10.0),
                    DropdownWidget(
                      selectedValue: selectedRequire,
                      options: listOptions.selectedRequireOptions,
                      labelText: 'Require',
                      onTap: (value) {
                        setState(() {
                          selectedRequire = value;
                          useSoft = false;
                          useComputer = false;
                        });
                      },
                      focusNode: requireFocusNode,
                    ),
                    buildAdditionalOptions(),
                    const SizedBox(height: 10.0),
                    DropdownWidget(
                      selectedValue: selectedMeeting,
                      options: listOptions.selectedMeetingOptions,
                      labelText: 'Meeting',
                      onTap: (value) {
                        setState(() {
                          selectedMeeting = value;
                        });
                      },
                      focusNode: meetingFocusNode,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          icon: const Icon(Icons.calendar_today),
                        ),
                        Text(
                          selectedDate != null
                              ? 'Date: ${DateFormat('dd MMM yyyy').format(selectedDate!)}'
                              : 'Select Date',
                        ),
                        const SizedBox(
                            width: 2), // Add some space between date and time
                        IconButton(
                          onPressed: () {
                            _selectTime(context);
                          },
                          icon: const Icon(Icons.access_time),
                        ),
                        Text(
                          selectedTime != null
                              ? 'Time: ${selectedTime!.format(context)}'
                              : 'Select Time',
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: TextButton(
                  onPressed: () async {
                    // Check if company name is not empty
                   if (controllerCompanyname.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fill required details'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      // Try to save the meeting details
                      try {
                        clearvalue();
                      } catch (e) {
                        // Print an error message if there's an issue saving the meeting details
                        print("Error saving meeting details: $e");
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  child: const Text(
                    "SAVE",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
