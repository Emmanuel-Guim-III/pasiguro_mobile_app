import 'package:flutter/material.dart';

import 'package:pasiguro_mobile_app/logics/item_logic.dart';
import 'package:pasiguro_mobile_app/models/item_model.dart';
import 'package:pasiguro_mobile_app/utils/date_time.dart' as date_time;
import 'package:pasiguro_mobile_app/utils/text_field_validator.dart';
import 'package:pasiguro_mobile_app/widgets/date_picker.dart';
import 'package:pasiguro_mobile_app/widgets/my_form_field.dart';

typedef OptionSelected = void Function(String value);

class ItemObject {
  final ItemLogic itemLogic;
  final ItemModel? item;

  ItemObject({
    required this.itemLogic,
    this.item,
  });
}

class ItemAddingForm extends StatefulWidget {
  final ItemObject itemObject;

  const ItemAddingForm({
    Key? key,
    required this.itemObject,
  }) : super(key: key);

  @override
  State<ItemAddingForm> createState() => ItemAddingFormState();
}

class ItemAddingFormState extends State<ItemAddingForm> {
  String nameMem = '';
  String get _name => nameMem;
  set _name(String v) => nameMem = v;

  String priceMem = '';
  String get _price => priceMem;
  set _price(String v) => priceMem = v;

  String quantityMem = '';
  String get _quantity => quantityMem;
  set _quantity(String v) => quantityMem = v;

  String typeMem = '';
  String get _type => typeMem;
  set _type(String v) => typeMem = v;

  String storeMem = '';
  String get _store => storeMem;
  set _store(String v) => storeMem = v;

  DateTime dateOfPurchaseMem = date_time.getNowDateOnly();
  DateTime get _dateOfPurchase => dateOfPurchaseMem;
  set _dateOfPurchase(DateTime v) => dateOfPurchaseMem = v;

  final _formKey = GlobalKey<FormState>();

  late List<ItemModel> _itemsList;

  bool _isEditingMode = false;

  @override
  void initState() {
    super.initState();

    _setItemFields();

    _isEditingMode = widget.itemObject.item!.id != null;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (!_isEditingMode) {
      _setItemsList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add an item'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 10,
                  ),
                  child: !_isEditingMode
                      ? _buildAutoPopulationField()
                      : MyFormField.textField(
                          label: 'Name',
                          value: _name,
                          onValidate: (v) => TextFieldValidator.validate(v),
                          onTapped: () {
                            _formKey.currentState!.reset();
                          },
                          onChanged: (v) {
                            setState(() {
                              _name = v;
                            });
                          },
                        ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: MyFormField.priceField(
                    label: 'Price',
                    value: _price,
                    onValidate: (v) => TextFieldValidator.validate(v),
                    onTapped: () {
                      _formKey.currentState!.reset();
                    },
                    onChanged: (v) {
                      setState(() {
                        _price = v;
                      });
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: MyFormField.textField(
                    label: 'Quantity',
                    value: _quantity,
                    onValidate: (v) => TextFieldValidator.validate(v),
                    onTapped: () {
                      _formKey.currentState!.reset();
                    },
                    onChanged: (v) {
                      setState(() {
                        _quantity = v;
                      });
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: MyFormField.textField(
                    label: 'Type',
                    value: _type,
                    onValidate: (v) => TextFieldValidator.validate(v),
                    onTapped: () {
                      _formKey.currentState!.reset();
                    },
                    onChanged: (v) {
                      setState(() {
                        _type = v;
                      });
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: MyFormField.textField(
                    label: 'Store',
                    value: _store,
                    onValidate: (v) => TextFieldValidator.validate(v),
                    onTapped: () {
                      _formKey.currentState!.reset();
                    },
                    onChanged: (v) {
                      setState(() {
                        _store = v;
                      });
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: DatePicker(
                    label: 'Date of Purchase',
                    value: _dateOfPurchase,
                    onChanged: (v) {
                      setState(() {
                        _dateOfPurchase = v;
                      });
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () => _saveItem(widget.itemObject.item!.id),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildAutoPopulationField() {
    return Autocomplete(
      optionsBuilder: (TextEditingValue value) {
        if (value.text.isEmpty) {
          return const Iterable<String>.empty();
        }

        return _itemsList.where((item) =>
            item.name.toLowerCase().contains(value.text.toLowerCase()));
      },

      //
      optionsViewBuilder: (
        context,
        OptionSelected onSelected,
        options,
      ) {
        return Material(
          elevation: 4,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (ctx, idx) {
              final ItemModel option = options.elementAt(idx) as ItemModel;

              return ListTile(
                title: Text(option.name),
                subtitle: Text(option.store),
                onTap: () {
                  _autoPopulateAllFields(option);
                  onSelected(option.name);
                },
              );
            },
            separatorBuilder: (ctx, idx) => const Divider(),
            itemCount: options.length,
          ),
        );
      },

      //
      fieldViewBuilder: (
        context,
        controller,
        focusNode,
        onEditingComplete,
      ) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Name',
          ),
          onChanged: (v) {
            setState(() {
              _name = v;
            });
          },
        );
      },
    );
  }

  Future<void> _saveItem(int? id) async {
    if (_formKey.currentState!.validate()) {
      final item = ItemModel(
        id: id,
        name: _name,
        price: _price,
        type: _type,
        quantity: _quantity,
        store: _store,
        dateOfPurchase: _dateOfPurchase,
        inventoryDateTime: date_time.getDateTimeNow(),
      );

      if (id == null) {
        await widget.itemObject.itemLogic.createItem(item);
      } else {
        await widget.itemObject.itemLogic.updateItem(item);
      }

      Navigator.pop(context);
    }
  }

  Future<void> _setItemsList() async {
    final items = await widget.itemObject.itemLogic.getItems();

    setState(() {
      _itemsList = items;
    });
  }

  void _setItemFields() {
    _name = widget.itemObject.item!.name;
    _price = widget.itemObject.item!.price;
    _quantity = widget.itemObject.item!.quantity;
    _type = widget.itemObject.item!.type;
    _store = widget.itemObject.item!.store;
    _dateOfPurchase = widget.itemObject.item!.dateOfPurchase;
  }

  void _autoPopulateAllFields(ItemModel item) {
    setState(() {
      _name = item.name;
      _price = item.price;
      _quantity = item.quantity;
      _type = item.type;
      _store = item.store;
      _dateOfPurchase = item.dateOfPurchase;
    });
  }
}
