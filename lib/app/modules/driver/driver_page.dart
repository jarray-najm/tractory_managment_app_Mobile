import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractory/utils/constants.dart';
import '../../data/models/driver_Model.dart';
import 'driver_controller.dart';

class DriverPage extends GetView<DriverController> {
  final TextEditingController _filterController = TextEditingController();

  DriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Drivers',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Constants.azreg,
        actions: [
          IconButton(
              onPressed: () => controller.fetchDrivers(),
              icon: Icon(
                Icons.refresh_outlined,
              ))
        ],
        toolbarHeight: 50,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.value.isNotEmpty) {
            return Center(
                child: Text(controller.errorMessage.value,
                    style: TextStyle(color: Colors.red)));
          } else {
            return Column(
              children: [
                TextFormField(
                  controller: _filterController,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    controller.filterDrivers(value.toLowerCase());
                  },
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Filter by Driver name',
                    prefixIcon: const Icon(Icons.search_outlined, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                // Show "No Results" message if no drivers are found
                if (controller.filteredDrivers.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text('No Results',
                          style: TextStyle(color: Colors.grey, fontSize: 18)),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.filteredDrivers.length,
                      itemBuilder: (context, index) {
                        final driver = controller.filteredDrivers[index];
                        return Card(
                          elevation: 1,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10.0),
                            title: Text("${driver.id} | ${driver.name}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(driver.phone),
                                Text(driver.licenseNumber),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon:
                                      Icon(Icons.edit, color: Constants.azreg),
                                  onPressed: () => _showDriverDialog(context,
                                      driver: driver),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => Get.defaultDialog(
                                    title: 'Delete Driver',
                                    middleText:
                                        'Are you sure you want to delete this driver?',
                                    confirm: ElevatedButton(
                                      onPressed: () {
                                        controller.deleteDriver(driver.id!);
                                        Get.back(); // Close dialog
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      child: Text(
                                        'Delete',
                                      ),
                                    ),
                                    cancel: TextButton(
                                      onPressed: () =>
                                          Get.back(), // Close dialog
                                      child: Text(
                                        'Cancel',
                                      ),
                                    ),
                                    titlePadding:
                                        EdgeInsets.symmetric(vertical: 20),
                                    contentPadding: EdgeInsets.all(20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDriverDialog(context),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Constants.azreg,
      ),
    );
  }

  void _showDriverDialog(BuildContext context, {Driver? driver}) {
    final isEdit = driver != null;
    final nameController =
        TextEditingController(text: isEdit ? driver!.name : '');
    final licenseNumberController =
        TextEditingController(text: isEdit ? driver!.licenseNumber : '');
    final phoneController =
        TextEditingController(text: isEdit ? driver!.phone : '');

    final _formKey = GlobalKey<FormState>(); // Key for the Form
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    Get.defaultDialog(
      titlePadding: EdgeInsets.symmetric(vertical: 10),
      contentPadding: EdgeInsets.all(20),
      radius: 10,
      title: isEdit ? 'Edit Driver' : 'Add Driver',
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueGrey.withOpacity(.1),
                  hintText: "Name",
                  prefixIcon: Icon(
                    Icons.person,
                    size: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLength: 50, // Maximum length of 50 characters
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  } else if (value.length > 50) {
                    return 'Name cannot exceed 50 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: licenseNumberController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueGrey.withOpacity(.1),
                  hintText: "License Number",
                  prefixIcon: const Icon(Icons.credit_card, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLength: 20, // Maximum length of 20 characters
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a license number';
                  } else if (value.length > 20) {
                    return 'License number cannot exceed 20 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueGrey.withOpacity(.1),
                  hintText: "Phone",
                  prefixIcon: const Icon(Icons.phone, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLength: 15, // Maximum length of 15 characters
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  } else if (value.length > 15) {
                    return 'Phone number cannot exceed 15 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            final newDriver = Driver(
              id: isEdit ? driver!.id : null,
              name: nameController.text,
              licenseNumber: licenseNumberController.text,
              phone: phoneController.text,
            );

            if (isEdit) {
              controller.updateDriver(newDriver);
            } else {
              controller.addDriver(newDriver);
            }

            Get.back(); // Close dialog
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? Constants.azreg : Constants.ktiba),
        child: Text(
          isEdit ? 'Update Driver' : 'Add Driver',
          style: TextStyle(
              color: isDark ? Constants.secondaryColor : Constants.azreg),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(), // Close dialog
        child: Text(
          'Cancel',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}