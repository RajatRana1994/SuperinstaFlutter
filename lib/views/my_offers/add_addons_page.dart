import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../utils/baseClass.dart';
import '../../widgets/currency_widget.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/form_input_with_hint_on_top.dart';
import '../../widgets/rounded_edged_button.dart';

class AddAddonsPage extends StatefulWidget {
  final Function onTap ;
  final Map<String, dynamic> addOnList;
  const AddAddonsPage( {super.key,required this.addOnList, required this.onTap});

  @override
  State<AddAddonsPage> createState() => _AddAddonsPageState();
}

class _AddAddonsPageState extends State<AddAddonsPage> with BaseClass {
  TextEditingController nameController = TextEditingController();
  TextEditingController deliveryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final List<int> _numbers = List.generate(90, (i) => i + 1);
  int? _selectedNumber;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.addOnList.isNotEmpty){
      nameController.text =widget.addOnList['title'];
      priceController.text =widget.addOnList['price'];
      _selectedNumber =widget.addOnList['workingDays'];
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,

        title: Text(
          'Add Addon',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            FormInputWithHint(
              label: 'Name',
              hintText: 'Title fof your project',
              controller: nameController,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Delivery',
                        textAlign: TextAlign.left,
                        style: AppStyles.font400_14().copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      CustomDropdown<int?>(
                        items: _numbers,
                        height: 48,
                        hint: 'Select Time',
                        selectedValue: _selectedNumber,
                        onChanged: (value) async {
                          setState(() {
                            _selectedNumber = value;
                          });
                        },
                        labelBuilder: (c) => '$c days',
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: FormInputWithHint(
                    label: 'Price',
                    hintText: 'Price',
                    keyboardType: TextInputType.number,

                    controller: priceController,
                    prefixIcon: GetCurrencyWidget(),
                    isDigitsOnly: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            RoundedEdgedButton(
              buttonText: 'Add',
              onButtonClick: () {
                String name  =  nameController.text.trim();
                String price  =  priceController.text.trim();
                if(name.isEmpty){
                  showError(title: 'Name', message: 'Please add name');
                }
                else if(price.isEmpty){
                  showError(title: 'Price', message: 'Please add price');
                }
                else if(_selectedNumber==null){
                  showError(title: 'Delivery', message: 'Please choose delivery time');
                }
                else{
                  widget.onTap(name ,  price, _selectedNumber);
                  popToPreviousScreen(context: context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
