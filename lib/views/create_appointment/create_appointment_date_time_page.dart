import 'package:flutter/material.dart';
import 'package:instajobs/models/vendor_details_model.dart';
import 'package:instajobs/utils/app_styles.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/create_appointment/appointment_custom_app_bar.dart';
import 'package:instajobs/views/create_appointment/receipt_appointment_page.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateAppointmentDateTimePage extends StatefulWidget {
  final VendorDetailsModelData? vendorDetailsModel;

  const CreateAppointmentDateTimePage({
    super.key,
    required this.vendorDetailsModel,
  });

  @override
  State<CreateAppointmentDateTimePage> createState() =>
      _CreateAppointmentDateTimePageState();
}

class _CreateAppointmentDateTimePageState
    extends State<CreateAppointmentDateTimePage>
    with BaseClass {
  List<int> selectedIndices = [];
  String userSelectedSlot = '';
  String userSelectedDate = '';

  @override
  Widget build(BuildContext context) {
    final categories = widget.vendorDetailsModel?.userInfo?.category;
    final firstCategory = (categories != null && categories.isNotEmpty) ? categories[0] : null;



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Appointment'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          AppointmentCustomAppBar(showStepOne: false, showStepTwo: false),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select services for appointment',
                    style: AppStyles.font700_16().copyWith(color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      itemCount:
                      (firstCategory?.subCategory?.length) ?? 0,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        final isSelected = selectedIndices.contains(index);

                        final subCategories = firstCategory?.subCategory;
                        final subCategoryItem = (subCategories != null && subCategories.length > index) ? subCategories[index] : null;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedIndices.remove(index);
                              } else {
                                selectedIndices.add(index);
                              }
                            });
                          },
                          child: Container(
                            height: 120,
                            width: 120,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xffEBEBEB)),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: 5,
                                      bottom: 5,
                                    ),
                                    child: Icon(
                                      isSelected
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color:
                                      isSelected
                                          ? Colors.orange
                                          : Colors.orange,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: 50,
                                  child: Image(
                                    image: NetworkImage(
                                      widget
                                          .vendorDetailsModel
                                          ?.userInfo
                                          ?.category
                                          ?.elementAt(0)
                                          ?.categoryImage ??
                                          '',
                                    ),
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  widget.vendorDetailsModel?.userInfo?.category
                                      ?.elementAt(0)
                                      ?.subCategory
                                      ?.elementAt(index)
                                      ?.name ??
                                      '',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: AppStyles.font400_12().copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Appointment booking date',
                    style: AppStyles.font700_16().copyWith(color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Red color means not available',
                    style: AppStyles.font500_14().copyWith(
                      color: Colors.red.shade900,
                    ),
                  ),
                  SizedBox(height: 8),
                  HorizontalCalendar(
                    workingHours:
                    widget.vendorDetailsModel?.userInfo?.workingHours,
                    onDateSelected: (selectedDate) {
                      userSelectedDate = selectedDate.toIso8601String();
                      print('User selected: $selectedDate');
                      // enable button, show slots, etc.
                    },
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Appointment booking time',
                    style: AppStyles.font700_16().copyWith(color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  TimeSlotSelector(
                    workingHours:
                    widget.vendorDetailsModel?.userInfo?.workingHours,
                    onSlotSelected: (selectedSlot) {
                      userSelectedSlot = selectedSlot;
                      print('User selected slot: $selectedSlot');
                      // enable button, show confirmation, etc.
                    },
                  ),
                ],
              ),
            ),
          ),
          RoundedEdgedButton(
            buttonText: 'Continue',
            bottomMargin: 16,
            leftMargin: 16,
            rightMargin: 16,
            topMargin: 16,
            onButtonClick: () {
              if (selectedIndices.isEmpty) {
                showError(
                  title: 'Date & Time',
                  message: 'Please select at least one service',
                );

                return;
              }

              if (userSelectedDate.isEmpty || userSelectedSlot.isEmpty) {
                showError(
                  title: 'Date & Time',
                  message: 'Please select date and time',
                );

                return;
              }
              pushToNextScreen(
                context: context,
                destination: ReceiptAppointmentPage(
                  vendorDetailsModel: widget.vendorDetailsModel,
                  selectedIndices:selectedIndices,
                  userSelectedDate:userSelectedDate,
                  userSelectedSlot:userSelectedSlot,
                ),
              );
              // Proceed to next step with selected services, date, and slot
            },
          ),
        ],
      ),
    );
  }
}

class HorizontalCalendar extends StatefulWidget {
  final VendorDetailsModelDataUserInfoWorkingHours? workingHours;
  final void Function(DateTime)? onDateSelected;

  const HorizontalCalendar({
    super.key,
    required this.workingHours,
    this.onDateSelected,
  });

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  DateTime? selectedDate;

  List<DateTime> getDaysOfMonth() {
    final now = DateTime.now();
    final lastDay = DateTime(now.year, now.month + 1, 0);
    return List.generate(
      lastDay.day - now.day + 1,
          (i) => DateTime(now.year, now.month, now.day + i),
    );
  }

  bool isUnavailable(DateTime date) {
    final day = DateFormat('EEEE').format(date).toLowerCase();

    final hours = switch (day) {
      'monday' => widget.workingHours?.monday ?? "00:00 - 00:00",
      'tuesday' => widget.workingHours?.tuesday ?? "00:00 - 00:00",
      'wednesday' => widget.workingHours?.wednesday ?? "00:00 - 00:00",
      'thursday' => widget.workingHours?.thursday ?? "00:00 - 00:00",
      'friday' => widget.workingHours?.friday ?? "00:00 - 00:00",
      'saturday' => widget.workingHours?.saturday ?? "00:00 - 00:00",
      'sunday' => widget.workingHours?.sunday ?? "00:00 - 00:00",
      _ => null,
    };

    return hours == null || hours == '00:00 - 00:00';
  }

  @override
  Widget build(BuildContext context) {
    final days = getDaysOfMonth();

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (_, index) {
          final date = days[index];
          final unavailable = isUnavailable(date);
          final isSelected = selectedDate == date;

          final bgColor = isSelected ? Colors.orange : Colors.white;

          final textColor =
          isSelected
              ? Colors.white
              : unavailable
              ? Colors.red
              : Colors.black;

          return GestureDetector(
            onTap:
            unavailable
                ? null
                : () {
              setState(() {
                selectedDate = date;
              });
              if (widget.onDateSelected != null) {
                widget.onDateSelected!(date); // <-- trigger callback
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat('MMM d').format(date),
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TimeSlotSelector extends StatefulWidget {
  final VendorDetailsModelDataUserInfoWorkingHours? workingHours;
  final void Function(String selectedSlot)? onSlotSelected;

  const TimeSlotSelector({
    super.key,
    required this.workingHours,
    this.onSlotSelected,
  });

  @override
  State<TimeSlotSelector> createState() => _TimeSlotSelectorState();
}

class _TimeSlotSelectorState extends State<TimeSlotSelector>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String? selectedSlot;

  DateTime? minStart;
  DateTime? maxEnd;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _computeMinMaxTimes();
  }

  void _computeMinMaxTimes() {
    final all = widget.workingHours!.toJson().values;
    final valid = all.where((s) => s != null && s != '00:00 - 00:00');

    for (var range in valid) {
      final parts = range!.split(' - ');
      if (parts.length != 2) continue;

      final start = DateFormat.Hm().parse(parts[0]);
      final end = DateFormat.Hm().parse(parts[1]);

      if (minStart == null || start.isBefore(minStart!)) minStart = start;
      if (maxEnd == null || end.isAfter(maxEnd!)) maxEnd = end;
    }
  }

  List<String> generateHourlyLabels() {
    final labels = <String>[];
    if (minStart == null || maxEnd == null) return labels;

    var current = minStart!;
    while (!current.isAfter(maxEnd!)) {
      labels.add(DateFormat('hh:00 a').format(current));
      current = current.add(const Duration(hours: 1));
    }

    return labels;
  }

  bool isInRange(DateTime dt, int fromHour, int toHour) {
    final hour = dt.hour;
    return hour >= fromHour && hour < toHour;
  }

  List<String> getSlotsFor(String tab) {
    final allSlots = generateHourlyLabels();

    return allSlots.where((label) {
      final time = DateFormat('hh:00 a').parse(label);

      if (tab == 'morning') {
        return isInRange(time, 0, 12);
      } else if (tab == 'afternoon') {
        return isInRange(time, 12, 17);
      } else {
        return isInRange(time, 17, 24);
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final morningSlots = getSlotsFor('morning');
    final afternoonSlots = getSlotsFor('afternoon');
    final eveningSlots = getSlotsFor('evening');

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.orange,
          tabs: const [
            Tab(text: 'Morning'),
            Tab(text: 'Afternoon'),
            Tab(text: 'Evening'),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildSlotList(morningSlots),
              _buildSlotList(afternoonSlots),
              _buildSlotList(eveningSlots),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSlotList(List<String> slots) {
    if (slots.isEmpty) {
      return const Center(child: Text('No slots available'));
    }

    return GridView.builder(
      itemCount: slots.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (_, index) {
        final slot = slots[index];
        final isSelected = selectedSlot == slot;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedSlot = slot;
            });
            if (widget.onSlotSelected != null) {
              widget.onSlotSelected!(slot);
            }
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.orange : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.orange : Colors.grey.shade400,
              ),
            ),
            child: Text(
              slot,
              style: TextStyle(color: isSelected ? Colors.white : Colors.black),
            ),
          ),
        );
      },
    );
  }
}
